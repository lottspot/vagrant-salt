set -e

if ! [ "$(readlink -f /etc/salt/master)" = '/vagrant/saltstack/etc/master' ]; then
  test ! -e /etc/salt/master || rm -rf /etc/salt/master
  test -e /etc/salt || mkdir -p /etc/salt
  ln -s /vagrant/saltstack/etc/master /etc/salt/master
  printf 'Setup link at /etc/salt/master\n'
else
  printf 'Link is proper at /etc/salt/master\n'
fi

if ! [ "$(readlink -f /srv/saltstack)" = '/vagrant/saltstack/srv' ]; then
  test ! -e /srv/saltstack || rm -rf /srv/saltstack
  test -e /srv || mkdir -p /srv
  ln -s /vagrant/saltstack/srv /srv/saltstack
  printf 'Setup link at /srv/saltstack\n'
else
  printf 'Link is proper at /srv/saltstack'
fi

# Preseed master key
if ! [ "$(md5sum /etc/salt/pki/master/master.pub | cut -d' ' -f1)" = "$(md5sum /vagrant/salt-keys/master/master.pub | cut -d' ' -f1)" ]; then
  test ! -e /etc/salt/pki/master/master.pub || rm -rf /etc/salt/pki/master/master.pub
  test -e /etc/salt/pki/master || mkdir -p /etc/salt/pki/master
  cp /vagrant/salt-keys/master/master.pub /etc/salt/pki/master/master.pub
  printf 'Seeded master public key\n'
else
  printf 'Already seeded master public key\n'
fi

if ! [ "$(md5sum /etc/salt/pki/master/master.pem | cut -d' ' -f1)" = "$(md5sum /vagrant/salt-keys/master/master.pem | cut -d' ' -f1)" ]; then
  test ! -e /etc/salt/pki/master/master.pem || rm -rf /etc/salt/pki/master/master.pem
  test -e /etc/salt/pki/master || mkdir -p /etc/salt/pki/master
  cp /vagrant/salt-keys/master/master.pem /etc/salt/pki/master/master.pem
  printf 'Seeded master private key\n'
else
  printf 'Already seeded master private key\n'
fi

# Preseed minion keys
minionkey_app=$(cat /vagrant/salt-keys/app/minion.pub)
if ! [ "$(printf '%s\n' "$minionkey_app" | md5sum | cut -d' ' -f1)" = "$(md5sum /etc/salt/pki/master/minions/app | cut -d' ' -f1)" ]; then
  test ! -e /etc/salt/pki/master/minions/app || rm -rf /etc/salt/pki/master/minions/app
  test -e /etc/salt/pki/master/minions || mkdir -p /etc/salt/pki/master/minions
  printf '%s\n' "$minionkey_app" > /etc/salt/pki/master/minions/app
  printf 'Seeded key for minion: app\n'
else
  printf 'Already seeded key for minion: app\n'
fi
