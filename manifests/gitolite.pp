#
#
#
class profile_git::gitolite (
  Hash $users,
) {
  class { 'gitolite':
    user     => 'git',
    userhome => '/srv/gitolite',
  }

  class { 'gitolite::admin':
    add_testing_repo => false,
  }

  create_resources('gitolite::user', $users)
}
