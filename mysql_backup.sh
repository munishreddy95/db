# Backup storage directory 
backupfolder=/root/auto_db_backup/db/databackup

# Notification email address 
recipient_email=kikikichannel91@gmail.com

# MySQL user
user=vinoth

# MySQL password
password=Vinoth#123

# Number of days to store the backup 
keep_day=30 

database=vinoth

sqlfile=$backupfolder/$database-$(date +%d-%m-%Y_%H-%M-%S).sql
zipfile=$backupfolder/$database-$(date +%d-%m-%Y_%H-%M-%S).zip 

#create dtabackup  folder

#sudo mkdir $backupfolder

if [ -d "$backupfolder" ]; then
  ### Take action if $DIR exists ###
  echo "Installing config files in ${backupfolder}..."
else
  ###  Control will jump here if $DIR does NOT exists ###
  echo "Error: ${backupfolder} not found. Can not continue."
  sudo mkdir $backupfolder
fi

# Create a backup 
sudo mysqldump -u $user -p$password $database > $sqlfile 

if [ $? == 0 ]; then
  echo 'Sql dump created' 
else
  echo 'mysqldump return non-zero code' | mailx -s 'No backup was created!' $recipient_email  
  exit 
fi 

# Compress backup 
zip $zipfile $sqlfile 
if [ $? == 0 ]; then
  echo 'The backup was successfully compressed' 
else
  echo 'Error compressing backup' | mailx -s 'Backup was not created!' $recipient_email 
  exit 
fi 
rm $sqlfile 
echo $zipfile | mailx -s 'Backup was successfully created' $recipient_email 

#git commands
git add .

git commit -m "changes-"-$(date +%d-%m-%Y_%H-%M-%S)

git push

# Delete old backups 
find $backupfolder $sqlfile -delete
