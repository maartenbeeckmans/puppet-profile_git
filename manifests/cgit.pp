#
#
#
class profile_git::cgit (
  String               $cgit_package_name,
  String               $cgit_package_ensure,
  String               $cgit_highlighting_package_name,
  String               $cgit_highlighting_package_ensure,
  Boolean              $manage_apache,
  Stdlib::AbsolutePath $cgit_home,
  String               $servername,
  Array[String]        $serveraliases,
  Boolean              $manage_sd_service,
  Array                $sd_service_tags,
) {
  package { $cgit_package_name:
    ensure => $cgit_package_ensure,
  }

  package { $cgit_highlighting_package_name:
    ensure => $cgit_highlighting_package_ensure,
  }

  if $manage_apache {
    include profile_apache
    apache::mod { 'cgi': }

    profile_apache::vhost { 'cgit':
      ensure            => present,
      servername        => $servername,
      serveraliases     => $serveraliases,
      setenv            => ['GIT_PROJECT_ROOT /var/lib/gitolite3/repositories/'],
      port              => 80,
      docroot           => '/usr/share/cgit/',
      manage_docroot    => false,
      directories       => [
        {
          'path'           => '/usr/share/cgit/',
          'allow_override' => 'None',
          'options'        => 'None',
          'require'        => 'all granted',
        },
        {
          'path'           => "$cgit_home/",
          'allow_override' => 'None',
          'options'        => 'ExecCGI FollowSymlinks',
          'require'        => 'all granted',
        }
      ],
      aliases           => [
        {
          scriptalias => '/',
          path        => "${cgit_home}/cgit.cgi/",
        },
        {
          alias => '/cgit-css',
          path  => '/usr/share/cgit/',
        },
      ],
      manage_sd_service => $manage_sd_service,
      sd_service_tags   => $sd_service_tags,
    }
  }

  $_cgit_config = {
    'cgit_home' => $cgit_home,
  }
  file { '/etc/cgitrc':
    ensure  => present,
    mode    => '0755',
    content => epp("${module_name}/cgitrc.epp", $_cgit_config)
  }

  concat { '/etc/cgitrc.gitolite':
    ensure => present,
  }
}
