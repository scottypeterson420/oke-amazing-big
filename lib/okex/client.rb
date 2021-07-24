require 'time'
require 'base64'
require 'json'
require 'faraday'

module OKEX
  class Client
    def initialize(key, secret, passphrase)
      @api_key = key
      @api_secret = secret
      @passphrase = passphrase
    end

    def get(host, path)
      ts = timestamp
      sig = sign(ts, "GET", path)

      _resp(Faraday.get(host + path, nil, headers(ts, sig)))
    end

    def post(host, path, payload)
      payload_json = gen_payload(payload)

      ts = timestamp
      sig = sign(ts, "POST", path + payload_json)

      _resp(Faraday.post(host + path, payload_json, headers(ts, sig)))
    end

    private

    attr_reader :api_key, :api_secret, :passphrase

    def gen_payload(payload)
      m = payload.map { |k, v| JSON.generate({k => v}, {space: ' '})}
      m2 = m.join(", ").gsub("{", "").gsub("}", "")

      "{#{m2}}"
    end

    def sign(timestamp, method, path)
      msg = "#{timestamp}#{method}#{path}"
      digest = OpenSSL::HMAC.digest("sha256", api_secret, msg)

      Base64.strict_encode64(digest)
    end

    def timestamp
      Time.now.utc.iso8601(3)
    end

    def headers(timestamp, sign)
      {
        'OK-ACCESS-KEY': api_key,
        'OK-ACCESS-SIGN': sign,
        'OK-ACCESS-TIMESTAMP': timestamp,
        'OK-ACCESS-PASSPHRASE': passphrase,
        'Content-Type': 'application/json'
      }
    end

    def _resp(result)
      JSON.parse(result.body)
    end
  end
end
