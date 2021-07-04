module OKEX
  class API
    def initialize(client)
      @client = client
    end

    def method_missing(m, *args, &block)
      client.send(m, *args)
    end

    private

    attr_reader :client
  end
end
