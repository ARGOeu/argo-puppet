class argo::mon::sensu (
  $agent           = false,
  $backend         = false,
  $secrets_file    = '',
  $tenants         = [],
  $amspublisher    = true,
  $include_passive = false,
) {
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
      owner  => 'sensu',
      group  => 'sensu',
    }

    file { '/var/log/sensu':
      ensure => directory,
      owner  => 'sensu',
      group  => 'sensu',
    }

    if ($include_passive) {
      include argo::mon::sensutools
    }
  }

  if ($backend) {
    include sensu::backend

    if ($amspublisher) {
      include argo::mon::amspublisher
    }
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

      sensu_bonsai_asset { "sensu/check-cpu-usage in ${tenant}":
        ensure  => present,
        version => '0.2.2',
        rename  => 'check-cpu-usage',
      }

      sensu_bonsai_asset { "sensu/check-memory-usage in ${tenant}":
        ensure  => present,
        version => '0.2.2',
        rename  => 'check-memory-usage',
      }
    }
  }
}
