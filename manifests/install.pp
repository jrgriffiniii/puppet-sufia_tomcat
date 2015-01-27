
# == Class: sufia_tomcat::install
#
# Class for managing the installation process of Fedora Generic Search
#
class sufia_tomcat::install inherits sufia_tomcat {

  require '::java', 'epel', '::fedora_commons', 'rvm'

  # Install Ruby
  rvm_system_ruby { 'ruby-2.0.0-p0':
      
    ensure      => 'present',
    default_use => true
  }

  # Install the necessary Gems

  # Install bundler

  # Install rails
  rvm_gem { 'rails':
    
    name         => 'rails',
    ruby_version => 'ruby-2.0.0-p0',
    ensure       => '4.1.8',
    require      => Rvm_system_ruby['ruby-2.0.0-p0']
  }

  # Create the Rails application
  exec { 'rails_create_app':

    command => '/usr/bin/env rails new /var/www/sufia',
    require => Rvm_gem['rails']
  }

  # Load the Gemfile
  file { '/var/www/sufia/Gemfile':

    source => 'puppet:///modules/sufia_tomcat/Gemfile',
    require => Exec['rails_create_app']
  }

  # Install the Gems
  exec { 'rails_bundle_install':

    command => '/usr/bin/env bundle install',
    cwd => '/var/www/sufia',
    require => File['/var/www/sufia/Gemfile']
  }

  # Generate the Sufia instance
  exec { 'rails_generate_sufia':

    command => '/usr/bin/env rails generate sufia:install -f',
        cwd => '/var/www/sufia',
    require => Exec['rails_bundle_install']
  }

  # Run the database migrations
  exec { 'rails_rake_db_migrate':

    command => '/usr/bin/env rake db:migrate',
    cwd => '/var/www/sufia',
    require => Exec['rails_generate_sufia']
  }

  # Configure the application for Solr and Fedora Commons
   

}
