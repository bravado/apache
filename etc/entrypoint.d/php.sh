#!/usr/bin/env bash

sed -ie "s/\(max_execution_time\ =\ \).*/\1$PHP_MAX_EXECUTION_TIME/" /etc/php5/apache2/php.ini
sed -ie "s/\(register_globals\ =\ \).*/\1$PHP_REGISTER_GLOBALS/" /etc/php5/apache2/php.ini
sed -ie "s/\(memory_limit\ =\ \).*/\1$PHP_MEMORY_LIMIT/" /etc/php5/apache2/php.ini
sed -ie "s/\(post_max_size\ =\ \).*/\1$PHP_POST_MAX_SIZE/" /etc/php5/apache2/php.ini
sed -ie "s/\(upload_max_filesize\ =\ \).*/\1$PHP_UPLOAD_MAX_FILESIZE/" /etc/php5/apache2/php.ini
sed -ie "s/\(session.save_handler\ =\ \).*/\1$PHP_SESSION_SAVE_HANDLER/" /etc/php5/apache2/php.ini
sed -ie "s#;\?\(session.save_path\ =\ \).*#\1$PHP_SESSION_SAVE_PATH#" /etc/php5/apache2/php.ini
sed -ie "s/\(short_open_tag\ =\ \).*/\1$PHP_SHORT_OPEN_TAG/" /etc/php5/apache2/php.ini

[ -d $PHP_SESSION_SAVE_PATH ] || mkdir -p $PHP_SESSION_SAVE_PATH && chown $APACHE_RUN_USER:$APACHE_RUN_GROUP $PHP_SESSION_SAVE_PATH

# Configure apc
cat << EOF > /etc/php5/conf.d/apc.ini
extension=apc.so
apc.enabled=$APC_ENABLED
apc.shm_size=$APC_SHM_SIZE
apc.num_files_hint=$APC_NUM_FILES_HINT
apc.ttl=$APC_TTL
apc.user_ttl=$APC_USER_TTL
apc.gc_ttl=$APC_GC_TTL
EOF
