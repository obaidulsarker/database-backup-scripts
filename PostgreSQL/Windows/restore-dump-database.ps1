# Where pg_dump binary is located
$PGDUMP = "C:\Program Files\PostgreSQL\14\bin\pg_dump.exe"

# Host Name or IP address of the database server
$HOST = "localhost"

# Port of the database server
$PORT = 5432

# Database name which want to take backup
$DB_NAME = "sample_db"

# Database user which will use to take the backup
$BACKUP_USER = "postgres"

# Database user password
$BACKUP_PASS = 'xxxxxxxxx'

# Where you want to store backup files
$BACKUP_BASE_LOCATION = "C:\backup\$DB_NAME"

# You don't need to change below variables
$BACKUP_LOCATION = Join-Path $BACKUP_BASE_LOCATION "dump"
$LOG_LOCATION = $BACKUP_LOCATION
$LOGFILE = Join-Path $LOG_LOCATION "dump-backup-db-log.log"
$BACKUP_FILENAME = Join-Path $BACKUP_LOCATION "$DB_NAME-$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').dump"

# Create directory if not exists
New-Item -ItemType Directory -Force -Path $BACKUP_LOCATION

# Perform Backup
Add-Content -Path $LOGFILE -Value "$((Get-Date) -f 'yyyy-MM-dd HH:mm:ss'): DB[$DB_NAME] backup STARTED"

$env:PGPASSWORD = $BACKUP_PASS
& $PGDUMP --username $BACKUP_USER --host $HOST --port $PORT -Fc --lock-wait-timeout=600 --no-sync -f $BACKUP_FILENAME $DB_NAME 2>> $LOGFILE

Add-Content -Path $LOGFILE -Value "$((Get-Date) -f 'yyyy-MM-dd HH:mm:ss'): DB[$DB_NAME] backup FINISHED"