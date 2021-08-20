#
#
#
class profile_git (
  Boolean $setup_cgit,
  Boolean $setup_gitolite,
) {
  if $setup_cgit {
    include profile_git::cgit
  }
  if $setup_gitolite {
    include profile_git::gitolite
  }

}
