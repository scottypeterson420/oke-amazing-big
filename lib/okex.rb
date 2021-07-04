require "okex/version"
require "okex/api"
require "okex/client"
require "okex/coin"

require "active_support/core_ext/hash/indifferent_access"

module OKEX
  class Error < StandardError; end
end
