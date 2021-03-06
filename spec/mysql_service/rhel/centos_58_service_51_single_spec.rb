require 'spec_helper'

describe 'mysql_service_test::single on centos-5.8' do
  cached(:centos_58_service_51_single) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '5.8',
      step_into: 'mysql_service'
      ) do |node|
        node.set['mysql']['version'] = '5.1'
      end.converge('mysql_service_test::single')
  end

  before do
    stub_command('/usr/bin/test -f /var/lib/mysql-default/mysql/user.frm').and_return(true)
  end

  # Resource in mysql_service_test::single
  context 'compiling the test recipe' do
    it 'creates mysql_service[default]' do
      expect(centos_58_service_51_single).to create_mysql_service('default')
    end
  end

  # mysql_service resource internal implementation
  context 'stepping into mysql_service[default] resource' do
    it 'installs package[default :create mysql51-mysql-server]' do
      expect(centos_58_service_51_single).to install_package('default :create mysql51-mysql-server')
        .with(package_name: 'mysql51-mysql-server', version: nil)
    end

    it 'stops service[default :create mysql51-mysqld]' do
      expect(centos_58_service_51_single).to disable_service('default :create mysql51-mysqld')
      expect(centos_58_service_51_single).to stop_service('default :create mysql51-mysqld')
    end

    it 'creates group[default :create mysql]' do
      expect(centos_58_service_51_single).to create_group('default :create mysql')
        .with(group_name: 'mysql')
    end

    it 'creates user[default :create mysql]' do
      expect(centos_58_service_51_single).to create_user('default :create mysql')
        .with(username: 'mysql')
    end

    it 'deletes file[default :create /opt/rh/mysql51/root/etc/mysql/my.cnf]' do
      expect(centos_58_service_51_single).to delete_file('default :create /opt/rh/mysql51/root/etc/mysql/my.cnf')
        .with(path: '/opt/rh/mysql51/root/etc/mysql/my.cnf')
    end

    it 'deletes file[default :create /opt/rh/mysql51/root/etc/my.cnf]' do
      expect(centos_58_service_51_single).to delete_file('default :create /opt/rh/mysql51/root/etc/my.cnf')
        .with(path: '/opt/rh/mysql51/root/etc/my.cnf')
    end

    it 'creates link[default :create /opt/rh/mysql51/root/usr/share/my-default.cnf]' do
      expect(centos_58_service_51_single).to create_link('default :create /opt/rh/mysql51/root/usr/share/my-default.cnf')
        .with(
        target_file: '/opt/rh/mysql51/root/usr/share/my-default.cnf',
        to: '/opt/rh/mysql51/root/etc/mysql-default/my.cnf'
        )
    end

    it 'creates directory[default :create /opt/rh/mysql51/root/etc/mysql-default]' do
      expect(centos_58_service_51_single).to create_directory('default :create /opt/rh/mysql51/root/etc/mysql-default')
        .with(
        path: '/opt/rh/mysql51/root/etc/mysql-default',
        owner: 'mysql',
        group: 'mysql',
        mode: '0750',
        recursive: true
        )
    end

    it 'creates directory[default :create /opt/rh/mysql51/root/etc/mysql-default/conf.d]' do
      expect(centos_58_service_51_single).to create_directory('default :create /opt/rh/mysql51/root/etc/mysql-default/conf.d')
        .with(
        path: '/opt/rh/mysql51/root/etc/mysql-default/conf.d',
        owner: 'mysql',
        group: 'mysql',
        mode: '0750',
        recursive: true
        )
    end

    it 'creates directory[default :create /opt/rh/mysql51/root/var/run/mysql-default]' do
      expect(centos_58_service_51_single).to create_directory('default :create /opt/rh/mysql51/root/var/run/mysql-default')
        .with(
        path: '/opt/rh/mysql51/root/var/run/mysql-default',
        owner: 'mysql',
        group: 'mysql',
        mode: '0755',
        recursive: true
        )
    end

    it 'creates directory[default :create /opt/rh/mysql51/root/var/log/mysql-default]' do
      expect(centos_58_service_51_single).to create_directory('default :create /opt/rh/mysql51/root/var/log/mysql-default')
        .with(
        path: '/opt/rh/mysql51/root/var/log/mysql-default',
        owner: 'mysql',
        group: 'mysql',
        mode: '0750',
        recursive: true
        )
    end

    it 'creates directory[default :create /var/lib/mysql-default]' do
      expect(centos_58_service_51_single).to create_directory('default :create /var/lib/mysql-default')
        .with(
        path: '/var/lib/mysql-default',
        owner: 'mysql',
        group: 'mysql',
        mode: '0750',
        recursive: true
        )
    end

    it 'creates template[default :create /opt/rh/mysql51/root/etc/mysql-default/my.cnf]' do
      expect(centos_58_service_51_single).to create_template('default :create /opt/rh/mysql51/root/etc/mysql-default/my.cnf')
        .with(
        path: '/opt/rh/mysql51/root/etc/mysql-default/my.cnf',
        owner: 'mysql',
        group: 'mysql',
        mode: '0600'
        )
    end

    it 'runs bash[default :create initialize mysql database]' do
      expect(centos_58_service_51_single).to_not run_bash('default :create initialize mysql database')
        .with(
        cwd: '/opt/rh/mysql51/root/var/lib/mysql-default'
        )
    end

    it 'runs bash[default :create initial records]' do
      expect(centos_58_service_51_single).to_not run_bash('default :create initial records')
    end

    it 'creates template[default :start /etc/init.d/mysql-default]' do
      expect(centos_58_service_51_single).to create_template('default :start /etc/init.d/mysql-default')
        .with(
        path: '/etc/init.d/mysql-default',
        source: 'sysvinit/mysqld.erb',
        owner: 'root',
        group: 'root',
        mode: '0755',
        cookbook: 'mysql'
        )
    end

    it 'starts service[default :start mysql-default]' do
      expect(centos_58_service_51_single).to start_service('default :start mysql-default')
        .with(
        service_name: 'mysql-default'
        )
    end
  end
end
