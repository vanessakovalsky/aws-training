# Création d'une première instance EC2

Cet exercice a pour objectif:
* de créer une instance EC2 
* de monitorer l'instance créé
* d'utiliser les groupes de sécurité
* de redimensionner l'instance créé et le stockage
* de découvrir les limites d'une instance EC2
* de créer une image AMI à partir d'une instance EC2

Durée : 45 à 60 minutes

## Pré-requis 
* Pour se connecter sur une instance il est nécessaire d'avoir un outil SSH (open ssh sur Linux / MacOS, Cygwin ou Putty sur Windows)

## Création de l'instance EC2
* Dans la console, cliquer sur Services puis sur EC2
* Dans le menu de gauche, cliquer sur Instances
* Cliquer alors sur Launch Instance qui permet de créer une instance
* Une série d'étape est alors à suivre :
* * Nom : mettre WebServer de [votre-nom] 
* * Choose an Amazon Machine Image (AMI)
* * * Choisir Amazon Linux 2 AMI 
* * * Cliquer sur continuer
* * Choose an instance type :
* * * Choisir t2.micro
* * * Cliquer sur continuer
* * Paire de clé :
* * * Cliquer sur créer une paire de clé
* * * Une fenêtre pour l'ajout de clé SSH apparait
* * * * Choisir : Create a new key pair
* * * * Entrer votre nom
* * * * Cliquer sur Download Key pair
* * * * Vous récupérer alors la clé qui vous permettra de vous connecter sur votre machine
* * Paramètre réseau :
* * * Configure Security Group : Le groupe de sécurité permet de gérer un firewall virtuel sur votre instance
* * * Laisser coché : Create a new security group
* * * Security group name : Groupe de securité de [votre-nom]
* * * Laisser la règle SSH en place
* * Configure Storage
* * * AWS propose par défaut un stockage sur un disque SSD de 8 Go
* * * Laisser les options par défaut et cliquer sur Next : add tags
* * Advanced Details :
* * * Lisez les options proposées sans les modifier
* * * Dans user data, coller les commandes suivantes (qui seront alors exécutées au lancement de l'instance, et qui permettent d'installer et de démarrer Apache le serveur web) 
```
#!/bin/bash
yum -y install httpd
systemctl enable httpd
systemctl start httpd
echo '<html><h1>Hello From Your Web Server!</h1></html>' > /var/www/html/index.html
```
* Cliquer sur Launch Instance pour lancer votre instance
* ouvrir votre outil SSH et se connecter à l'instance avec la clé téléchargée (vous pouvez récupérer les commandes de connexions dans l'écran de l'instance en cliquant sur Se connecter )
-> Félicitation votre instance fonctionne :) 

## Monitorer son instance
* Revenir sur la console AWS
* Dans le menu de gauche du service EC2, cliquer sur Instances, puis sur la ligne correspondant à votre instance
* Cliquer sur l'onglet Monitoring
* Que voyez vous ?
* Dans le menu Actions, choisir Surveiller et dépanner > Get system logs
* Qu'est ce qui s'affiche alors ?
* Dans le menu Actions, choisir Surveiller et dépanner > Get instance screenshot
* Vous récupérer alors une image qui affiche la console de votre machine, en cas d'erreur ou d'impossibilité de connexion SSH à votre instance, cela vous permettra de débugguer

## Accéder à son instance sur le web

* Dans la console, sur votre instance cliquer sur Description
* Récupérer l'adresse IPv4 de votre machine et coller la dans un onglet de votre navigateur
* Que constatez vous ?
* Retourner sur la console, dans la page de votre instance, cliquer sur l'onglet Sécurité puis sur le lien vers votre groupe de sécurité
* Cliquer sur l'onglet Inbound Rules
* Cliquer sur Edit Inbound rules pour accéder à la modification
* CLiquer sur Add rule pour ajouter la règle suivante :
* * Type: HTTP
* * Source : Anywhere
* Cliquer sur Save Rules
* Retourner sur l'onglet avec l'IP de l'instance, et raffraichir la page
* Votre page devrait s'afficher avec le message : 
Hello From Your Web Server!

## Redimensionner l'instance
Il est nécessaire d'arrêter l'instance avant de la redimensionner.
* Dans la console, cliquer sur EC2
* Puis dans le menu de gauche sur Instances
* Cliquer sur le nom de votre instance
* Puis dans le menu Actions, choisir Instance State > Stop
* Confirmer en cliquant sur Yes, stop
* Attendre que l'état de l'instance soit bien sur Stopped
* Pour changer le type d'instance, aller dans le menu action (en laissant l'instance concernée sélectionnée), puis choisir Instance Settings > Change instance type
* Choisir alors le type : t3.small
* Cliquer sur Apply
L'instance est redimensionnée, il est nécessaire de la redémarrer
* Dans le menu Actions, choisir Instance state > Start
* Cliquer sur Yes, start
-> Félicitations, votre instance est redimensionné et fonctionne de nouveau

## Voir les limites des instances
* Dans le service EC2 de la console web, cliquer sur Limits dans le menu de Gauche
* Vous pouvez alors voir les limites, et filtrer en cliquant sur All limits pour changer les limites afficher.
* Quels sont les limites de nombre d'instances par région (vérifier pour quelques régions)?

## Créer une image AMI à partir de son instance
* Revenir à la liste des instances en cliquant sur instances dans le menu de gauche
* Sur la ligne qui correspond à votre instance, faire un clic droit puis aller dans Images puis cliquer sur Create an image
* Donner un nom à votre image et une description
* Cliquer sur Create an image
* Votre image est maintenant créer
* Résilier votre première instance, et recréer une autre instance EC2 à partir de l'image que vous avez crée. Vous devriez alors pouvoir directement accéder à la page web qui affiche le message Hello From Webserver !

-> Félicitations, vous savez manipuler les instances EC2 d'AWS

/!\ Penser à éteindre votre instance avant de quitter la console 
