#
#
#
class profile_git (
  Boolean $setup_cgit,
) {
  if $setup_cgit {
    include profile_git::cgit
  }
}
