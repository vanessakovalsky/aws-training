# TP 1 - Automatisation de l'installation d'un site web sur AWS

L'objectif de ce TP est de créer un script qui va installer une application web en PHP / SQL sur AWS dans l'infrastructure suivante : 
* un VPC 
* une instance EC2 sous Linux
* une BDD mysql sur Amazon RDS  

Ce script comportera des commandes AWS-CLI pour créer l'ensemble des ressources nécessaires et déployer le site.

## Création des ressources
* Mettre dans le scripts les commandes AWS CLI pour faire les actions suivantes : 
  * Création du VPC
  * Création du groupe de sécurité (ouverture port 22 pour le SSH + 80 pour le web)
  * Création de l'instance EC2 
  * Création de la BDD MariaDB sur Amazon RDS 
* Noter les informations sur la connexion à la BDD qui s'afficheront en retour

## Consignes de déploiement de l'application
* Se connecter
* Elle a besoin d'Apache2, de PHP7 ainsi que des extensions suivantes de PHP : BCMath PHP Extension, Ctype PHP Extension, Fileinfo PHP extension, JSON PHP Extension, Mbstring PHP Extension, OpenSSL PHP Extension, PDO PHP Extension, Tokenizer PHP Extension, XML PHP Extension , voici la commande pour installer l'ensemble des outils :
```
yum install httpd openssl php-common php-curl php-json php-mbstring php-mysql php-xml php-zip

```
* Se positionner dans le dossier web (/var/www/html)
* Récupérer l'archive et la décompresser : 
```
curl https://fr.wordpress.org/latest-fr_FR.tar.gz
tar -xzvf latest-fr_FR.tar.gz . 
```
* Se rendre à l'URL de l'instance et suivre les étapes d'installation de Wordpress

-> Votre site est prêt

-> Pensez à envoyer votre script (ou le lien vers un dépôt) et une capture avec l'URL de votre site installé sur le Teams

## Pour aller plus loin : 

* Il est possible d'automatiser l'installation de wordpress en utilisant wp-cli : https://wp-cli.org/fr/ 
* Rajouter au script cette partie avec l'installation de l'utilitaire et son utilisation 
