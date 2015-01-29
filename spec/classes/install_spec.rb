require 'spec_helper'

describe 'sufia_tomcat::install' do

  context 'on CentOS 6.4' do

    let :facts do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'CentOS',
        :operatingsystemrelease => '6.4',
        :concat_basedir => '/var/lib/puppet'
      }
    end

    # @todo Resolve
    # it { should compile }
    # it { should compile.with_all_deps }

    it { should contain_class('java') }
    it { should contain_class('epel') }
    it { should contain_class('fedora_commons') }
    it { should contain_class('rvm') }

    it { should contain_package('tomcat') }
    it do

      should contain_service('tomcat')
        .with_ensure('running')
    end

    it do

      should contain_rvm_gem('rails')
        .with_name('rails')
        .with_ruby_version('ruby-2.1.5')
        .with_ensure('4.1.8')
        .that_requires("Rvm_system_ruby[ruby-2.1.5]")
    end

  end
end
