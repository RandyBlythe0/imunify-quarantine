# imunify-quarantine
Bash Script for Imunify Free version

Goal for this script is moving infected file to a folder without loosing directory structure so we can restore them back if needed. This script simply copies infected file list to a Jail Folder by maintaining the file's absolute path inside Jail Folder. For example a file /home/malware.php is infected this script wll move file to /root/.quarantine/home/malware.php. This willlet us know esily from where file was moved to Jail Folder.

I will keep adding more features for better use of script.

How to use: 

Make the file executable by 
```
chmod +x quarantine.sh
```
Get help
```
$ ./quarantine.sh -h
quarantine.sh [option]
-q : move malwares detected from imunify to quarantine[/root/.quarantine/ is Default] folder
-d : delete quarantine files older than 14[default] days
-r : restore [Yet to implement]
```
