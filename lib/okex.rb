require "okex/version"
require "okex/api_v3"
require "okex/api_v5"
require "okex/client"
require "okex/coin"
require "openssl"
require "faraday"

module OKEX
  class Error < StandardError; end
end
