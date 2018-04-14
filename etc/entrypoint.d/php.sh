#!/usr/bin/env bash
# Check if php is configured
if [ ! -f /etc/php/7.2/fpm/pool.d/www.conf ]; then

  sed -ie "s/\(max_execution_time\ =\ \).*/\1$PHP_MAX_EXECUTION_TIME/" /etc/php/7.2/fpm/php.ini

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
      /etc/php/pool.tpl > /etc/php/7.2/fpm/pool.d/www.conf

# Configure opcache
cat << EOF > /etc/php/7.2/fpm/conf.d/10-opcache.ini
zend_extension=opcache.so

opcache.enable=$OPCACHE_ENABLE
opcache.fast_shutdown=$OPCACHE_FAST_SHUTDOWN
opcache.memory_comsuption=$OPCACHE_MEMORY_COMSUPTION
opcache.revalidate_path=$OPCACHE_REVALIDATE_PATH
opcache.max_accelerated_files=$OPCACHE_MAX_ACCELERATED_FILES
opcache.interned_strings_buffer=$OPCACHE_INTERNED_STRINGS_BUFFER
opcache.validate_timestamps=$OPCACHE_VALIDATE_TIMESTAMPS
opcache.revalidate_freq=$OPCACHE_REVALIDATE_FREQ
opcache.save_comments=$OPCACHE_SAVE_COMMENTS
EOF

# Configure apcu
cat << EOF > /etc/php/7.2/fpm/conf.d/20-apcu.ini
extension=apcu.so
apc.shm_size=$APC_SHM_SIZE
EOF

fi
