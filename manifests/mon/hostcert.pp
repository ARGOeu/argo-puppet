class argo::mon::hostcert {
  include ::gridcert

  File {
    ensure  => present,
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0444',
  }

  $hostcert = '/etc/sensu/certs/hostcert.pem'
  $hostkey = '/etc/sensu/certs/hostkey.pem'

  file { $hostcert:
    source  => $::gridcert::hostcert,
  }
  file { $hostkey:
    mode    => '0400',
    source  => $::gridcert::hostkey,
  }
}
