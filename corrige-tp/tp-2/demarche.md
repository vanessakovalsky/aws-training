# Démarche pour le TP 2

## Fichier de template à créer : 

Il est nécessaire de préparer les fichiers de templates suivants : 
* Un modèle de VPC qui contient les ressources et les paramètres pour :
    * VPC
    * Internet Gateway
    * Attachement de internet gateway
    * Table De Route
    * Route
    * Sous réseau
* Un modèle d'instance EC2 qui contient les ressources et les paramètres pour : 
    * Groupe de sécurité (et ses règles)
    * Instance EC2 
/!\ La création de la paire de clé SSH ne peut pas être faite via cloud formation 

* Un modèle de bucket S3 

## Script
Le script doit effectuer les actions suivantes : 
* Création du vpc et récupération des paramètres nécessaire à l'instance 
* Création de l'instance EC2 
* Création du Bucket S3

* Faire un input pour proposer soit la création du stack soit la mise à jour:
    * en cas de création créer la stack
    * en cas de MAJ mettre à jour la stack existante