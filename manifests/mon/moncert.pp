class argo::mon::moncert (
  $key  = 'puppet:///private/actualcert/moncert.key',
  $cert = 'puppet:///private/actualcert/moncert.pem',
) {
  File {
    ensure  => present,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0444',
    require => [ Package['nagios'], Package['argo-ncg'] ],
  }

  file { '/etc/nagios/globus/moncert.pem':
    source  => $cert,
  }
  file { '/etc/nagios/globus/moncert.key':
    mode    => '0400',
    source  => $key,
  }
}
