#!/bin/sh
# Dev only. prisma migrate dev creates and drops a shadow database,
# so the app user needs DDL rights beyond MYSQL_DATABASE (error P3014 otherwise).
# Production will use a separate migration user and a restricted app user.
set -eu

mysql -uroot -p"$MYSQL_ROOT_PASSWORD" <<SQL
GRANT CREATE, ALTER, DROP, REFERENCES, INDEX, SELECT, INSERT, UPDATE, DELETE
  ON *.* TO '$MYSQL_USER'@'%';
SQL
