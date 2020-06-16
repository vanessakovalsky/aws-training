# Mise en place d'une authentification applicative avec AWS Cognito

Cet exercice a pour objectifs :
* D'héberger un site statique sur Amazon S3
* De créer un pool d'utilisateurs
* De permettre l'authentification sur le site à l'aide de Cognito

Durée : 30 à 45 minutes

## Héberger un site statique
* Télécharger le fichier [index.html]
* Dans la console web, choisir Service puis S3
* Cliquer sur Create Bucket puis Create
* * Bucket name: `cognitoyourname`.
* Cliquer sur votre bucket dans la liste des buckets
* Cliquer sur Upload, sélectionner le fichier index.html et cliquer sur Upload
* Cliquer sur l'onglet Permissions, puis dans Public access Settings
* Cliquer sur Edit
* Décocher les options
* Cliquer sur Save
* Entrer confirm pour le champ et cliquer sur **Confirm**
* Sélectionner votre index.html et cliquer sur l'onglet **Permissions**
* Sélectionner **everyone** et **Read Object** 
* Cliquer sur  **Save**.
* Revenir à la page du bucket
* Cliquer sur l'onglet  **Properties** puis sur  **static website hosting**.
* Sélectionner **Use this bucket to host a website**, puis rentrer les valeurs suivants :
* * input `index.html` 
* Cliquer sur  **Save**.

## Ajouter une App cliente
* Dans le menu Service de la console, choisir  **Cognito**.
* Dans le menu de gauche, cliquer sur **Manage User Pools** 
* Puis sur  **Create a user pool**  pour créer les informations des utilisateurs
* * Pool name : UserPool_votreprenom
* Cliquer sur **Step through settings**.
* Dans le menu de gauche, cliquer sur **App clients** 
* Puis cliquer sur **add an app client**.
* * App client name : `myclient_votreprenom`
* * **Décocher**  Generate client secret 
* Cliquer sur Create.
* Cliquer sur **Return to pool details** 
* Puis cliquer sur **Create pool**.

* Puis choisir : **domain name**.
* * Your domaine name : votreprenom
* * Cliquer sur Check availability pour vérifier que le domaine soit disponible
* Cliquer sur Save Changes
* Dans le menu de gauche aller dans App Client Settings 
* Dans Enabled Identity Providers cliquer sur **Select All**.
* Dans **Callback URL(s)** entrer : `S3 bucket's Object URL` (adresse de votre fichier sur le bucket S3 voir-ci dessous pour l'obtenir)
* Aller dans la page de S3, cliquer sur votre bucket, puis sur votre fichier index.html et copier 
 **Object URL**.
* Dans OAuth 2.0 cocher : 
* * Authorization code grand
* * phone
* * email
* * openid
* * profile
* Cliquer sur  **Save changes** 


## Tester votre site 
* Pour se connecter en utilisant AWS Cognito, 
dans l'écran App client Settings, trouvez votre App et cliquer sur Launch UI 
* Vous pouvez vous identifier ou vous créer un compte
* Créer vous un compte
* Vérifiez que vous avez bien reçu le mail
* Connecter vous à votre site pour voir votre page web
* Revenir dans la console sur le service Cognito, pour vérifier que le compte a bien été enregistré.

-> Félicitations vous savez vous authentifier à l'aide cognito et l'utiliser sur un site web.

