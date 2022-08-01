class argo::mon::robotcert (
  $key  = 'puppet:///private/robotcert/robotkey.pem',
  $cert = 'puppet:///private/robotcert/robotcert.pem',
) {
  File {
    ensure  => present,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0444',
    require => [ Package['nagios'], Package['argo-ncg'] ],
  }

  file { '/etc/nagios/globus/robotcert.pem':
    source  => $cert,
    notify  => Exec['/usr/local/libexec/update_ca_bundle'],
  }

  file { '/etc/nagios/globus/robotkey.pem':
    mode    => '0400',
    source  => $key,
  }
}
