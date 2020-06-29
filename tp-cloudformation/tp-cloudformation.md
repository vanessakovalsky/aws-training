# Exercice création d'infrastructure avec les templates de Cloud Formation

Cet exercice permet de créer un bucket S3 à l'aide de CloudFormation
Il a pour objectifs : 
* De créer un tempalte CloudFormation qui créera un bucket S3 nommé : learn-cloudformation-$username (Remplacer $username par votre nom)
* De créer un stack CloudFormation basé sur votre template

## Création du  template
* Télécharger le fichier stub.yaml et l'ouvrir avec l'editeur de texte de votre choix. Ce fichier contient un squelette de départ pour votre template.
* Ajouter une définition `AWSTemplateFormatVersion` à votre template (voir [Template anatomy](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html)).
* Ajouter une Description à votre template (voir [Template anatomy](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html)). 
* Ajouter une section `Resources` à votre template (voir [Template anatomy](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html)).
* Ajouter un bucket **S3 bucket** à la section `Resources` de votre template(Voir [Type de Ressource: S3 bucket](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-s3-bucket.html)).
* Ajouter un BucketName comme seule propriétés de la section 'Properties' du bucket S3. Attention : le nom du bucket doit être unique de manière global
Essayer  `learn-cloudformation-$username` en remplaçant `$username` par votre nom.

## Créer une stack basée sur le template
* Ouvrir le service Cloud Formation dans la console web d'AWS
* Cliquer sur le bouton **Create Stack**
* Choisir  **Upload a template to Amazon S3**.
* Choisir le fichier template que vous avez créer à l'étape précédente
* Cliquer sur le bouton **Next**
* Entrer le nom 'lab1-$username' comme nom de stack
* Passer l'étape suivante en cliquant sur **Next**
* Vérifier votre saisie et cliquer sur le bouton **Create**
* Attendre que la stack atteigne le status : **CREATE_COMPLETE**.
-> Félicitations votre stack est créé à partir de votre template


## Nettoyage : 
* Choisir sa stack, en cliquant sur la ligne du tableau 
* Cliquer sur **Delete Stack** dans le menu **Actions**.
* Confirmer la suppression de votre stack

## Solution
Cet exercice inclus une solution : `sample-solution.yaml`. Utiliser là si vous êtes coincé ou si vous voulez vérifiez votre travail.
