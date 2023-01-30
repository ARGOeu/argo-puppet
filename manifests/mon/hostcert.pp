class argo::mon::hostcert {

  include ::yum::repo::umd4
  include ::gridcert
  include ::gridcert::crl

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

    $hostcert = '/etc/sensu/certs/hostcert.pem'
    $hostkey = '/etc/sensu/certs/hostkey.pem'
  } else {
    File {
      ensure  => present,
      owner   => 'nagios',
      group   => 'nagios',
      mode    => '0444',
      require => [ Package['nagios'], Package['argo-ncg'] ],
    }

    $hostcert = '/etc/nagios/globus/hostcert.pem'
    $hostkey = '/etc/nagios/globus/hostkey.pem'
  }

  file { $hostcert:
    source  => $::gridcert::hostcert,
  }
  file { $hostkey:
    mode    => '0400',
    source  => $::gridcert::hostkey,
  }
}
