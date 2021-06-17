# TP 2 - Déployer une stack avec cloud formation

Ce TP a pour objectif : 
* de déployer une stack pour une application web dans AWS avec Cloud Formation
* de pouvoir mettre à jour cette stack en modifiant les modèles

## Création de la stack

* Vous devez créer des templates pour cloud formations pour les éléments suivants : 
    * un VPC (et l'ensemble des ressources nécessaires associées pour pouvoir utiliser une instance en serveur web)
    * une instance ec2  qui déploiera le même stack LAMP (Apache, PHP, MaraiDB) que sur le TP précédent 
    * un bucket s3

Vous aurez alors une architecture qui ressemblera à celle ci 
![Architecture TP2](https://www.wellarchitectedlabs.com/Reliability/200_Deploy_and_Update_CloudFormation/Images/StackUpdates.png)

## Script de déploiement de la stack

* Créer un script qui va à l'aide de AWS CLI lancer la création de la stack à partir de vos fichiers de templates
* Ce script devra permettre de choisir entre le déploiement d'une nouvelle stack (pile) ou la mise à jour d'une pile existante (suite à une modification de template par exemple)
* Ajouter des paramètres dans les templates, de sorte à pouvoir choisir le type d'instance à utiliser, l'image à utiliser et le nom du bucket que l'on crée.

-> Rendre une archive zip avec les fichier YAML ou JSON de template et le script via Teams

## Pour aller plus loin 

* Transformer l'installation de l'application wordpress du TP précédent en nouvelle image AMI et modifier l'image utilisé dans le template
* Ajouter un template pour une base RDS dans la stack
* Transformer l'application en image de container et créer un template de cluster ECS avec un tache qui contient l'image de conteneur crée et l'execute dans la stack