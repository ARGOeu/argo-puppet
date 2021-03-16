class argo::mon::hostcert (
  $hostcert = 'puppet:///private/gridcert/hostcert.pem',
  $hostkey  = 'puppet:///private/gridcert/hostkey.pem',
) {

  include gridcert::package

  File {
    ensure  => present,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0444',
    require => [ Package['nagios'], Package['argo-ncg'] ],
  }

  file { '/etc/nagios/globus/hostcert.pem':
    source  => $hostcert,
  }
  file { '/etc/nagios/globus/hostkey.pem':
    mode    => '0400',
    source  => $hostkey,
  }
}
