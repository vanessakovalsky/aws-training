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