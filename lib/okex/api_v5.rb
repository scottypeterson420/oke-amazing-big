class OKEX::ApiV5
  def initialize(client, host)
    @client = client
    @host = host
  end

  def instruments
    client.get(host, "/api/v5/public/instruments?instType=SWAP")
  end

  def account_orders
    resp = client.get(host, "/api/v5/account/positions")
    
    if resp['success']
      return resp['data'].map {|params| OKEX::AccountOrder.new(params)}
    end

    []
  end

  def trade_orders(instrument_id)
    resp = client.get(host, "/api/v5/trade/order?instId=#{instrument_id}")
    
    if resp['code'].to_i == 0 && resp['data'].size > 0
      return resp['data'].map {|params| OKEX::TradeOrder.new(params)}
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