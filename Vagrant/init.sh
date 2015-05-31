#!/bin/bash
#
# Setup Installation
#
# @copyright   (C) 2015 Rain Lee <raincious@gmail.com>
# @see         LICENSE for license

if [ ! -d "/vagrant" ]; then
    echo "/vagrant not mounted."

    exit 1
fi

if [ ! -f "/vagrant/domain" ]; then
    echo "Can't found '/vagrant/domain' file."

    exit 1
fi

export HOST_NAME="$(cat '/etc/hostname').$(cat '/vagrant/domain' | sed -e ':a;N;$!ba;s/\r\n/ /g' -e 's/^[[:blank:]]*//;s/[[:blank:]]*$//')"

if [ ! -f "/vagrant/type" ]; then
    echo "Can't found '/vagrant/type' file."

    exit 1
fi

if [ -f "/vagrant/before_init.sh" ]; then
    echo -e "Running /vagrant/before_init.sh ..."

    sudo chmod +x "/vagrant/before_init.sh"
    sudo -E "/vagrant/before_init.sh" > /dev/null

    if [ "$?" -gt 0 ]; then
        echo -e " failed\r\n"

        exit $?
    else
        echo -e " done!\r\n"
    fi
fi

export INSTALL_TYPE="$(cat '/vagrant/type' | sed -e ':a;N;$!ba;s/\r\n/ /g' -e 's/^[[:blank:]]*//;s/[[:blank:]]*$//')"

if [ -z "${INSTALL_TYPE}" ]; then
    echo "INSTALL_TYPE is not defined."

    exit 1
else
    echo -e "Init Vagrant machine to type ${INSTALL_TYPE} ...\r\nThis may take quite long time, please wait until it finished.\r\n"
fi

if [ ! -d "/vagrant/${INSTALL_TYPE}" ]; then
    echo "Invaild type: ${INSTALL_TYPE}."

    exit 1
fi

if [ ! -f "/vagrant/${INSTALL_TYPE}/setup.sh" ]; then
    echo "Can't found installer for type ${INSTALL_TYPE}."

    exit 1
fi

if [ -f "/tmp/vagrant-init.log" ]; then
    sudo rm "/tmp/vagrant-init.log" -f
fi

if [ -f "/tmp/vagrant-info.log" ]; then
    sudo rm "/tmp/vagrant-info.log" -f
fi

sudo chmod +x "/vagrant/${INSTALL_TYPE}/setup.sh" > /dev/null
sudo -E "/vagrant/${INSTALL_TYPE}/setup.sh" > /tmp/vagrant-init.log

echo -e "\r\n\r\n\r\n\r\n============================================\r\n\r\n\r\n\r\n"

if [ "$?" -gt 0 ]; then
    echo -e "There is some error happened during init, please check log output:\r\n\r\n"

    cat "/tmp/vagrant-init.log"
else
    if [ -f "/tmp/vagrant-info.log" ]; then
        cat "/tmp/vagrant-info.log"
        echo -e "\r\n\r\n"
    fi

    echo "${HOST_NAME} is now ready, type 'vagrant ssh' to connect."
fi

echo -e "\r\n\r\n\r\n\r\n============================================\r\n\r\n\r\n\r\n"

exit $MAIN_SCRIPT_RESULT