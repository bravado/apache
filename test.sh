#!/usr/bin/env bash
cid=$(docker run -d -v $(pwd)/tests:/var/www/html bravado/apache:php7)


ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $cid)

echo waiting for apache
sleep 5

out=$(curl $ip/phpinfo.php)

echo $out

docker logs $cid;

docker stop $cid && docker rm -v $cid
