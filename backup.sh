#!/bin/bash
backupdir=$HOME/Atos/Backups;

day=`date +%u`;
mkdir -p $backupdir/$day;

echo "PostgreSQL Backup for $HOSTNAME";
echo "================================="
echo `date`;
for database in `/usr/local/bin/psql -U postgres -lt | awk '{print $1}' | grep -vE '\||^$|template|postgres'`;
    do
    printf "Exporting $database...";
    /usr/local/bin/pg_dump -U postgres | gzip -c > $backupdir/$day/$database.sql.gz;
    /bin/chmod 600 $backupdir/$day/$database.sql.gz;    
    printf "done\n";
done
cd $backupdir;
git add -A && git commit -m "new database backup for ${date}" && git push;
echo `date`;
echo;
exit 0;
