class argo::mon::condor (
  $local_config='puppet:///modules/argo/mon/condor/condor_config.local'
) {

  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }
  
  package { 'condor': 
  }

  file { '/etc/condor/condor_config.local':
    source  => $local_config,
    require => Package['condor'],
  }

  file { '/var/lib/gridprobes':
    ensure => directory,
  }
}
