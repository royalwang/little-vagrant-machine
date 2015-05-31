<?php

/**
 * Edit apache2.conf to modify apache settings
 *
 * @copyright   (C) 2015 Rain Lee <raincious@gmail.com>
 * @see         LICENSE for license
 */

define('CONFIG_FILE', '/etc/apache2/apache2.conf');
define('NEW_CONFIG', "<Directory /var/www/>
\tOptions Indexes FollowSymLinks MultiViews
\tDirectoryIndex index.php index.htm index.html
\tAllowOverride All
\tEnableSendfile Off
\tRequire all granted
</Directory>");

if (!is_writable(CONFIG_FILE)) {
    exit('Can\'t access to Apache configuration file.');
}

$config = file_get_contents(CONFIG_FILE);

if (preg_match('/<Directory \/var\/www\/>/Ui', $config) <= 0) {
    exit('Can\'t found "Directory" setting for /var/www/.');
}

exit(file_put_contents(
    CONFIG_FILE,
    preg_replace('/<Directory \/var\/www\/>(.*)<\/Directory>/Usi', NEW_CONFIG, $config)
) ? 0 : 1);
