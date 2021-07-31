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
      url = host + path
      ts = timestamp
      sig = sign(ts, "GET", path)
      _h = headers(ts, sig)

      puts "---> GET: url=#{url}, headers=#{_h}" if ENV['OKEX_DEBUG'].to_i > 0

      _resp(Faraday.get(url, nil, _h))
    end

    def post(host, path, payload)
      if payload.is_a?(Array)
        _json = payload.map do |hx|
          gen_payload(hx)
        end
        payload_json = "[#{_json.join(",")}]"
      else
        payload_json = gen_payload(payload)
      end
      
      url = host + path
      ts = timestamp
      sig = sign(ts, "POST", path + payload_json)
      _h = headers(ts, sig)

      puts "---> POST: url=#{url}, payload=#{payload_json}, headers=#{_h}" if ENV['OKEX_DEBUG'].to_i > 0

      _resp(Faraday.post(url, payload_json, _h))
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
      result = JSON.parse(result.body)
      
      code = result['code'].to_i
      if code == 0 && result['msg'].empty?
        return result['data']
      end

      raise OKEX::ApiError.new(code, result['data'], result['msg'])
    end
  end
end
