class argo::mon::condor (
  $local_config='puppet:///modules/argo/mon/condor/condor_config.local',
  $version='10.x'
) {

  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  if (Integer($facts['os']['release']['major']) > 7) {
    file { '/etc/yum.repos.d/htcondor.repo': 
      content => template('argo/mon/condor/htcondor.repo.erb'),
      mode   => '0644',
    }
  }
    
  package { 'condor': 
  }

  file { '/etc/condor/condor_config.local':
    source  => $local_config,
    require => Package['condor'],
  }

  file { '/var/lib/gridprobes':
    ensure => directory,
    mode   => '0666',
  }
}
