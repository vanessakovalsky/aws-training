# Détail des actions

# Pour le VPC création de l'ensemble des éléments réseau nécessaire : 

-> Nous vous invitons à définir des variables pour les éléments qui se répète : région, nom, plage d'IP
Puis à récuper l'id des éléments crée dans de nouvelles variables pour pouvoir les réutiliser facilement 

* Définition d'une zone (attention, chaque zone est limité à 5 VPC)
* Création d'un vpc
* Création d'un sous-réseau public
* Création d'un sous-réseau privé 
* Création d'une passerelle internet
* Rattachement de la passerelle internet au VPC 
* Création d'une table de route
* Création d'une route vers la passerelle internet
* Association du sous-réseau public à la table de route
* Activer l'auto-assignation des IP sur le sous-réseau public pour que l'on puisse accéder à l'instance par la suite

# Pour l'instance EC2 : 

* Création d'une paire clé SSH
* Définition des bons droits sur la clé SSH
* Création du groupe de sécurité 
* Ajout d'une règle pour le SSH (port 22)
* Ajout d'une règle pour le HTTP (port 80)
* Lancement de l'instance
* Récupération de l'IP de l'instance
* Connexion SSH 

-> Il ne vous reste plus qu'à déployer votre application 