TP 1 - Automatisation de l'installation d'un site web sur AWS

L'objectif de ce TP est de créer un script qui va installer une application web en PHP / SQL sur AWS dans l'infrastructure suivante : 
* un VPC 
* une instance EC2 sous Linux
* une BDD mysql sur Amazon RDS  

Ce script comportera des commandes AWS-CLI pour créer l'ensemble des ressources nécessaires et déployer le site.

## Consignes de déploiement de l'application
* Elle a besoin d'Apache2, de PHP7, de composer ainsi que des extensions suivantes de PHP : BCMath PHP Extension, Ctype PHP Extension, Fileinfo PHP extension
JSON PHP Extension, Mbstring PHP Extension, OpenSSL PHP Extension, PDO PHP Extension, Tokenizer PHP Extension, XML PHP Extension 
* Se positionner dans le dossier web (/var/www/html)
* L'application se trouve ici : https://github.com/vanessakovalsky/laravel-kingoludo (il faut donc faire un git clone sur le serveur web)
* Une fois l'application clonée, lancer la commande composer install 
* 
