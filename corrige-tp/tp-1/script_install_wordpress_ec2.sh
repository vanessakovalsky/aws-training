#!/bin/bash

# Définition des variables nécessaires :
AWS_REGION=$(aws ec2 describe-availability-zones --output text --query 'AvailabilityZones[0].[RegionName]')
VPC_NAME="Vanessa VPC"
VPC_CIDR="10.0.0.0/16"
SUBNET_PUBLIC_CIDR="10.0.1.0/24"
SUBNET_PUBLIC_AZ=$AWS_REGION"a"
SUBNET_PUBLIC_NAME="10.0.1.0 - "$AWS_REGION"a"
SUBNET_PRIVATE_CIDR="10.0.2.0/24"
SUBNET_PRIVATE_AZ=$AWS_REGION"b"
SUBNET_PRIVATE_NAME="10.0.2.0 - "$AWS_REGION"b"
CHECK_FREQUENCY=5
KEY_NAME="vanessa_key"
IMAGE_ID="ami-00c08ad1a6ca8ca7c"

# Creation VPC
echo "Creation VPC"
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $VPC_CIDR \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text )
echo "  VPC ID '$VPC_ID' CREATED in '$AWS_REGION' region."

# Creation sous-réseau Public 
echo "Creation sous-réseau Public "
SUBNET_PUBLIC_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PUBLIC_CIDR \
  --availability-zone $SUBNET_PUBLIC_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text )
echo "  Subnet ID '$SUBNET_PUBLIC_ID' CREATED in '$SUBNET_PUBLIC_AZ'" \
  "Availability Zone."

# Create Private Subnet
echo "Creating Private Subnet..."
SUBNET_PRIVATE_ID=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PRIVATE_CIDR \
  --availability-zone $SUBNET_PRIVATE_AZ \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text )
echo "  Subnet ID '$SUBNET_PRIVATE_ID' CREATED in '$SUBNET_PRIVATE_AZ'" \
  "Availability Zone."

# Create Internet gateway
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
  --output text )
echo "  Internet Gateway ID '$IGW_ID' CREATED."

# Attach Internet gateway to your VPC
aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID \
  --internet-gateway-id $IGW_ID 
echo "  Internet Gateway ID '$IGW_ID' ATTACHED to VPC ID '$VPC_ID'."

# Create Route Table
echo "Creating Route Table..."
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text )
echo "  Route Table ID '$ROUTE_TABLE_ID' CREATED."

# Create route to Internet Gateway
RESULT=$(aws ec2 create-route \
  --route-table-id $ROUTE_TABLE_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID )
echo "  Route to '0.0.0.0/0' via Internet Gateway ID '$IGW_ID' ADDED to" \
  "Route Table ID '$ROUTE_TABLE_ID'."

# Associate Public Subnet with Route Table
RESULT=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_PUBLIC_ID \
  --route-table-id $ROUTE_TABLE_ID )
echo "  Public Subnet ID '$SUBNET_PUBLIC_ID' ASSOCIATED with Route Table ID" \
  "'$ROUTE_TABLE_ID'."

# Enable Auto-assign Public IP on Public Subnet
aws ec2 modify-subnet-attribute \
  --subnet-id $SUBNET_PUBLIC_ID \
  --map-public-ip-on-launch 

echo " 'Auto-assign Public IP' ENABLED on Public Subnet ID" $SUBNET_PUBLIC_ID

# Creation clé SSH

if aws ec2 wait key-pair-exists --key-names $KEY_NAME
    then
    echo 'La clé existe déjà, on la supprime'
    aws ec2 delete-key-pair --key-name $KEY_NAME
fi

if test -f "$KEY_NAME.pem"
    then
    sudo rm -f $KEY_NAME.pem
fi

aws ec2 create-key-pair \
    --key-name $KEY_NAME \
    --query 'KeyMaterial' \
    --output text > $KEY_NAME.pem

chmod 400 $KEY_NAME.pem

echo "Clé SSH crée et prête a être utilisée"

# Création du groupe de sécurité
GROUP_ID=$(aws ec2 create-security-group \
    --group-name SSHAccess \
    --query 'GroupId' \
    --description "Security group for SSH access" \
    --vpc-id $VPC_ID\
    --output text )

echo "Le groupe de sécurité a bien été créé avec l'id "$GROUP_ID

# Ajout des règles pour la connexion SSH

aws ec2 authorize-security-group-ingress \
    --group-id $GROUP_ID \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Ajout des règles pour la connexion HTTP

aws ec2 authorize-security-group-ingress \
    --group-id $GROUP_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

echo 'Les règles de sécurité ont été ajoutées'

# Lancer l'instance EC2

INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $IMAGE_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name $KEY_NAME \
    --security-group-ids $GROUP_ID \
    --subnet-id $SUBNET_PUBLIC_ID\
    --query 'Instances[0].InstanceId' \
    --output text)

echo "L'instance est lancée avec l'ID "$INSTANCE_ID

# Récupérer l'adresse IP Publique de l'instance :
INSTANCE_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text )

# Ajout de quelques éléments pour gérer le fingerprint
ssh-keygen -R $INSTANCE_IP
ssh -o "StrictHostKeyChecking no" $INSTANCE_IP

# Déploiement de l'application

echo "sudo yum update -y
sudo amazon-linux-extras enable php7.4
sudo yum install -y httpd
sudo yum install -y mariadb-server
sudo yum install -y php-cli php-pdo php-fpm php-json php-mysqlnd
sudo service mariadb start
sudo service httpd start
mysqladmin -u root create blog
mysql_secure_installation

cd /var/www/html
sudo wget http://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo mv wordpress/* .
sudo rm -rf wordpress

exit" > script_deploiement.sh

scp -i $KEY_NAME.pem script_deploiement.sh ec2-user@$INSTANCE_IP:/home/ec2-user/

ssh -i $KEY_NAME.pem ec2-user@$INSTANCE_IP sudo chmod +x script_deploiement.sh && sudo ./script_deploiement.sh


echo "déploiement de l'application terminée"
echo "Veuillez effectuer les dernières étapes sur http://"$INSTANCE_IP
