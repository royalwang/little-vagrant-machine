#!/bin/bash
#
# Certificate Creater Script
#
# @copyright   (C) 2015 Rain Lee <raincious@gmail.com>
# @see         LICENSE for license

TMP_DIR='/tmp'

if [ -z "$1" ]; then
    exit 1
fi

if [ ! -d "$2" ]; then
    exit 1
fi

if [ ! -d "$3" ]; then
    exit 1
fi

if [ -z "$4" ]; then
    exit 1
fi

openssl req -new -newkey rsa:2048 -nodes \
    -subj "/CN=${1}/O=3AX HTTPS Self-Signed Test Certificate/C=CN/ST=Home/L=Home" \
    -keyout "${2}/${1}.key" -out "${TMP_DIR}/${1}.csr"

openssl x509 -req -days 180 -in "${TMP_DIR}/${1}.csr" -CA "${3}/CA.crt" -CAkey "${3}/CA.key" -set_serial "${4}" -out "${2}/${1}.crt"

rm "${TMP_DIR}/${1}.csr"
echo -e "\n" >> "${2}/${1}.crt"
cat "${3}/CA.crt" >> "${2}/${1}.crt"
