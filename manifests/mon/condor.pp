class argo::mon::condor (
  $local_config='puppet:///modules/argo/mon/condor/condor_config.local',
  $handle_package=true
) {

  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  if ($handle_package) {
    if (Integer($facts['os']['release']['major']) > 7) {
      file { '/etc/yum.repos.d/htcondor.repo': 
        source => 'puppet:///modules/argo/mon/condor/htcondor.repo',
        mode   => '0644',
      }
    }
    
    package { 'condor': 
    }
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
