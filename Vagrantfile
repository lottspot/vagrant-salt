# vim: syntax=ruby

Vagrant.configure(2) do |config|

  # Configuration flags
  flags = {}
  if File.exist?('flags/syncnfs')
    flags[:syncnfs] = true
  end

  # Load plugins
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
  end
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box
    if flags[:syncnfs]
      config.cache.synced_folder_opts = { type: 'nfs' }
    end
  end

  config.vm.provider :virtualbox

  config.vm.provider :libvirt do |libvirt|
    libvirt.driver            = 'kvm'
    libvirt.uri               = 'qemu:///system'
  end

  # Global settings
  config.vm.box = 'centos/7'
  if flags[:syncnfs]
    config.vm.synced_folder '.', '/vagrant', nfs: true, linux__nfs_options: ['ro', 'all_squash',]
  end

  # Salt master
  config.vm.define :master do |master|
    master.vm.network :private_network, ip: '192.168.128.10'
    master.vm.hostname = 'master'
    master.vm.provision :shell, path: 'provisioners/master.sh'
    master.vm.provision :salt do |salt|
      salt.install_master = true
      salt.no_minion = true
      salt.install_type = 'stable'
    end
  end

  # App server
  config.vm.define :app do |app|
    app.vm.box = 'ubuntu/trusty64'
    app.vm.network :private_network, type: 'dhcp'
    app.vm.hostname = 'app'
    app.vm.provision :shell, path: 'provisioners/minion.sh'
    app.vm.provision :salt do |salt|
      salt.colorize = true
      salt.run_highstate = true
      salt.install_type = 'stable'
    end
  end

end
