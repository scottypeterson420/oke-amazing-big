require 'time'
require 'base64'
require 'json'

module OKEX
  class Client
    def initialize(key, secret, passphrase)
      @api_key = key
      @api_secret = secret
      @passphrase = passphrase
    end

    def get(path)
      ts = timestamp
      sig = sign(ts, "GET", path)

      _resp(::Faraday.get(HOST + path, nil, headers(ts, sig)))
    end

    def post(path, payload)
      payload_json = gen_payload(payload)

      ts = timestamp
      sig = sign(ts, "POST", path + payload_json)

      begin
        conn = ::Faraday.new(HOST + path, :ssl => {:verify => false})
        result = conn.post(HOST + path, payload_json, headers(ts, sig))
        _resp(result)
      rescue => e
        puts "[error] #{e.inspect}"
      end
    end

    private

    attr_reader :api_key, :api_secret, :passphrase

    HOST = "https://www.okex.com"

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
