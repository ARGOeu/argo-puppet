class argo::mon::copr () {

  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  if (Integer($facts['os']['release']['major']) > 7) {
    file { '/etc/yum.repos.d/copr.repo': 
      source => 'puppet:///modules/argo/mon/repos/copr.repo',
    }
  }

}
