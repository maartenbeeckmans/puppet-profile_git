#
#
#
class profile_git (
  Boolean $setup_cgit,
  Boolean $setup_gitolite,
  Hash    $repositories,
) {
  if $setup_cgit {
    include profile_git::cgit
  }
  if $setup_gitolite {
    include profile_git::gitolite
  }

  create_resources('profile_git::repository', $repositories)
}
