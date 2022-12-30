@echo off

set SCRIPT_DIR=./
set DB_NAME=keen_auth_permissions_demo
set PGPASSWORD=Password3000!!
SET PGCLIENTENCODING=utf-8
chcp 65001

psql -U postgres -c "\i %SCRIPT_DIR%/01_create_database.sql;"
psql -U postgres -d %DB_NAME% -c "\i %SCRIPT_DIR%/02_create_basic_structure.sql;
psql -U postgres -d %DB_NAME% -c "\i %SCRIPT_DIR%/03_version_management.sql;
psql -U postgres -d %DB_NAME% -c "\i %SCRIPT_DIR%/04_helpers.sql;
psql -U postgres -d %DB_NAME% -c "\i %SCRIPT_DIR%/05_create_permissions.sql;
psql -U postgres -d %DB_NAME% -c "\i %SCRIPT_DIR%/06_fix_permissions.sql;
psql -U postgres -d %DB_NAME% -c "\i %SCRIPT_DIR%/07_demo_specific.sql;

pause