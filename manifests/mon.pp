class argo::mon (
  $gridcert     = false,
  $robotcert    = false,
  $agent        = false,
  $secrets_file = '',
) {
  include yum::repo::umd4

  include argo::mon::poemtools
  include argo::mon::caupdate

  if ($gridcert) {
    include argo::mon::hostcert
  }

  if ($agent) {
    if ($robotcert) {
      include argo::mon::robotcert
    }
  } else {
    include argo::mon::amspublisher
    include argo::mon::scg
  }

  if ($secrets_file) {
    file { '/etc/sensu/secret_envs':
      ensure => present,
      owner  => 'sensu',
      group  => 'sensu',
      source => $secrets_file,
    }
  }
}
