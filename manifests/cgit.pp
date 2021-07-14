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
    include apache::mod::cgi

    profile_apache::vhost { 'cgit':
      ensure            => present,
      servername        => $servername,
      serveraliases     => $serveraliases,
      port              => 80,
      docroot           => $cgit_home,
      manage_docroot    => false,
      directories       => [
        {
          'path'           => $cgit_home,
          'allow_override' => 'None',
          'options'        => 'ExecCGI',
          'order'          => 'allow,deny',
        }
      ],
      aliases           => [
        {
          alias => '/cgit.png',
          path  => "${cgit_home}/cgit.png",
        },
        {
          alias => '/cgit.css',
          path  => "${cgit_home}/cgit.css",
        },
        {
          alias => '/',
          path  => "${cgit_home}/cgit.cgi/",
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

}
