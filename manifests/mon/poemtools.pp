class argo::mon::poemtools (
  $tenants_data = {},
  $cron_hour    = '*/2',
  $cron_minute  = '45',
) {
  package {'argo-poem-tools':
    ensure => latest,
  }

  file { '/etc/argo-poem-tools/argo-poem-tools.conf':
    content => template('argo/mon/poemtools/argo-poem-tools.conf.erb'),
    require => Package['argo-poem-tools'],
  }

  cron::job { 'poemPackages':
    command     => '/bin/argo-poem-packages.py',
    user        => 'root',
    hour        => $cron_hour,
    minute      => $cron_minute,
    environment => [ 'PATH=/sbin:/bin:/usr/sbin:/usr/bin' ],
  }
}
