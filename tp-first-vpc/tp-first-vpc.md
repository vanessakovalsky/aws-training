# Création d'un premier réseau VPC 

Cet exercice a pour objectifs :
* De créer un premier VPC
* De créer un sous réseau public et un privé
* D'utiliser le NAT Gateway
* De définir des tables de routes
* D'utiliser Elastic IP

Durée : 30 à 40 minutes

## Création du VPC
Voici un aperçu du VPC que l'on va créé :

![Mon premier VPC](https://s3.us-west-2.amazonaws.com/us-west-2-aws-training/awsu-spl/spl-84/2.0.7.prod/images/overview.png)

* En haut à droit, cliquer sur VPC Dashboard
* Cliquer sur Launch VPC Wizard pour accéder à l'assistant de création
* Choisir VPC with public and private subnets
* Cliquer sur Select
* Voici maintenant les paramètres à renseigner :
* * VPC name : VPC de [votre-nom]
* * Public subnet's IPv4 CIDR : 10.0.25.0/24  (la valeur est libre ici, ne pas mettre la même que dans l'exemple)
* * Public Availability Zone : Sélectionner la première zone dans la liste
* * Private Subnet's IPv4 CIRD : 10.0.50.0/24 (la valeur est libre ici, ne pas mettre la même que dans l'exemple)
* * Private Availability Zone : sélectionner la même que pour la zone publique
* * Elastic IP Allocation ID : Cliquer dans le champs, et sélectionner l'adresse IP créé à l'étape précédente
* Les autres paramètres peuvent rester par défaut
* Cliquer sur Create VPC
Le VPC est créé.
* Cliquer sur Ok pour fermer la fenêtre
Le VPC est maintenant visible dans le dashboard VPC.
* Vérifier que vous avez bien un ID assigné, nous l'utiliserons plus tard.

## Visualiser les composants de notre VPC
* En haut à gauche, cliquer sur Filter by VPC, puis cliquer sur Select a PVC et choisir celui que vous avez créé, cela permet de filtrer pour ne voir que ce qui concerne votre propre VPC
* Dans le menu à gauche, cliquer sur Internet Gateway 
* Vous voyer alors le Internet gateway de votre VPC qui permet à votre VPC d'être connecté à internet (plus tard dans un autre exercice nous rajouterons des instances dans ce VPC et aurons besoin d'accéder à ce VPC depuis internet)
* Dans le menu de gauche, cliquer maintenant sur Subnets
* Quels sont les sous-réseaux disponibles ?
* Cliquer sur le sous-réseau public
* Quelle est la plage d'adresse IP utilisable dans ce sous-réseau ?
* Cliquer sur l'onget Route Table
* Quelles sont les routes déjà déclarées ? Et vers quoi chacune redirige t'elle ?
* Cliquer sur l'onglet Network ACL
Le Network ACL agit comme un pare-feu (firewall) au niveau du VPC 
* A quoi correspondent les 2 règles existantes ?
* Sur le menu de Gauche, cliquer sur Nat Gateway
Un Gateway NAT permet au sous-réseau privé d'accéder aux ressources à l'extérieur du VPC (sur internet ou d'autres VPC s'ils autorisent la connexion)
* Cliquer sur le menu de Gauche dans Security Groups
* Quelles sont les règles appliquées sur le groupe de sécurité créé ?

-> Félicitations, vous savez maintenant créer un réseau virtuel pour votre cloud 

