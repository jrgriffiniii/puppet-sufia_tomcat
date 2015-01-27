# == Class: sufia_tomcat
#
# This is the class for Sufia (deployed using Apache Tomcat)
#
#
# == Parameters
#
# Standard class parameters - Define solr web app specific settings
#
#
#
#
# == Examples
#
# See README
#
#
# == Author
#   James R. Griffin III <griffinj@lafayette.edu/>
#
class sufia_tomcat (

  $download_url = params_lookup( 'download_url' ),
  $version = params_lookup( 'version' ),

  $fedora_user_name = params_lookup( 'fedora_user_name' ),
  $fedora_user_pass = params_lookup( 'fedora_user_pass' ),
  $fedora_admin_user_name = params_lookup( 'fedora_admin_user_name' ),
  $fedora_admin_user_pass = params_lookup( 'fedora_admin_user_pass' ),
  $fedora_repo_name = params_lookup( 'fedora_repo_name' ),
  $fedora_version = params_lookup( 'fedora_version' ),
  $fedora_home = params_lookup( 'fedora_home' ),

  $servlet_engine = params_lookup( 'servlet_engine' ),
  $servlet_webapps_dir_path = params_lookup( 'servlet_webapps_dir_path' ),
  $servlet_context_dir_path = params_lookup( 'servlet_context_dir_path' ),
  $servlet_host = params_lookup( 'servlet_host' ),
  $servlet_port = params_lookup( 'servlet_port' ),

  $solr_version = params_lookup( 'solr_version' ),
  $install_dir_path = params_lookup( 'install_dir_path' ),
  $solr_index_name = params_lookup( 'solr_index_name' )
  
  ) inherits sufia_tomcat::params {

    # @todo Implement support for Jetty

    # Install the service
    require sufia_tomcat::install
  }
