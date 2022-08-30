class argo::mon::amspublisher (
  $hostname                = '',
  $publisher_queues_topics = {},
) {
  package {'argo-sensu-ams-publisher':
    ensure => latest,
  }

  file { '/etc/ams-publisher/ams-publisher-sensu.conf':
    content => template('argo/mon/amspublisher/ams-publisher.conf.erb'),
    notify  => Service['ams-publisher-sensu.service'],
  }

  service { 'ams-publisher-sensu.service':
    ensure  => 'running',
    enable  => true,
    require => [ Package['argo-sensu-ams-publisher'], File['/etc/ams-publisher/ams-publisher-sensu.conf'] ],
  }
}
