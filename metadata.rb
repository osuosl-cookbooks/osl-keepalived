name             'osl-keepalived'
maintainer       'Oregon State University'
maintainer_email 'chef@osuosl.org'
license          'apachev2'
issues_url       'https://github.com/osuosl-cookbooks/osl-keepalived/issues'
source_url       'https://github.com/osuosl-cookbooks/osl-keepalived'
description      'Installs/Configures osl-keepalived'
long_description 'Installs/Configures osl-keepalived'
version          '0.2.2'

depends          'firewall'
depends          'keepalived', '~> 3.1.1'

supports         'centos', '~> 7.0'
