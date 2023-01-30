class argo::mon::sensu (
  $agent        = false,
  $backend      = false,
  $secrets_file = '',
  $tenants      = [],
) {
  include ::yum::repo::umd4
  include ::yum::repo::srce::intern

  if ($secrets_file) {
    file { '/etc/sensu/secret_envs':
      ensure => present,
      owner  => 'sensu',
      group  => 'sensu',
      source => $secrets_file,
    }
  }

  if ($agent) {
    include sensu::agent
    include argo::mon::poemtools

    file { '/etc/sensu/certs':
      ensure => directory,
    }

    file { '/var/log/sensu':
      ensure => directory,
      owner  => 'sensu',
      group  => 'sensu',
    }
  }

  if ($backend) {
    include sensu::backend

    include argo::mon::amspublisher
    include argo::mon::scg

    $tenants.each | String $tenant | {
      sensu_namespace { $tenant:
        ensure => present,
      }

      sensu_bonsai_asset { "sensu/sensu-slack-handler in ${tenant}":
        ensure  => present,
        version => '1.5.0',
        rename  => 'sensu-slack-handler',
      }
    }
  }
}