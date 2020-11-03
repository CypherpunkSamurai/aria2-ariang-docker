#! /bin/bash -eu

echo "**** update uid and gid to ${PUID}:${PGID} ****"
groupmod -o -g "$PGID" junv
usermod -o -u "$PUID" junv

echo Setting up rclone config

if [[ -n $RCLONE_CONFIG && -n $RCLONE_DEST_FOLDER ]]; then
	echo "Rclone config detected"
	echo -e "$RCLONE_CONFIG" > /app/conf/rclone.conf
	echo "on-download-complete=/app/on-complete.sh" >> /app/conf/aria2c.conf
	echo "on-download-stop=/app/on-stop.sh" >> /app/conf/aria2c.conf
	chmod +x /app/on-complete.sh
	chmod +x /app/on-stop.sh
fi


chown -R junv:junv \
         /app \
         /usr/local \
         /var/log \
         /data

chmod +x /app/caddy.sh \
         /app/rclone.sh \
         /app/aria2c.sh

echo "**** give caddy permissions to use low ports ****"
setcap cap_net_bind_service=+ep /usr/local/bin/caddy

"${@-sh}"
