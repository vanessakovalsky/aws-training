# TP - 0 - Sauvegarde de fichier dans un bucket S3

L'objectif de ce TP est de produire un script qui transfert des fichiers de sauvegardes vers un bucket S3


## Script de départ :

* Voici le script de départ qui fait les sauvegarde : 
```sh

#!/bin/bash

# date du jour
backupdate=$(date +%Y-%m-%d)

#répertoire de backup
dirbackup=/backup/backup-$backupdate

# création du répertoire de backup
/bin/mkdir $dirbackup

# tar -cjf /destination/fichier.tar.bz2 /source1 /source2 /sourceN
# créé une archive bz2
# sauvegarde de /home
/bin/tar -cjf $dirbackup/home-$backupdate.tar.bz2 /home

# sauvegarde mysql
/usr/bin/mysqldump --user=xxxx --password=xxxx --all-databases | /usr/bin/gzip > $dirbackup/mysqldump-$backupdate.sql.gz

```

## Ajout du transfert vers S3
* A partir du script fournit, ajouter une connexion vers un bucket S3 (à créer avec AWS CLI)
* Puis transferer les deux fichiers de sauvegarde vers le bucket via AWS-CLI
* Supprimer dans le bucket via AWS CLI les fichiers qui ont plus de 7 jours 

-> Envoyer votre script ou un lien vers votre script sur le Teams

## Pour aller plus loin : 
* Ajouter dans le script lors de la création du bucket, une règle qui déplace automatiquement les vieilles sauvegarde vers un autre bucket en mode infrequent access  
