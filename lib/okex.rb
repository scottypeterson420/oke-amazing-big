require "okex/version"
require "okex/api_v3"
require "okex/api_v5"
require "okex/client"
require "okex/coin/bitcoin"
require "okex/coin/usdt"
require "okex/order"
require "okex/host"
require "okex/max_size"
require "okex/api_error"
require "okex/balance"



module OKEX
  class Error < StandardError; end
end
