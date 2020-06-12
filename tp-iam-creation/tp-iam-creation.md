# Création d'un security group et attachement d'une Clé SSH

Cet exercice a pour objectif :
* découvrir les utilisateurs et les groupes IAM
* de créer un utilisateur et un groupe 

Durée : 20 à 30 minutes

## Découverte des utilisateurs et groupes
* Dans la console web d'AWS, cliquer sur Services puis sur IAM 
* Dans le menu de Gauche, cliquer sur Users, que voyez vous ?
* Choisir un utilisateur et afficher ses permissions, qu'est ce que l'utilisateur est autorisé à faire pour vous d'après ses permissions ?
* Dans le menu de gauche, cliquer sur Groups, que voyez vous ?
* Choisir un groupe et vérifier les permissions, y'a t'il des permissions différentes de celle de l'utilisateur ?
* Choisir une permission et voir ce qu'elle contient. Qu'est ce qui compose une permission ?

## Création d'un groupe et ajout de permission
* Revenir dans le menu Groups et créer un groupe qui sera utilisé pour votre application
* Créer un utilisateur et l'ajouter à ce groupe 
* Assigner les permissions à ce groupes permettant de manipuler les instances EC2 seulement
* Connecter vous avec cet utilisateur et vérifier qu'il ne peut pas accéder à IAM, mais qu'il peut bien manipuler les EC2.


