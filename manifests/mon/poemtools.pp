class argo::mon::poemtools (
  $poem_url   = '',
  $poem_token = '',
  $profiles   = '',
  $command    = '/bin/argo-poem-packages.py',
) {
  package {'argo-poem-tools':
    ensure => latest,
  }

  file { '/etc/argo-poem-tools/argo-poem-tools.conf':
    content => template('argo/mon/poemtools/argo-poem-tools.conf.erb'),
    require => Package['argo-poem-tools'],
  }

  cron::job { 'poemPackages':
    command     => $command,
    user        => 'root',
    hour        => '*/2',
    minute      => '0',
    environment => [ 'PATH=/sbin:/bin:/usr/sbin:/usr/bin' ],
  }
}
