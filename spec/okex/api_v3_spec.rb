RSpec.describe OKEX::ApiV3 do
  before do
    @client = double("client")

    @api = OKEX::ApiV3.new(@client)
  end

  describe "#balance" do
    it "returns balance of coin" do
      expect(@client).to receive(:get).with("/api/account/v3/wallet/BTC")

      @api.balance(OKEX::Coin::Bitcoin)
    end
  end

  describe "#instruments" do
    it "returns all instruments" do
      expect(@client).to receive(:get).with("/api/swap/v3/instruments")

      @api.instruments
    end
  end

  describe "#short_swap" do
    it "places a swap order to short" do
      expect(@client).to receive(:post).with("/api/swap/v3/order", {
        "instrument_id": "BTC-USDT-SWAP",
        "size": "1",
        "type": "2",
        "order_type": "4"
      })

      @api.short_swap("BTC-USDT-SWAP", 1)
    end
  end

  describe "#close_long" do
    it "closes long position using market order" do
      expect(@client).to receive(:post).with("/api/swap/v3/close_position", {
        "instrument_id": "BTC-USDT-SWAP",
        "direction": "long"
      })

      @api.close_long("BTC-USDT-SWAP")
    end
  end

  describe "#close_short" do
    it "closes short position using market order" do
      expect(@client).to receive(:post).with("/api/swap/v3/close_position", {
        "instrument_id": "BTC-USDT-SWAP",
        "direction": "short"
      })

      @api.close_short("BTC-USDT-SWAP")
    end
  end

end
