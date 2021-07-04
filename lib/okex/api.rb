module OKEX
  class API
    def initialize(client)
      @client = client
    end

    def balance(coin)
      client.balance(coin)
    end

    private

    attr_reader :client
  end
end
