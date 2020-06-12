# Création d'une première instance EC2

Cet exercice a pour objectif:
* de créer une instance EC2 
* de monitorer l'instance créé
* d'utiliser les groupes de sécurité
* de redimensionner l'instance créé et le stockage
* de découvrir les limites d'une instance EC2

Durée : 45 à 60 minutes

## Pré-requis 
* Pour se connecter sur une instance il est nécessaire d'avoir un outil SSH (open ssh sur Linux / MacOS, Cygwin ou Putty sur Windows)

## Création de l'instance EC2
* Dans la console, cliquer sur Services puis sur EC2
* Dans le menu de gauche, cliquer sur Instances
* Cliquer alors sur Launch Instance qui permet de créer une instance
* Une série d'étape est alors à suivre :
* * Step 1 : choose an Amazon Machine Image (AMI)
* * * Choisir Amazon Linux 2 AMI 
* * * Cliquer sur continuer
* * Step 2 : choose an instane type :
* * * Choisir t2.micro
* * * Cliquer sur continuer
* * Step 3: Configure Instance Details :
* * * Lisez les options proposées sans les modifier
* * * Dans user data, coller les commandes suivantes (qui seront alors exécutées au lancement de l'instance, et qui permettent d'installer et de démarrer Apache le serveur web) 
```
#!/bin/bash
yum -y install httpd
systemctl enable httpd
systemctl start httpd
echo '<html><h1>Hello From Your Web Server!</h1></html>' > /var/www/html/index.html
```
* * * Cliquer sur Next : add storage
* * Step 4: Add Storage
* * * AWS propose par défaut un stockage sur un disque SSD de 8 Go
* * * Laisser les options par défaut et cliquer sur Next : add tags
* * Step 5: Add Tags
* * * Cliquer sur Add tag pour saisir un tag 
* * * Key : name
* * * Value : WebServer de [votre-nom]
* * * Cliquer sur Next : configure security group
* * Step 6: Configure Security Group
Le groupe de sécurité permet de gérer un firewall virtuel sur votre instance
* * * Laisser coché : Create a new security group
* * * Security group name : Groupe de securité de [votre-nom]
* * * Laisser la règle SSH en place
* * Cliquer sur Launch 
* Une fenêtre pour l'ajout de clé SSH apparait
* * Choisir : Create a new key pair
* * Entrer votre nom
* * Cliquer sur Download Key pair
* Vous récupérer alors la clé qui vous permettra de vous connecter sur votre machine
* Cliquer sur Launch Instance pour lancer votre instance
* ouvrir votre outil SSH et se connecter à l'instance avec la clé téléchargée 
-> Félicitation votre instance fonctionne :) 

## Monitorer son instance
* 
