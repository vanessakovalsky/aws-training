# Utilisation d'un stockage objet de type S3

Cet exercice a pour objectifs :
* De créer un bucket S3
* D'ajouter un objet dans le bucket
* De gérer les droits d'accès sur un objet ou un bucket
* De définir une police de bucket
* D'utiliser le versionning de bucket

Durée : entre 45 et 60 minutes

## Création du bucket
* Dans la console web, choisir Services > S3
* Choisir Create bucket et configurer :
* * Bucket Name : BucketDeMonPrenom
* * Laisser la région par défaut
* * Cliquer sur Create bucket 

## Déposer un fichier dans le bucket 
* Dans la console, cliquer sur votre bucket
* Cliquer sur Upload
* Cliquer sur Add file
* Choisir un fichier sur votre ordinateur à Déposer
* Cliquer sur Upload
* Votre fichier devrait maintenant se trouver dans le bucket

## Rendre l'objet public
Par défaut les objets de votre buckets ne sont pas public
et donc pas accessible sur internet
* Cliquer sur votre fichier
* Copier l'adresse : Object URL 
* Coller l'adresse dans un autre onglet de votre navigateur et charger la page
* Vous obtenez alors un messag d'accès refusé
* Revenir sur l'onglet de la console
* Sur la page affichant les informations de votre fichier, cliquer 
sur l'onglet Permissions
* Dans la section Public access, choisir Everyone
* Choisir Read object pour donner les droits en lecture
* Cliquer sur Save
Un message d'erreur apparait vous indiquant que tous les accès publics
sont bloqués
* Revenir sur le bucket en cliquant sur son nom
* Cliquer sur l'onglet Permissions
* Cliquer sur Edit pour accéder aux modifications
* Déselectionner l'option Block all public access
* Cliquer sur Save 
* Une boite de dialogue s'ouvre pour vous demander de confirmer votre choix
* Allez vérifier dans les permissions du fichier si le message d'erreur a disparu
* Revenir sur l'onglet du fichier et recharger la page

## Créer une police de bucket
Une police de bucket permet de définir des permissions associées
à un bucket S3. Cela permet de définir des permissions pour les fichiers ou 
des dossiers spécifiques.
* Dans votre bucket, charger un nouveau fichier de texte.
* Vérifier avec l'url de celui-ci qu'il n'est pas accessible
* Dans le bucket, cliquer sur l'onglet Permissions
* Cliquer sur Bucket Policy
* Vous pouvez alors :
* * Soit renseignez la police de bucket à la main au format JSON
* * Soit utiliser Policy generator
* Dans les deux cas, vous avez besoin de l'identifiant ARN qui se trouve en haut de la page,
copier le.
* Par simplicité, nous choisissons l'éditeur de police, en cliquant dessus
* On peut maintenant configurer comme suit :
* * Select Type of Policy : S3 Bucket Policy
* * Effect : Allow
* * Principal : * (permet de donner l'accès à tout le monde)
* * AWS Services : Amazon S3
* * Actions : GetObjects
* * Amazon Resource NAME (ARN): coller la valeur de l'ARN correspondant à votre bucket
* * -> ajouter à la fin de l'ARN /* 
* Cliquer sur Add statement
* Cliquer sur Generate policy
* Copier la police générée qui apparait en JSON
* Revenir sur l'onglet de gestion de botre bucket
* Coller la police générée 
* Cliquer sur Save 
* Si vous revenez sur l'onglet qui contient le deuxième fichier 
que vous avez charger, en rafraichissant la page, vous devriez avoir accès à ce fichier

## Découvrir le versionning des fichiers
Le versionning permet de conserver différentes versions d'un fichier au
sein d'un bucket. Cela permet de facilement revenir à une version antérieur
ou de voir l'évolution d'un fichier.
* Sur votre bucket, cliquer sur l'onglet Properties
* Puis cliquer sur Versionning
* Cliquer sur Enable versionning puis sur Save
* Modifier le deuxième fichier envoyé, puis renvoyer le sur le bucket
* Raffraichissez l'onglet contenant le lien vers ce fichier
* Vous obtenez alors une erreur, car par défaut Amazon n'autorise 
l'accès que à la dernière version du fichier, une nouvelle URL a donc 
été créé pour la nouvelle version.
* Pour obtenir l'accès aux anciennes versions, il faut rajouter l'Action
dans la police de bucket : GetObjectVersion, voici la ligne à inséré dans les actions du json 
```
        "s3:GetObjectVersion"
```
* Après avoir enregistré la police de bucket, 
vous pouvez accéder aux différentes versions via les différentes URLs
* Revenir sur le bucket et à l'aide du menu action, supprimer le fichier texte.
* Une fenêtre apparait vous demandant de confirmer la suppression.
* Si vous regarder les différentes versions, la version supprimée
apparaît toujours avec un marker Delete
* En répétant l'opération sur la même version, le marker delete disparait.
* L'objet est donc restauré.

-> Félicitations vous savez manipuler les bases du stockage S3.
Pour allez plus loin, vous pouvez déposer un site web ou appli statique
(angular, react, vue.js) sur un stockage S3.