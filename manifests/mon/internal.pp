class argo::mon::internal (
  $argo_public_devel='puppet:///private/ncg/ncg.argo-public-devel',
  $argo_public_prod='puppet:///private/ncg/ncg.argo-public-production',
  $localdb_contacts='puppet:///private/ncg/ncg.localdb.contacts',
  $localdb_sites='puppet:///private/ncg/ncg.localdb.sites',
  $confd='puppet:///private/ncg/ncg.conf.d',
) {
  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644'
  }

  package { ['nagios-plugins-ping', 'nagios-plugins-igtf', 'nagios-plugins-nrpe', 'nagios-plugins-argo']:
  }

  file { '/etc/argo-ncg/ncg.argo-public-devel': 
    source  => $argo_public_devel,
    require => Package['argo-ncg']
  }

  file { '/etc/argo-ncg/ncg.argo-public-production': 
    source  => $argo_public_prod,
    require => Package['argo-ncg']
  }

  file { '/etc/argo-ncg/ncg.localdb.contacts': 
    source  => $localdb_contacts,
    require => Package['argo-ncg']
  }

  file { '/etc/argo-ncg/ncg.localdb.sites': 
    source  => $localdb_sites,
    require => Package['argo-ncg']
  }

  file { '/etc/argo-ncg/ncg.conf.d': 
    ensure  => directory,
    recurse => remote,
    source  => $confd,
  }
}
