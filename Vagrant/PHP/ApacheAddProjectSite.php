<?php

/**
 * Edit apache2.conf to modify Apache default website
 *
 * @copyright   (C) 2015 Rain Lee <raincious@gmail.com>
 * @see         LICENSE for license
 */

define('CONFIG_FILE_ROOT', '/etc/apache2/sites-available/');

require('LibApacheVirtualHostModifier.php');
require('LibHostNameTools.php');

if (empty($argv[1]) || empty($argv[2])) {
    exit(1);
}

$hostName = getValidHostName($argv[1]);

if (!createApacheVirtualHostConfig(CONFIG_FILE_ROOT . $argv[1] . '.conf', array(
    '%{PROJECT_DIR}' => 'project/' . $argv[1],
    '%{HOST_NAME}' => $hostName . '.project.' . $argv[2],
))) {
    exit(1);
}

echo $hostName . '.project.' . $argv[2];