<?php

/**
 * Copy PHP Module Settings from source folder
 *
 * @copyright   (C) 2015 Rain Lee <raincious@gmail.com>
 * @see         LICENSE for license
 */

define('SETTING_MARK', "\r\n; Modified by 3AX.ORG Vagrant VM Generater Script\r\n");

if (empty($argv[1]) || empty($argv[2])) {
    exit(1);
}

if (!is_dir($argv[1]) || !is_dir($argv[2])) {
    exit(1);
}

$folders = array();

$iterator = new RecursiveDirectoryIterator(
    $argv[1],
    FilesystemIterator::SKIP_DOTS
);

foreach ($iterator as $file) {
    if (!$file->isFile() || !$file->isReadable()) {
        continue;
    }

    if (!is_file($argv[2] . DIRECTORY_SEPARATOR . $file->getFilename())) {
        continue;
    }

    if (!is_readable($argv[2] . DIRECTORY_SEPARATOR . $file->getFilename())) {
        continue;
    }

    $configContent = file_get_contents($file->getPathname());
    $importContent = file_get_contents($argv[2] . DIRECTORY_SEPARATOR . $file->getFilename());

    if (($markPos = strpos($configContent, SETTING_MARK)) !== false) {
        $configContent = substr($configContent, 0, $markPos);
    }

    $configContent .= SETTING_MARK;
    $configContent .= $importContent;

    file_put_contents($file->getPathname(), $configContent);
}