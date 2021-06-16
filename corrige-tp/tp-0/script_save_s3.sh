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

# Création du bucket
bucketname=my-first-backup-bucket

aws s3 mb s3://$bucketname

# Copie de l'archive du home

aws s3 cp $dirbackup/home-$backupdate.tar.bz2 s3://$bucketname/

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