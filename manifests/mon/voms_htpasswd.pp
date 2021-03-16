class argo::mon::voms_htpasswd (
  $conf_source = 'puppet:///private/voms_htpasswd/argo-voms-htpasswd.conf',
  $localdb = false,
  $localdb_source = 'puppet:///private/voms_htpasswd/argo-voms-htpasswd.d/',
) {
  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  file { '/etc/argo-voms-htpasswd/argo-voms-htpasswd.conf':
    source  => $conf_source,
    require => Package['argo-nagios-tools'],
    notify  => Service['argo-voms-htpasswd'],
  }

  service { 'argo-voms-htpasswd':
    ensure   => 'running',
    enable   => true,
    require  => [ File['/etc/argo-voms-htpasswd/argo-voms-htpasswd.conf'] ],
    provider => 'redhat',
  }


  if ( $localdb ) {
    file { '/etc/argo-voms-htpasswd/argo-voms-htpasswd.d/':
      ensure  => directory,
      recurse => remote,
      source  => $localdb_source,
      require => Package['argo-nagios-tools'],
      notify  => Service['argo-voms-htpasswd'],
    }
  }
}
