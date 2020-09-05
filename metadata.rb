name             'osl-keepalived'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
license          'Apache-2.0'
chef_version     '>= 14.0'
issues_url       'https://github.com/osuosl-cookbooks/osl-keepalived/issues'
source_url       'https://github.com/osuosl-cookbooks/osl-keepalived'
description      'Installs/Configures osl-keepalived'
version          '0.4.0'

depends          'firewall'
depends          'keepalived', '~> 5.1.0'

supports         'centos', '~> 7.0'
supports         'centos', '~> 8.0'
