class argo::mon::nagios (
  $conf_source       = 'puppet:///modules/argo/mon/nagios/nagios.cfg',
  $cgi_source        = 'puppet:///modules/argo/mon/nagios/cgi.cfg',
  $httpd_conf_source = 'puppet:///modules/argo/mon/nagios/nagios.conf',
) {
  File {
    ensure => present,
    owner  => nagios,
    group  => nagios,
    mode   => '0644',
  }

  package {'nagios':
    ensure  => present,
    require => Package['httpd'],
  }

  file { '/etc/nagios/nagios.cfg':
    source  => $conf_source,
    require => Package['nagios'],
  }

  file { '/etc/nagios/cgi.cfg':
    source  => $cgi_source,
    require => Package['nagios'],
  }

  file { '/etc/httpd/conf.d/nagios.conf':
    owner   => root,
    group   => root,
    source  => $httpd_conf_source,
    require => [ Package['nagios'], Package['httpd'] ],
  }

  service { 'nagios.service':
    ensure  => 'running',
    enable  => true,
    require => [ Package['nagios'], File['/etc/nagios/nagios.cfg'], File['/etc/nagios/cgi.cfg'] ],
  }

  service { 'httpd.service':
    ensure  => 'running',
    enable  => true,
    require => [ Package['httpd'], File['/etc/httpd/conf.d/nagios.conf'] ],
  }
}
