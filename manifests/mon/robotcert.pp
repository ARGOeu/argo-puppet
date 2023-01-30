class argo::mon::robotcert (
  $key  = 'puppet:///private/robotcert/robotkey.pem',
  $cert = 'puppet:///private/robotcert/robotcert.pem',
) {
  if ($argo::mon::sensu) {
    file { '/etc/sensu/certs':
      ensure => directory,
    }

    File {
      ensure  => present,
      owner   => 'sensu',
      group   => 'sensu',
      mode    => '0444',
    }

    $robotcert = '/etc/sensu/certs/robotcert.pem'
    $robotkey = '/etc/sensu/certs/robotkey.pem'
  } else {
    File {
      ensure  => present,
      owner   => 'nagios',
      group   => 'nagios',
      mode    => '0444',
      require => [ Package['nagios'], Package['argo-ncg'] ],
    }

    $robotcert = '/etc/nagios/globus/robotcert.pem'
    $robotkey = '/etc/nagios/globus/robotkey.pem'
  }

  file { $robotcert:
    source  => $cert,
    notify  => Exec['/usr/local/libexec/update_ca_bundle'],
  }

  file { $robotkey:
    mode    => '0400',
    source  => $key,
  }
}
