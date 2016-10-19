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
