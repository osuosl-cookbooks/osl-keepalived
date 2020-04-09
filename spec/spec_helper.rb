require 'chefspec'
require 'chefspec/berkshelf'

CENTOS_7 = {
  platform: 'centos',
  version: '7',
}.freeze

CENTOS_8 = {
  platform: 'centos',
  version: '8',
}.freeze

ALL_PLATFORMS = [
  CENTOS_6,
  CENTOS_7,
].freeze

RSpec.configure do |config|
  config.log_level = :warn
end
