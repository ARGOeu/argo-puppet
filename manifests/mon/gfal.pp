class argo::mon::gfal (
  $config="puppet:///modules/argo/mon/gfal/http_plugin.conf"
) {

  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  package { 'gfal2-plugin-http': 
  }

  file { '/etc/gfal2.d/http_plugin.conf':
    source  => $config,
    require => Package['gfal2-plugin-http']
  }
}
