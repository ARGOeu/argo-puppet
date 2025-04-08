class argo::mon::amspublisher (
  $nagioshost              = '',
  $runuser                 = 'sensu',
  $publisher_queues_topics = {},
) {
  package { 'python3-argo-ams-library':
    ensure => latest,
  }
  
  if (Integer($facts['os']['release']['major']) < 8) {
    package { 'python-argo-ams-library':
      ensure => latest,
    }
  }

  $package_name = 'argo-sensu-ams-publisher'
  $conf_file    = '/etc/ams-publisher/ams-publisher-sensu.conf'
  $service_name = 'ams-publisher-sensu.service'

  package { $package_name:
    ensure => latest,
  }

  file { $conf_file:
    content => template('argo/mon/amspublisher/ams-publisher.conf.erb'),
    notify  => Service[$service_name],
  }

  service { $service_name:
    ensure  => 'running',
    enable  => true,
    require => [ Package[$package_name], File[$conf_file] ],
  }
}
