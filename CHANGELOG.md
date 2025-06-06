osl-keepalived CHANGELOG
========================
This file is used to list changes made in each version of the
osl-keepalived cookbook.

2.7.1 (2025-05-09)
------------------
- Make all mysql VIPs equal so they don't prefer one host or another

2.7.0 (2025-05-05)
------------------
- Make mysql vip stay on whatever host it's currently on

2.6.0 (2024-11-20)
------------------
- Support for AlmaLinux 9

2.5.0 (2024-07-05)
------------------
- Remove Support for CentOS 7

2.4.2 (2024-04-26)
------------------
- Update NICs on mysql-vip2 cluster

2.4.1 (2023-05-04)
------------------
- Use proper mysql vip2 databag name

2.4.0 (2023-04-28)
------------------
- Add mysql-vip1 configuration

2.3.0 (2023-04-27)
------------------
- Add basic preparation changes for Alma Linux 8 

2.2.0 (2022-01-29)
------------------
- Bump keepalived to Chef 17-compliant version

2.1.0 (2021-09-07)
------------------
- Changes to terminology, mainly remove the term 'master'

2.0.0 (2021-05-25)
------------------
- Update to new osl-firewall resources

1.1.0 (2021-04-08)
------------------
- Update required chef version

1.0.2 (2021-03-01)
------------------
- Use correct TLD for phpbb nodes

1.0.1 (2021-01-19)
------------------
- Cookstyle fixes

1.0.0 (2020-09-09)
------------------
- chef 16 update

0.4.0 (2020-07-09)
------------------
- Chef 15 Fixes

0.3.0 (2020-05-18)
------------------
- Add Centos 8 support

0.2.5 (2019-12-23)
------------------
- Chef 14 post-migration fixes

0.2.4 (2018-11-14)
------------------
- Chef 13 fixes for osl-keepalived

0.2.3 (2018-09-07)
------------------
- Enable IPv6 in osl-keepalived::haproxy-phpbb

0.2.2 (2018-08-07)
------------------
- Remove test cookbook from metadata.rb

0.2.1 (2018-08-07)
------------------
- Put vip-mysql2.osuosl.bak on eth1 (backend) interface

0.2.0 (2018-06-27)
------------------
- Create recipes for haproxy-osuosl, haproxy-phpbb, & mysql

0.1.0
-----
- Initial release of osl-keepalived

