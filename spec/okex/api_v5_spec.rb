RSpec.describe OKEX::ApiV5 do
  before do
    @client = double("client")

    @api = OKEX::ApiV5.new(@client)
  end

  # describe "#balance" do
  #   it "returns balance of coin" do
  #     expect(@client).to receive(:get).with("/api/account/v3/wallet/BTC")

  #     @api.balance(OKEX::Coin::Bitcoin)
  #   end
  # end

  describe "#instruments" do
    it "returns all instruments" do
      expect(@client).to receive(:get).with("/api/v5/public/instruments")

      @api.instruments
    end
  end

  describe "#short_swap" do
    it "places a swap order to short" do
      expect(@client).to receive(:post).with("/api/v5/trade/order", {
        "instId": "BTC-USDT-SWAP",
        "tdMode": "cross",
        "side": "sell",
        "posSide": "short",
        "ordType": "market",
        "sz": "1"
      })

      @api.short_swap("BTC-USDT-SWAP", 1)
    end
  end

  describe "#close_long" do
    it "closes long position using market order" do
      expect(@client).to receive(:post).with("/api/v5/trade/close-position", {
        "instId": "BTC-USDT-SWAP",
        "mgnMode": "cross",
        "posSide": "long"
      })

      @api.close_long("BTC-USDT-SWAP")
    end
  end

  describe "#close_short" do
    it "closes short position using market order" do
      expect(@client).to receive(:post).with("/api/v5/trade/close-position", {
        "instId": "BTC-USDT-SWAP",
        "mgnMode": "cross",
        "posSide": "short"
      })

      @api.close_short("BTC-USDT-SWAP")
    end
  end
end
