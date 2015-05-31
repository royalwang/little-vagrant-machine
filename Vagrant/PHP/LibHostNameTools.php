<?php

/**
 * Lib: Some tools
 *
 * @copyright   (C) 2015 Rain Lee <raincious@gmail.com>
 * @see         LICENSE for license
 */

static $HOSTNAME_ALLOWED_CHARACTERS = array(
    'a', 'b', 'c', 'd', 'e', 'f', 'g',
    'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u',
    'v', 'w', 'x', 'y', 'z', '0', '1',
    '2', '3', '4', '5', '6', '7', '8',
    '9',
);

static $HOSTNAME_ALLOWED_MIDDLE_CHARACTERS = array(
    '-',
);

function getValidHostName($name)
{
    $finalName = '';
    $nameLen = strlen($name);
    global $HOSTNAME_ALLOWED_CHARACTERS, $HOSTNAME_ALLOWED_MIDDLE_CHARACTERS;

    for ($i = 0; $i < $nameLen; ++$i) {
        if (in_array($name[$i], $HOSTNAME_ALLOWED_CHARACTERS)) {
            $finalName .= $name[$i];

            continue;
        }

        if ($i > 0 && $i < $nameLen && in_array($name[$i], $HOSTNAME_ALLOWED_MIDDLE_CHARACTERS)) {
            $finalName .= $name[$i];

            continue;
        }

        $finalName = '';
        break;
    }

    if (!empty($finalName)) {
        return strtolower(trim($finalName));
    }

    return strtolower(substr(md5($name), 8, 16));
}