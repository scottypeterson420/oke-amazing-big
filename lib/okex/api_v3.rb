class OKEX::ApiV3
  def initialize(client)
    @client = client
  end

  def balance(coin)
    client.get("/api/account/v3/wallet/#{coin.code}")
  end

  def instruments
    client.get("/api/swap/v3/instruments")
  end

  # 市价做空永续合约
  # amount: 仓位开多少张
  def short_swap(instrument_id, amount)
    param = {
      instrument_id: instrument_id.to_s,
      size: amount.to_s,
      type: "2",
      order_type: "4",
    }

    client.post("/api/swap/v3/order", param)
  end

  # 市价平多
  def close_long(instrument_id)
    close_position(instrument_id, "long")
  end

  # 市价平空
  def close_short(instrument_id)
    close_position(instrument_id, "short")
  end

  private

  attr_reader :client

  def close_position(instrument_id, direction)
    param = {"instrument_id": instrument_id, "direction": direction}

    client.post("/api/swap/v3/close_position", param)
  end
end
