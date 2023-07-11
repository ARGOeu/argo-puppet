class argo::mon::poemtools (
  $poem_url   = '',
  $poem_token = '',
  $profiles   = '',
) {
  package {'argo-poem-tools':
    ensure => latest,
  }

  file { '/etc/argo-poem-tools/argo-poem-tools.conf':
    content => template('argo/mon/poemtools/argo-poem-tools.conf.erb'),
    require => Package['argo-poem-tools'],
  }

  if ($argo::mon::sensu) {
    $cron_command = '/bin/argo-poem-packages.py'
  } else {
    $cron_command = '/bin/argo-poem-packages.py --include-internal'
  }

  cron::job { 'poemPackages':
    command     => $cron_command,
    user        => 'root',
    hour        => '*/2',
    minute      => '0',
    environment => [ 'PATH=/sbin:/bin:/usr/sbin:/usr/bin' ],
  }
}
