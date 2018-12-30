#!/usr/bin/env bash
# Check if php is configured
if [ ! -f /etc/php5/fpm/pool.d/www.conf ]; then

  sed -ie "s/\(max_execution_time\ =\ \).*/\1$PHP_MAX_EXECUTION_TIME/" /etc/php5/fpm/php.ini
  sed -ie "s/;\(daemonize\ =\ \).*/daemonize=no/" /etc/php5/fpm/php-fpm.conf

  sed -e "s;\$PHP_LISTEN;$PHP_LISTEN;g" \
      -e "s;\$PHP_MEMORY_LIMIT;$PHP_MEMORY_LIMIT;g" \
      -e "s;\$PHP_MAX_SPARE_SERVERS;$PHP_MAX_SPARE_SERVERS;g" \
      -e "s;\$PHP_MIN_SPARE_SERVERS;$PHP_MIN_SPARE_SERVERS;g" \
      -e "s;\$PHP_START_SERVERS;$PHP_START_SERVERS;g" \
      -e "s;\$PHP_MAX_CHILDREN;$PHP_MAX_CHILDREN;g" \
      -e "s;\$PHP_SESSION_SAVE_HANDLER;$PHP_SESSION_SAVE_HANDLER;g" \
      -e "s;\$PHP_SESSION_SAVE_PATH;$PHP_SESSION_SAVE_PATH;g" \
      -e "s;\$PHP_POST_MAX_SIZE;$PHP_POST_MAX_SIZE;g" \
      -e "s;\$PHP_UPLOAD_MAX_FILESIZE;$PHP_UPLOAD_MAX_FILESIZE;g" \
      -e "s;\$PHP_CATCH_WORKERS_OUTPUT;$PHP_CATCH_WORKERS_OUTPUT;g" \
      -e "s;\$PHP_MAX_REQUESTS;$PHP_MAX_REQUESTS;g" \
      -e "s;\$PHP_MAX_INPUT_VARS;$PHP_MAX_INPUT_VARS;g" \
      -e "s;\$PHP_SHORT_OPEN_TAG;$PHP_SHORT_OPEN_TAG;g" \
      /etc/php5/fpm/www.tpl > /etc/php5/fpm/pool.d/www.conf

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

fi
