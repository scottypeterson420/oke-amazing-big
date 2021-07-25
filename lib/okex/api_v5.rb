class OKEX::ApiV5
  def initialize(client, host)
    @client = client
    @host = host
  end

  def instruments
    client.get(host, "/api/v5/public/instruments?instType=SWAP")
  end

  def orders(inst_id=nil)
    url = "/api/v5/account/positions"
    if inst_id.present?
      url += "?instId=#{inst_id}"
    end

    resp = client.get(host, url)
    
    if resp['success']
      return resp['data'].map {|params| OKEX::Order.new(params)}
    end

    []
  end

  def short_swap(instid, amount)
    params = {
      "instId": instid,
      "tdMode": "cross",
      "side": "sell",
      "posSide": "short",
      "ordType": "market",
      "sz": "1"
    }

    client.post(host, "/api/v5/trade/order", params)
  end

  def close_long(instrument_id)
    close_position(instrument_id, "long")
  end

  def close_short(instrument_id)
    close_position(instrument_id, "short")
  end

  def max_size(instrument_id)
    result = client.get(host, "/api/v5/account/max-size?instId=#{instrument_id}&tdMode=cross")
    
    ret = OKEX::MaxSize.new(-1, -1)
    if result['success']
      el = result['data'][0]
      if el.present? && el['maxBuy'].to_i > 0 && el['maxSell'].to_i > 0
        ret = OKEX::MaxSize.new(el['maxBuy'].to_i, el['maxSell'].to_i)
      end
    end
    
    ret
  end

  private

  attr_reader :client, :host

  def close_position(instrument_id, direction)
    params = {
      "instId": instrument_id,
      "mgnMode": "cross",
      "posSide": direction
    }

    client.post(host, "/api/v5/trade/close-position", params)
  end
end