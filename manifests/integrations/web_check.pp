# Class: datadog_agent::integrations::web_check
#
# This class will install the necessary config to hook the http_check in the agent
#
# Parameters:
#   url
#   timeout
#
# Example
# puppet apply -e 'class {'datadog_agent::integrations::web_check': timeout => "1", urls => ["http://google.com","http://httpbin.org/status/400"],}'
#
class datadog_agent::integrations::web_check (
  $urls          = undef,
  $timeout       = 1,
  $expected_code = 200,
) inherits datadog_agent::params {
  include datadog_agent

  file { "${datadog_agent::params::conf_dir}/web_check.yaml":
    ensure  => file,
    owner   => $datadog_agent::params::dd_user,
    group   => $datadog_agent::params::dd_group,
    mode    => '0600',
    content => template('datadog_agent/agent-conf.d/web_check.yaml.erb'),
    require => Package[$datadog_agent::params::package_name],
    notify  => Service[$datadog_agent::params::service_name]
  }
  file { "${datadog_agent::params::checks_dir}/web_check.py":
    ensure  => file,
    owner   => $datadog_agent::params::dd_user,
    group   => $datadog_agent::params::dd_group,
    mode    => '0600',
    source  => 'puppet:///modules/datadog_agent/web_check.py',
    require => Package[$datadog_agent::params::package_name],
    notify  => Service[$datadog_agent::params::service_name]
  }

}
