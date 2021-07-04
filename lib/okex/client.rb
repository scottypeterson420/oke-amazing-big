require 'rest-client'

module OKEX
  class Client
    def initialize(key, secret, passphrase)
      @api_key = key
      @api_secret = secret
      @passphrase = passphrase
    end

    def balance(coin)
      _get("/api/account/v3/wallet/#{coin.code}")
    end

    # name: sub account name
    def sub_account(name)
      _get("/api/account/v3/sub-account?sub-account=#{name}")
    end

    private

    attr_reader :api_key, :api_secret, :passphrase

    HOST = "https://www.okex.com"

    def _get(path)
      ts = timestamp
      sig = sign(ts, "GET", path)

      _resp(::RestClient.get(HOST + path, headers(ts, sig)))
    end

    def sign(timestamp, method, path)
      msg = "#{timestamp}#{method}#{path}"
      digest = OpenSSL::HMAC.digest("sha256", api_secret, msg)

      Base64.encode64(digest)
    end

    def timestamp
       Time.now.utc.iso8601(3)
    end

    def headers(timestamp, sign)
      {
        'OK-ACCESS-KEY': api_key,
        'OK-ACCESS-SIGN': sign,
        'OK-ACCESS-TIMESTAMP': timestamp,
        'OK-ACCESS-PASSPHRASE': passphrase
      }
    end

    def _resp(result)
      raise "Bad response from server" if result.code != 200

      JSON.parse(result.body).with_indifferent_access
    end
  end
end
