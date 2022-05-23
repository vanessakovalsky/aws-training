# Utiliser lambda pour executer du code 

Cet exercice a pour objectif :
* de mettre du code dans le service Lambda pour qu'il l'execute
* De déclencher l'éxecution du code lors de l'ajout d'un fichier dans un bucket S3 (le code permet de créér une miniature d'image)
* De monitorer l'execution de son code

Durée : 30 à 45 minutes

## Pré-requis
Il est nécessaire d'avoir un bucket S3 existant pour la suite de cet exercice.
Si vous ne savez pas comment le créer :
https://github.com/vanessakovalsky/aws-training/blob/master/tp-s3-storage/tp-s3-storage.md

## Créer la fonction Lambda
* Dans la console web, cliquer sur le menu Services puis sur Lambda
* Cliquer sur Create function 
NB : Les fonctions blueprints sont des fonctions pré-existantes, ici nous allons utilier du code custom, en partant de 0.
* Les options à renseigner pour la création de la fonction :
* * Function name : CreationMiniatureVotrePrenom
* * Runtime : Python 3.7
* Cliquer sur Create Function
* La fonction est créé, nous allons maintenant ajouté le code
* Sur l'écran, cliquer sur + Add triger 
* * Select a trigger : S3
* * Bucket : sélectionner votre bucket
* Laisser les autres paramètres par défaut et cliquer sur Add
* En cliquant maintenant sur CreationMiniatureVotrePrenom , un écran s'affiche en dessous permettant de saisir du code à éxécuter
* Sur cet écran, cliquer sur le menu Actions (à droite) puis sur Upload a file from Amazon S3 : https://s3-us-west-2.amazonaws.com/us-west-2-aws-training/awsu-spl/spl-88/2.3.prod/scripts/CreateThumbnail.zip
* En bas de la page, dans la partie Settings, cliquer sur Edit
* Modifier le Handler pour mettre : CreateThumbnail.handler (il s'agit du nom du fichier et de la fonction a appelé dans le code python importé)
* Cliquer sur Save
-> La fonction est prête, nous allons passer aux tests.

## Tester l'execution de son code avec Lambda
* Commencer par uploader une image sur votre bucket
* Rendre cette image public, afin que Lambda puisse accéder à l'image
* Dans les permissions du rôle crée par Lambda, Ajouter AmazonS3FullAccess comme police
* Créer un nouveau bucket avec le même nom que l'autre en rajoutant -resized au nom du bucket (fonctionnement dans le code, on copie l'image original et on la retaille et l'upload dans ce bucket avec ce nom spécific)
* Sur l'écran de configuration, cliquer Test pour créer un évènement de test
* * Dans Event template, choisir : Amazon S3 Put
* * Event Name : Upload
* * Dans le json généré remplacé les valeurs :
* * * example-bucket par le nom de votre bucket (il se trouve deux fois dans le fichier)
* * * pour la clé de l'image (en bas du fichier), remplacer test/key par le nom du fichier (on peut le retrouvé en tant que clé dans le détail sur le fichier déposé)
* * Cliquer sur Save
* Sur l'écran de Lambda, cliquer sur Test
* Un message vous informant du succès de l'opération doit être affiché (en cas d'erreur regarder les logs proposés pour corriger)

## Monitorer son code
* Sur l'écran de Lambda dans la console, lorsque vous êtes sur votre fonction CreationMiniatureVanessa 
* Cliquer sur l'onglet Monitoring 
* AWS vous propose des graphiques avec les données suivantes :
* * Invocations : Le nombre de fois où votre fonction a été executée
* * Duration : La durée d'éxecution de la fonction (en millisecondes)
* * Errros : Le nombre de fois où la fonction à échoué
* * Throttles : le nombre de fois où la fonction peut s'executer en parallèle
* * Iterator Age : Mesure l'age du dernier enregistrement executé pour les triggers de streaming (Amazon Kinesis ou Amazon DynamoDB Streams)
* Vous avez également accès aux logs en cliquant sur Views logs CLoudwatch

-> Félicitation vous savez maintenant déployer du code sans serveur sur AWS et l'éxecuter sur des évènements. 

