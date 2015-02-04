# == Class: sufia_tomcat
#
# Parameters for the sufia_tomcat Class
#
class sufia_tomcat::params {

  $version = '2.7'

  $app_name = 'sufia'

  $ruby_version = 'ruby-2.1.5'
  $rails_version = '4.1.8'

  $fedora_user_name = 'fgsAdmin'
  $fedora_user_pass = 'secret'
  $fedora_admin_user_name = 'fedoraAdmin'
  $fedora_admin_user_pass = 'secret'
  $fedora_repo_name = 'fgsAdmin'
  $fedora_version = '3.8.0'
  $fedora_home = '/usr/local/fedora'
  $fedora_users = "${fedora_home}/server/config/fedora-users.xml"

  $servlet_engine = 'tomcat'
  $servlet_webapps_dir_path = '/var/lib/tomcat/webapps'
  $servlet_context_dir_path = '/etc/tomcat/Catalina/localhost'
  $servlet_host = 'localhost'
  $servlet_port = '8080'

  $solr_version = '4.2.0'
  $install_dir_path = '/var/lib/solr'
  $solr_index_name = 'fedora'

  $http_service = undef
}
