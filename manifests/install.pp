
# == Class: sufia_tomcat::install
#
# Class for managing the installation process of Fedora Generic Search
#
class sufia_tomcat::install inherits sufia_tomcat {

  require '::java', 'epel', '::fedora_commons', 'rvm'

  # Install Ruby
  rvm_system_ruby { 'ruby-2.1.5':
      
    ensure      => 'present',
    default_use => true
  }

  # Install the necessary Gems

  # Install bundler

  # Install rails
  rvm_gem { 'rails':
    
    name         => 'rails',
    ruby_version => 'ruby-2.1.5',
    ensure       => '4.1.8',
    require      => Rvm_system_ruby['ruby-2.1.5']
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

  # Configure the application for Fedora Commons
  file { "/var/www/sufia/config/fedora.yml":

    content => template('sufia_tomcat/fedora.yml.erb'),
    require => Exec['rails_generate_sufia']
  }

  # Configure the application for Apache Solr
  file { "/var/www/sufia/config/solr.yml":

    content => template('sufia_tomcat/solr.yml.erb'),
    require => Exec['rails_generate_sufia']
  }

  # Install and configure the Apache HTTP Server

  # Loading the HTTP Server
  if $sufia_tomcat::http_service == '' or !defined( $sufia_tomcat::http_service ) {

    # Select the HTTP server
    case $sufia_tomcat::http_service_type {

      'nginx': {} # @todo Implement for nginx
      
      default: {

        if !defined( Class['::apache'] ) { # Ensure that the Class hasn't already been loaded
          
          # Configure Apache HTTP Server

          # Install and configure passenger
          class { 'passenger':

            notify => Class['::apache']
          }
          
          # Set the DocumentRoot directive for the default VirtualHost
#          class { '::apache':
    
#            docroot => '/var/www/sufia',
#            require => [ File[ "/var/www/sufia/config/fedora.yml", "/var/www/sufia/config/solr.yml" ] ],
#            mpm_module => 'prefork'
#          }

          apache::vhost { 'localhost.localdomain':

            docroot     => '/var/www/sufia',
            directories => {
              
              path        => '/var/www/sufia',
            },
          }
        }
      }
    }
  }

  # Configure the VirtualHost Directive for Sufia

  # Add an iptables rule to permit traffic over the HTTP and HTTPS
  # ensure_resource('firewall', '001 allow http and https access for Apache HTTP Server', {
  firewall { '001 allow http and https access for the HTTP Server':
    
    port   => [80, 443],
    proto  => 'tcp',
    action => 'accept'
  }
}
