<?php

/**
 * A little tool to display all sub folders
 *
 * @copyright   (C) 2015 Rain Lee <raincious@gmail.com>
 * @see         LICENSE for license
 */

if (empty($argv[1])) {
    exit(1);
}

if (!is_dir($argv[1])) {
    exit(1);
}

$folders = array();

$iterator = new RecursiveDirectoryIterator(
    $argv[1],
    FilesystemIterator::SKIP_DOTS
);

foreach ($iterator as $file) {
    if ($file->isDir()) {
        array_push($folders, $file->getFilename());
    }
}

if (empty($folders)) {
    exit(1);
}

echo implode("\n", $folders);