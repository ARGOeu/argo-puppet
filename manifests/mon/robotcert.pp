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

  $robotcert = '/etc/sensu/certs/robotcert.pem'
  $robotkey = '/etc/sensu/certs/robotkey.pem'

  file { $robotcert:
    source  => $cert,
    notify  => Exec['/usr/local/libexec/update_ca_bundle'],
  }

  file { $robotkey:
    mode    => '0400',
    source  => $key,
  }
}
