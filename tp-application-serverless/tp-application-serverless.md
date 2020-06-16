# Création d'une application de jeux sans serveur avec les services AWS

Cet exercice va permettre de créer un jeu dans lequel chaque joueur l'un après l'autre va enlever des objets d'une pile, le but du jeu est de ne pas prendre le dernier objet de la pile.

Cet objectif a pour objectifs :
* D'utiliser Cloud9 comme environnement de développement
* D'utiliser DynamoDB pour stocker des données
* D'utiliser SNS pour envoyer des notifications
* D'utiliser Cognito pour l'authentification
* D'utiliser lambda pour éxecuter le code

Durée : entre 90 et 120 minutes

## Création de l'environnement
* Dans la console web d'AWS, dans service choisir Cloud9
* Cliquer sur **Créer un environnement**
* Dans le champ nom : Jeu videz la pile de Prénom
* Cliquer sur **Etape suivante**
* Laisser les paramètres par défaut et cliquer sur **Créer un environnement**
* Une fois l'environnement initialisé vous avez les 3 zones suivantes à disposition  
![https://d1.awsstatic.com/Getting%20Started/AWS-Labs-Turn-Based-Game/turn-based-game-cloud9.a8b55e4797f1a0dc1a7f55da0cfb94065fb2bbad.png](https://d1.awsstatic.com/Getting%20Started/AWS-Labs-Turn-Based-Game/turn-based-game-cloud9.a8b55e4797f1a0dc1a7f55da0cfb94065fb2bbad.png)
* * Explorateur de fichier : permet de naviguer dans les différents fichiers
* * Editeur de fichier : Permet d'afficher et de modifier un fichier
* * Terminal : Permet d'exécuter des commandes

## Installer le code du jeu
* Dans l'environnement Cloud 9, utiliser le terminal pour récupérer les fichiers
```
cd ~/environment
curl -sL http://d118jxrmrxsq90.cloudfront.net/turn-based.tar | tar -xv
```
* Pour afficher les fichiers vous pouvez utiliser la commande :
```
ls
```
* Deux répertoires sont alors visibles :
* * Application : contient le code de l'application
* * Scripts : Scripts permettant de créer des ressources AWS ou de transférer les données dans la base de données
* Installer les dépendances à l'aide de la commande :
```
npm install --prefix scripts/ && npm install --prefix application
```
* Ensuite nous devons définir la région à utilisé, par exemple pour us-east-1
/!\ Il est nécessaire de choisir une région parmi celle qui propose l'envoi de SMS voir ici : https://docs.aws.amazon.com/fr_fr/sns/latest/dg/sns-supported-regions-countries.html 
```
echo "export AWS_REGION=us-east-1" >> env.sh && source env.sh
```
* Le fichier env.sh permet de charger les variables d'environnement, si vous fermez l'onglet avec cloud 9, il faudra recharger les variables d'environnement avec la commande :
```
source env.sh
```
-> L'environnement de travail est prêt passons à la suite avec la mise en place de la base de données


## Création de la base de donnée DynamoDB
* Nous allons créer un bdd DynamoDB pour stocker les données de notre jeu
* Pour cela un script est disponible, vous pouvez le lancer dans le terminal de cloud9 avec la commande :
```
bash scripts/create-table.sh
```
* Aller dans le service DynamoDb, quelle est le nom de la table créé ? 
* Quelles sont les clés utilisées ?
Le schéma de chaque jeu est le suivant 
![https://d1.awsstatic.com/Getting%20Started/AWS-Labs-Turn-Based-Game/turn-based-game-schema.e4cd3826657521e17bd481d2063d8ecd5cf7fe48.png](https://d1.awsstatic.com/Getting%20Started/AWS-Labs-Turn-Based-Game/turn-based-game-schema.e4cd3826657521e17bd481d2063d8ecd5cf7fe48.png)

## Importer un jeu 
* Un script est disponible dans script pour créer un premier jeu, il s'appelle CreateGame.js
* Pour le lancer utiliser la commande :
```
node scripts/createGame.js
```
* Vous obtenez alors le résultat suivant :
```
Game added successfully!
```
* Créer un deuxième fichier appelé createGame2.js dans le dossier scripts
* Copier le contenu du fichier createGame.js et modifier le (modifier le nom des joueurs et le nombre d'objets dans chaque pile (heap))
* Lancer la creation du jeu depuis votre nouveau script
* Côté DynamoDb, vos données ont-elles bien été créées ?

## Modification de la partie
* Nous allons modifier une partie pour simuler le coup d'un des joueurs
* Pour cela un script est disponible dans scripts/performMove.js
* Quelles sont les étapes et les appels effectués par ce script ?
* Pour lancer le script utiliser la commande :
```
node scripts/performMove.js
```
* Qu'est ce que le script a modifié ?
* Que se passe t'il si vous executer une nouvelle fois ce même script ?

## Ajout de notification pas SMS avec Amazon SNS 
Nous allons maintenant notifier l'utilisateur des étapes importantes comme une nouvelle partie ou un nouveau tour.
* Pour cela nous créons via un script la ressource SNS puis nous utilisons cette ressources SNS pour envoyer un message
* Avant d'executer ce script, il est nécessaire de définir le numéro de téléphone sur lequel le sms sera envoyé, comme variable d'environnement. Pour cela on utilise la commande (remplacer les XXX par votre numéro de portable sans le 0): 
```
echo "export PHONE_NUMBER=+33XXXXXXXXX" >> env.sh && source env.sh
```
* Puis lancer le script
```
node scripts/sendMessage.js
```
* Vous obtenez alors ce résultat :
```
Sent message successfully
```
* En cas d'erreur, il est pr
* Et vous devriez recevoir un SMS 
* Aller dans Services Amazon SNS pour voir ce qui s'est passé ?

-> Les notifications sont maintenant configurées, la ressources SNS créé

## Configurer l'authentification avec Cognito
* Afin de configurer l'authentification, il est nécessaire de créer un pool d'utilisateur sur Cognito. 
* Pour créer rapidement le pool d'utilisateurs utiliser la commande :
```
bash scripts/create-user-pool.sh
```
* Vous obtenez alors le résultat :
```
User Pool created with id <user-pool-id>
```
* Puis il est nécessaire de créer une application cliente pour notre User pool, pour cela un script est aussi disponible. Lancer ce script avec la commande :
```
bash scripts/create-user-pool-client.sh
```
* Vous obtenez alors le résultat :
```
User Pool Client created with id <client-id>
```
* Ouvrir dans l'IDE de Cloud9 le fichier auth.js qui se trouve dans application
* Ce fichier contient 4 fonctions :
* * createCognitoUser : permet de créer des nouveaux utilisateurs dans le pool
* * login : permet d'authentifier un utilisateur avec son username et son mot de passe, la fonction retourne le token a utilisé pour l'appel des autres fonctions.
* * fetchUserByUsername : permet de récupérer un utilisateur à partir de son username, utilisé pour récupérer le numéro de téléphone d'un utilisateur
* * verifytoken : vérifie le token envoyée avec une requête pour savoir s'il est toujours valide ou non 

-> L'authentification est en place pour notre application.

## Déployer l'application dans une fonction lambda 
### Création de la fonction lambda
* Afin de déployer notre application dans une fonction lambda plusieurs étapes sont nécessaires :
* * Création d'une archive zip à partir du répertoire application qui contient le code JavaScript
* * Création d'un rôle IAM pour la fonction lambda
* * Ajout des polices qui permettent aux rôles d'effectuer les actions nécessaires à l'application comme l'accès à la table DynamoDB ou l'envoi de SMS via Amazon SNS
* * Création de la fonction lambda à partir de l'archive zip
* Pour effectuer l'ensemble de ces actions, comme pour le reste vous pouvez utiliser la console web ou la commande suivante :
```
bash scripts/create-lambda.sh
```
* Vous obtenez alors la sortie suivante
```
$ bash scripts/create-lambda.sh
Building zip file
Creating IAM role
Adding policy to IAM role
Sleeping for IAM role propagation
Creating Lambda function
Lambda function created with ARN <functionArn>
```

### Création de l'API Gateway
* Il est également nécessaire de créer une API Gateway qui va exposer les ressources depuis le serveur express.js de notre fonction lamba
* Pour cela deux étapes :
* * Création de l'API Gateway
* * Configuration d'une ressource et d'une méthode proxy qui va seulement transmettre les requêtes et les informations à express
* Là aussi utiliser la console web, ou la commande suivante :
```
bash scripts/create-rest-api.sh
```
* Le résultat obtenu est alors le suivant
```
Creating REST API
Fetching root resource
Creating proxy resource
Creating method
Adding integration
Creating deployment
Fetching account ID
Adding lambda permission
REST API created

Your API is available at: https://<id>.execute-api.<region>.amazonaws.com/prod
```
* La valeur de votre URL d'API a été ajoutée au fichier env.sh, penser à le recharger pour que la variable d'environement BASE_URL soit disponible :
```
source env.sh
```

## Tester le jeu
Pour tester le jeu, qui n'expose que des API, il est possible de le faire de plusieurs façons 
* soit via un terminal en utilisant l'outil CLI curl
* soit via un outil graphique comme [Postman](https://www.postman.com/)

Nous allons ici utiliser curl par simplicité, mais vous pouvez adapter à l'utilisation d'un autre outil
Pour rappel, les différents endpoints disponible sont dans le fichier app.js 

* Commencer par créer un utilisateur en effectuant une requête POST sur le endpoints /users
```
curl -X POST ${BASE_URL}/users \
  -H 'Content-Type: application/json' \
  -d '{
	"username": "myfirstuser",
	"password": "Password1",
	"phoneNumber": "'${PHONE_NUMBER}'",
	"email": "test@email.com"
}'
```
* Puis on répète l'opération pour créer un deuxième utilisateur 
```
curl -X POST ${BASE_URL}/users \
  -H 'Content-Type: application/json' \
  -d '{
	"username": "theseconduser",
	"password": "Password1",
	"phoneNumber": "'${PHONE_NUMBER}'",
	"email": "test@email.com"
}'
```
* Puis on se connecte avec le premier utilisateur et le endpoint /login :
```
curl -X POST ${BASE_URL}/login \
  -H 'Content-Type: application/json' \
  -d '{
	"username": "myfirstuser",
	"password": "Password1"
}'
```
* La connexion nous renvoit un token pour cet utilisateur :
```
{"idToken":"eyJraWQiO…."}
```
* Noter le token ou exporter le dans les variables d'environnement :
```
export FIRST_ID_TOKEN=<idToken>
```
* On répète l'opération pour le second utilisateur et là aussi on note ou on exporte le token du second utilisateur

Nous avons maintenant nos deux utilisateurs de connectés, la partie peut démarrer.

* Pour lancer une partie on utilise une requête POST sur le endpoint /games
```
curl -X POST ${BASE_URL}/games \
 -H 'Content-Type: application/json' \
  -H "Authorization: ${FIRST_ID_TOKEN}" \
  -d '{
	"opponent": "theseconduser"
}'
```
* Cela renvoit des informations sur la partie :
```
{"gameId":"433334d0","user1":"myfirstuser","user2":"theseconduser","heap1":5,"heap2":4,"heap3":5,"lastMoveBy":"myfirstuser"}
```
* Cela déclenche également l'envoi d'un SMS aux joueurs.
* On note ou on exporte l'ID de la partie :
```
export GAME_ID=<yourGameId>
```
* Essayer de réxecuter la commande de création de partie sans le token :
```
curl -X POST ${BASE_URL}/games \
 -H 'Content-Type: application/json' \
  -d '{
	"opponent": "theseconduser"
}'
```
* Vous obtenez alors une erreur en retour :
```
{"message":"jwt must be provided"}
```

* Pour reprendre une partie en cours, on utilise une requête GET sur le endpoint /games/gameid
```
curl -X GET ${BASE_URL}/games/${GAME_ID}
```
* Vous obtenez alors les informations sur la partie en cours :
```
{"heap2":4,"heap1":5,"heap3":5,"gameId":"32597bd8","user2":"theseconduser","user1":"myfirstuser","lastMoveBy":"myfirstuser"}
```

Il ne reste plus qu'à jouer des coups pour faire avancer la partie
* On utilise alors une requête POST sur games/gameid
```
curl -X POST ${BASE_URL}/games/${GAME_ID} \
  -H "Authorization: ${SECOND_ID_TOKEN}" \
  -H 'Content-Type: application/json' \
  -d '{
	"changedHeap": "heap1",
	"changedHeapValue": 0
}'
```
* Attention à utiliser le bon token, celui du joueur qui n'a pas joué en dernier
* Le retour affiche l'état de la partie
```
{"heap2":4,"heap1":0,"heap3":5,"gameId":"32597bd8","user2":"theseconduser","user1":"myfirstuser","lastMoveBy":"theseconduser"}
```
* Faites d'autres coups pour vider les piles en alternants les utilisateurs
* A la fin de la partie les deux utilisateurs reçoivent un SMS les informants du résultat de la partie.

-> Félicitations, vous avez maintenant une application back end complète et fonctionnelle

## Pour aller plus loin

* Si vous le souhaitez, vous pouvez ajouter une application front end faite en JS (avec un framework type React ou Angular par exemple), que vous déploierez dans un bucket S3 sous forme d'un site statique et qui utilisera cet API.

## Nettoyage de vos environnements
* POur supprimer l'ensemble des ressources crées vous pouvez utiliser la commande :
```
bash scripts/delete-resources.sh
```
* Puis dans la console de Cloud9, supprimer l'environnement de l'application également







