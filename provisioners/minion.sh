set -e

if ! [ "$(readlink -f /etc/salt/minion)" = '/vagrant/saltstack/etc/minion' ]; then
  test ! -e /etc/salt/minion || rm -rf /etc/salt/minion
  test -e /etc/salt || mkdir -p /etc/salt
  ln -s /vagrant/saltstack/etc/minion /etc/salt/minion
  printf 'Setup link at /etc/salt/minion\n'
else
  printf 'Link is proper at /etc/salt/minion\n'
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
masterkey=$(cat /vagrant/salt-keys/master/master.pub)
if ! [ "$(printf '%s' "$masterkey" | md5sum | cut -d' ' -f1)" = "$(md5sum /etc/salt/pki/minion/minion_master.pub | cut -d' ' -f1)" ]; then
  test ! -e /etc/salt/pki/minion/minion_master.pub || rm -rf /etc/salt/pki/minion/minion_master.pub
  test -e /etc/salt/pki/minion || mkdir -p /etc/salt/pki/minion
  printf '%s' "$masterkey" > /etc/salt/pki/minion/minion_master.pub
  printf 'Seeded master public key\n'
else
  printf 'Already seeded master public key\n'
fi
