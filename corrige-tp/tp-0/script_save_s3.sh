#!/bin/bash

# date du jour
backupdate=$(date +%Y-%m-%d)

#répertoire de backup
dirbackup=/tmp/backup-$backupdate

# création du répertoire de backup
if [[-f  $dirbackup ]]
    then
        mkdir $dirbackup
fi

# tar -cjf /destination/fichier.tar.gz /source1 /source2 /sourceN
# créé une archive gz
# sauvegarde de /var/Www/html/zf
tar -czvf $dirbackup/www-$backupdate.tar.gz /var/www/html/zf

# sauvegarde mysql
mysqldump --user=admin_dump --password=Dump2021* --all-databases | /usr/bin/gzip > $dirbackup/mysqldump-$backupdate.sql.gz

# Connexion AWS depuis fichier CSV

aws configure import --csv file://credentials.csv

# Connexion AWS depuis variable d'environnement 
# Définir les variables d'environnement 
# AWS_ACCESS_KEY_ID 
# AWS_SECRET_ACCESS_KEY 
# AWS_DEFAULT_REGION 
# De fait aws va récupérer les valeurs de ces variables et n'a pas besoin d'etre configurer

# Création du bucket
bucketname=my-first-backup-bucket-vanessa

if aws s3api head-bucket --bucket "$bucketname" 2>/dev/null
    then
    echo 'Le bucket existe déjà'
else
    aws s3 mb s3://$bucketname
fi

# Copie de l'archive du home

aws s3 cp $dirbackup/www-$backupdate.tar.gz s3://$bucketname/

# Copie de l'archive de DB 

aws s3 cp $dirbackup/mysqldump-$backupdate.sql.gz s3://$bucketname/

# Suppression des fichiers agés de plus de 7 jours

aws s3 ls $bucketname/ | while read -r line;
    do
      createDate=`echo $line|awk {'print $1" "$2'}`
      createDate=`date -d"$createDate" +%s`
      olderThan=`date --date "7 days ago" +%s`
      if [[ $createDate -lt $olderThan ]]
         then
          fileName=`echo $line|awk {'print $4'}`
          if [[ $fileName != "" ]]
            then
                aws s3 rm $bucketname/$fileName
          fi
       fi

       done; 

# Autre moyen : avec l'ajout d'une règle depuis un fichier JSON
# aws s3api put-bucket-lifecycle-configuration --bucket $bucketname --lifecycle-configuration file://lifecycle.json

## Copier avec l'accès peu fréquent

aws s3 cp $dirbackup/www-$backupdate.tar.gz s3://$bucketname/ --storage-class STANDARD_IA