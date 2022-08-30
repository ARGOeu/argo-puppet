class argo::mon::robotcert (
  $key  = 'puppet:///private/robotcert/robotkey.pem',
  $cert = 'puppet:///private/robotcert/robotcert.pem',
) {
  File {
    ensure  => present,
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0444',
  }

  file { '/etc/sensu/certs/robotcert.pem':
    source  => $cert,
    notify  => Exec['/usr/local/libexec/update_ca_bundle'],
  }

  file { '/etc/sensu/certs/robotkey.pem':
    mode    => '0400',
    source  => $key,
  }
}
