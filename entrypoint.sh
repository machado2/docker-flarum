# if the directory /var/www/flarum is empty, then copy the flarum files into it

if [ -z "$(ls -A /var/www/flarum)" ]; then
    cp -a /app/flarum/. /var/www/flarum
    chown -R www-data:www-data /var/www/flarum
    chmod 775 -R /var/www/flarum
fi

# start apache2
apache2-foreground
