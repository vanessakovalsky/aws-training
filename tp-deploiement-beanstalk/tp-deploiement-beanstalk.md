# Déploiement d'une application avec Beanstalk

Cet exercice permet de déployer une application en utilisant AWS Beanstalk et en s'appuyant sur Amazon Elasticache. Elle permet également de découvrir les problèmes engendrer par la scalabilité, et un moyen de le résoudre en externalisant les sessions. 

Les objectifs de cet exerice sont les suivants :
* Gérer son code en utilisant un gestionnaire de version de code
* Déployer son application avec Beanstalk
* Externaliser les sessions pour améliorer la scalabilité

Durée entre 60 et 90 minutes

## Pré-requis
* Savoir créé une instance EC 2 et se connecter en SSH dessus, si besoin les étapes sont disponibles ici :
https://github.com/vanessakovalsky/aws-training/blob/master/tp-first-ec2-instance/tp-first-ec2-instance.md

## Créer une instance EC2 et se connecter dessus
* Dans la console web, créer une instance EC2 de type t2.micro avec une image Amazon Linux 2
* Associer sa clé ssh à cette instance
* Se connecter en SSH à cette instance

## Installer et configurer git
Nous allons utiliser git pour gérer le code source, pour cela nous avons besoin de l'installer sur l'instance et de le configurer.
* Pour installer git utiliser la commande :
```
sudo yum install git -y
```
* Puis configurer votre nom d'utilisateur pour git :
```
git config --global user.name "NAME"
```
* Enfin configurer l'adresse email à associer à votre compte git :
```
git config --global user.email "EMAIL"
```

Git est maintenant installé et configurer, nous allons pouvoir récupérer le code et initialiser le dépôt git

## Récupérer le code source de l'application
* Commencer par créer un dossier appelé code et à se placer à l'intérieur :
```
mkdir ~/code
cd ~/code
```
* Créer un dossier pour l'application et se positionner dedans
```
mkdir app
cd app
```
* Récupérer et décompresser l'archive dans le dossier 
```
curl -sL http://d118jxrmrxsq90.cloudfront.net/turn-based.tar | tar -xv
```

## Initialiser le dépôt git
* Initialiser un dépôt et ajouter le code dans ce depôt:
 ```
git init
git add -A .
git status
 ```
 * Sauvegarder via un commit ces modifications
 ```
git commit -m "First commit: v1"
 ```
 * Ajouter un tag pour la v1 de l'application
 ```
git tag -a v1 -m "v1"
 ```

 -> Félicitation, le code est maintenant géré en version par Git. Sur un projet réel, de nombreuses modifications seraient apportées au code puis commités (sauvegardés) avant le déploiement. Ici la version est utilisable en l'état sans besoin de faire des modifications.

 ## Initialiser AWS Beanstalk
 On va maintenant initialiser un environnement pour Beanstalk ainsi que notre application dans Beanstalk
 * Pour commencer, installer la dernière version de l'outil CLI de AWS Beanstalk avec les commandes :
 ```
cd ..
yum groupinstall "Development Tools"
sudo yum install zlib-devel openssl-devel ncurses-devel libffi-devel sqlite-devel.x86_64 readline-devel.x86_64 bzip2-devel.x86_64 -y
git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git
./aws-elastic-beanstalk-cli-setup/scripts/bundled_installer
 ```
 * Initialiser l'environnement Beanstalk avec la commande 
 ```
cd app/application
eb init 
 ```
 * Vous devez alors répondre à une série de questions :
 * * Select a default region : choisir le numéro de la région us-east-2
 * * Enter Application name : app
 * * Select a platform version : 6 (NodeJS)
 * * Select a platform branch : 1
 * * Do you want to continue with AWS CodeCommit : n
 * * Do you want to set up SSH for your instances : y
 * * Select a key pair : créer la clé en suivant les instructions
    
 La configuration de l'application dans Beanstalk a été créé. Elle est stockée dans un dossier .elasticbeanstalk à l'intérieur du dossier de l'application (app dans notre cas)

 ## Déployer l'application 
* Pour déployer l'application il faut créer l'environnement avec la commande :
```
eb create
```
(sauf le nom laisser les autres options par défaut)
-> l'environnement met plusieurs minutes à s'initialiser, à la fin il vous affiche le nom de domaine de l'environnement, et le statut ready.
* Vous pouvez consulter le statut du déploiement avec 
```
eb status
```
* Ou encore aller voir dans la console web d'AWS dans Service > Elastic Beanstalk, en cliquant sur environnement puis sur le nom de votre environnement
* Dans la console, vous pouvez également voir les éléments créé pour l'environnement, quels sont les ressourcés créés pour cet environnement ?

-> Félicitations, votre application est déployée

## Mettre à jour son application
* Vous pouvez modifier les fichiers, du code, les sauvegardé avec commit, ajouter un tag et souhaitez de nouveau déployer votre application.
* Pour redéployer l'application, utiliser la commande :
```
eb deploy 
```
* Répondre aux questions, et une fois le déploiement terminé allez vérifier votre mise à jour.

-> Vous savez maintenant déployer une application avec AWS Beanstalk

## Pour aller plus loin 
* vous pouvez maintenant installer eb cli sur votre propre poste, et déployer dans un environnement AWS depuis votre environnement de travail (et non depuis une instance EC2)
L'installation de ces outils pour chaque OS est détaillée ici : https://github.com/aws/aws-elastic-beanstalk-cli-setup 

* N'hésitez pas à utiliser Elastic Beanstalk sur vos propres projets et à aller approfondir ces options de déploiements (pour une BDD par exemple)
