#
#
#
class profile_git::gitolite (
  Boolean $sync_repos_cron,
  String  $on_calendar,
  Hash    $users,
  Hash    $user_defaults,
  Hash    $repositories,
  Hash    $repository_defaults,
) {
  class { 'gitolite':
    user     => 'git',
    userhome => '/srv/gitolite',
  }

  class { 'gitolite::admin':
    add_testing_repo => false,
  }

  if $sync_repos_cron {
    profile_base::systemd_timer { 'sync-gitolite-repos':
      on_calendar => $on_calendar,
      command     => '/srv/gitolite/upgrade-repos.sh',
    }
  }

  create_resources('gitolite::user', $users, $user_defaults)
  create_resources('profile_git::repository', $repositories, $repository_defaults)
}
