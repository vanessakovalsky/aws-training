# Création d'un container, stockage sur un registre ECR et utilisation de ECS en tant que cluster pour notre application containerisée

Cet exercice a pour objectifs :
* De créer un premier conteneur
* De le stocker sur un registre ECR
* De déployer le conteneur au sein d'un cluster ECS

Durée : entre 45 et 60 minutes

## Pré-requis 
* Afin de simplifier l'utilisation de docker, nous utiliserons une instance EC2 pour créer et manipuler le conteneur 
* Créer une instance EC2 de type t2.micro avec une image Amazon Linux 2
* Il est nécessaire de se connecter en SSH à cette image

## Installation de docker et lancement de docker
* Une fois connecté en SSH sur l'instance EC2, installer docker avec les commandes suivantes :
```
sudo yum update -y
sudo amazon-linux-extras install docker
```
* Lancer le service docker pour pouvoir l'utiliser 
```
sudo service docker start
```
* Ajouter l'utilisateur courant (ec2-user) au groupe docker pour pouvoir utiliser Docker sans passer par le compte admin (root)
```
sudo usermod -a -G docker ec2-user
```
* Déconnecter vous de la session SSH et reconnectez vous pour appliqur les modifications de droits que nous venons de faire
* Une fois reconnecté, vérifier que cela fonctionne avec la commande :
```
docker info
```

## Création d'un premier conteneur 
Docker utilise un fichier appelé Dockerfile qui contient les instructions à éxecuter lors de l'initialisation du conteneur et de son lancement
* Créer un fichier Docker file avec la commande :
```
touch Dockerfile
```
* Modifier le fichier (l'éditeur nano est installé, vous pouvez ajouter un autre éditeur de texte de votre choix si besoin) et ajouter les instructions suivantes :
```
FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && \
 apt-get -y install apache2

# Install apache and write hello world message
RUN echo 'Hello World!' > /var/www/html/index.html

# Configure apache
RUN echo '. /etc/apache2/envvars' > /root/run_apache.sh && \
 echo 'mkdir -p /var/run/apache2' >> /root/run_apache.sh && \
 echo 'mkdir -p /var/lock/apache2' >> /root/run_apache.sh && \ 
 echo '/usr/sbin/apache2 -D FOREGROUND' >> /root/run_apache.sh && \ 
 chmod 755 /root/run_apache.sh

EXPOSE 80

CMD /root/run_apache.sh
```
* Ce fichier contient différentes instructions :
* * From : indique l'image utilisé comme base pour celle-ci
* * Les commandes RUN permettent d'executer des actions lors du build du conteneur, ici respectivement :
* * * Mise à jour des paquets et installation du serveur web Apache
* * * Création d'un fichier html
* * * Création d'un script run_apache.sh
* * Expose permet d'exposer le port indiqué à l'extérieur du conteneur (ce qui nous permet depuis l'extérieur du conteneur d'accèder dans ce cas là au serveur web)
* * CMD permet de lancer une commande lorsque l'on instancie le conteneur (action de lancer le conteneur, idem au démarrage d'une machine)
* Ensuite nous lancer le build de notre image docker à partir du fichier que l'on vient de crééer 
```
docker build -t hello-world-monprenom .
```
* Une fois le build terminer, vérifier que l'image construite soit disponible avec :
 ```
docker images --filter reference=hello-world-monprenom
 ```
 * Devrait afficher :
 ```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world-monprenom         latest              e9ffedc8c286        4 minutes ago       241MB
 ```
 * Puis lancer un conteneur à partir de cette image:
 ```
docker run -t -i -p 80:80 hello-world-monprenom
 ```
 * Vous obtenez alors un log apache, ne pas quitter ou fermer le terminal pour l'instant, c'est lui qui fait tourner le conteneur
 * Ouvrir un autre onglet et rentrer l'adresse de votre instance EC2 (la même que vous utiliser pour SSH)
 * Une page devrait s'afficher avec le contenu Hello World

 ## Transmettre notre image à un registre ECR
Maintenant que l'image de notre application est prête nous allons la stocker sur un registre d'image. Cela permet par la suite d'utiliser directement l'image stocké, sans avoir besoin de la builder de nouveau.
* Il est nécessaire de mettre à jour le cli de AWS sur l'instance EC2, pour cela on utilise les commandes :
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install  
```
* Puis on se connecte au registre ECR :
```
/usr/local/bin/aws ecr get-login-password | docker login --username AWS --password-stdin 433676120466.dkr.ecr.us-east-2.amazonaws.com/demo-repository
```
* Enfin on envoit son image 
```
docker push 433676120466.dkr.ecr.us-east-2.amazonaws.com/demo-repository
```
* On vérifie dans la console web, dans Services > ECR
* On clique sur Demo-repository
* La liste des images apparait, retrouver la votre

-> Votre image est maintenant prête à être déployer dans un cluster de conteneurs

## Création d'un cluster 

* Dans la console web, cliquer sur Services puis sur ECS
* Dans le menu en haut, cliquer sur votre nom, puis sur Switch Role, choisir le Rôle Administrator (cela vous permet d'avoir les bonnes permissions)
* Dans le menu de Gauche, dans le sous menu Amazon ECS cliquer sur Clusters
* Cliquer sur Create cluster 
* Sélectionner le template : EC2 Linux + Networking
* Puis sur Next Steps
* Remplir les champs comme suit :
* * CLuser name : Cluster de MONPRENOM
* * Provisioning Model : On-demand instance
* * EC2 instances types : t2.micro
* * Number of instance : 1 
* * EC2 AMI : Amazon Linux 2 AMI
* * Root EBS Volume Size (GiB) : 10
* * Key pair : None
* Laisser les autres options par défaut et cliquer sur Create en bas de la page
* Cliquer sur View cluster en haut de la page une fois la création terminé pour revenir sur la page du cluster.

## Ajout d'une tache à notre cluster à partir de notre image
* Dans le menu de gauche, sous Amazon ECS, clique sur Task definition
* Cliquer sur Create new task definition 
* Choisir EC2 puis cliquer sur Next Step
* Remplir les champs suivants (en adaptant avec vos valeurs et en laissant les autres par défaut)
* * Task Definition Name : TaskDePrenom
* * Container définition, cliquer sur Add COntainer et remplir les champs suivants :
* * * Container Name : ContainerDePrenom
* * * Container image : 433676120466.dkr.ecr.us-east-2.amazonaws.com/demo-repository:latest  (/!\ à adapter avec votre image)
* * * Ports Mappings : 80 80 tcp
* * * Memory limits : Hard Limits 512
* * Cliquer sur Create

* Revenir dans le menu de gauche sur Amazon ECS > Cluster
* Cliquer sur votre cluster
* Aller dans l'onglet tasks 
* Cliquer sur Run new task
* * Launch Type : EC2
* * TaskDefinition : Votre tache crée juste avant
* * Cliquer sur Run task en bas de la page pour initiliser votre conteneur dans votre cluster
* Revenir sur votre cluster
* Cliquer sur l'onglet ECS instance
* Cliquer sur votre instance
* Copier son DNS
* Coller le dans un nouvel onglet
* Une page avec Hello World devrait alors s'afficher 

-> Votre conteneur est lancé 

## Pour aller plus loin 
* Essayer d'arreter l'instance et de voir ce qu'il se passe au bout de quelques minutes sur le cluster ?
* Ajouter des taches à votre cluster avec la même définition ou une autre.
* Ajouter un service à partir de la même tache pour activer le load balancing. 
