set -e

if ! [ "$(md5sum /etc/salt/pki/minion/minion.pub | cut -d' ' -f1)" = "$(md5sum /vagrant/salt-keys/app/minion.pub | cut -d' ' -f1)" ]; then
  test ! -e /etc/salt/pki/minion/minion.pub || rm -rf /etc/salt/pki/minion/minion.pub
  test -e /etc/salt/pki/minion || mkdir -p /etc/salt/pki/minion
  cp /vagrant/salt-keys/app/minion.pub /etc/salt/pki/minion/minion.pub
  printf 'Seeded minion public key\n'
else
  printf 'Already seeded minion public key\n'
fi

if ! [ "$(md5sum /etc/salt/pki/minion/minion.pem | cut -d' ' -f1)" = "$(md5sum /vagrant/salt-keys/app/minion.pem | cut -d' ' -f1)" ]; then
  test ! -e /etc/salt/pki/minion/minion.pem || rm -rf /etc/salt/pki/minion/minion.pem
  test -e /etc/salt/pki/minion || mkdir -p /etc/salt/pki/minion
  cp /vagrant/salt-keys/app/minion.pem /etc/salt/pki/minion/minion.pem
  printf 'Seeded minion private key\n'
else
  printf 'Already seeded minion private key\n'
fi

