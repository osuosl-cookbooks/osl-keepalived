name             'osl-keepalived'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
license          'Apache-2.0'
chef_version     '>= 12.18' if respond_to?(:chef_version)
issues_url       'https://github.com/osuosl-cookbooks/osl-keepalived/issues'
source_url       'https://github.com/osuosl-cookbooks/osl-keepalived'
description      'Installs/Configures osl-keepalived'
long_description 'Installs/Configures osl-keepalived'
version          '0.2.2'

depends          'firewall'
depends          'keepalived', '~> 3.1.1'

supports         'centos', '~> 7.0'
