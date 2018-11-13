require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'osl-keepalived' }

CENTOS_7 = {
  platform: 'centos',
  version: '7.4.1708',
}.freeze

CENTOS_6 = {
  platform: 'centos',
  version: '6.9',
}.freeze

DEBIAN_8 = {
  platform: 'debian',
  version: '9.3',
}.freeze

ALL_PLATFORMS = [
  CENTOS_6,
  CENTOS_7,
  DEBIAN_8,
].freeze

RSpec.configure do |config|
  config.log_level = :fatal
end
