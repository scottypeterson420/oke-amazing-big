require "okex/version"
require "okex/api"
require "okex/client"
require "okex/coin"
require "openssl"
require "faraday"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module OKEX
  class Error < StandardError; end
end
