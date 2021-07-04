require "okex/coin/bitcoin"

RSpec.describe OKEX::API do
  let(:client) { double }
  let(:api) { OKEX::API.new(client) }

  describe "#balance" do
    it "returns account balance of one coin" do
      coin = OKEX::Coin::Bitcoin

      expect(client).to receive(:balance).with(coin).and_return(0)

      expect(api.balance(coin)).to eq(0)
    end
  end

  describe "#sub_account" do
    it "returns sub account balance info" do
      expected_result = {
        "data": {
          "sub_account": "Test",
          "asset_valuation": 0.00003463,
          "account_type:futures": [
            {
              "balance": 0.00000245,
              "max_withdraw": 0.00000245,
              "currency": "BTC",
              "underlying": "BTC-USD",
              "equity": 0.00000245
            },
            {
              "balance": 1.053473,
              "max_withdraw": 1.053473,
              "currency": "XRP",
              "underlying": "XRP-USD",
              "equity": 1.053473
            }
          ],
          "account_type:spot": [
            {
              "balance": 0.000312544038152,
              "max_withdraw": 0.000312544038152,
              "available": 0.000312544038152,
              "currency": "USDT",
              "hold": 0
            }
          ]
        }
      }.with_indifferent_access

      expect(client).to receive(:sub_account).with("Test").and_return(expected_result)

      result = api.sub_account("Test")
      expect(result["data"]["sub_account"]).to eq("Test")
    end
  end

  describe "#instruments" do
    it "returns public instruments info" do
      expected_result = [
        {
          "instrument_id":"BTC-USD-SWAP",
          "underlying_index":"BTC",
          "quote_currency":"USD",
          "coin":"BTC",
          "contract_val":"100",
          "listing":"2018-08-28T02:43:23.000Z",
          "delivery":"2019-11-26T08:00:00.000Z",
          "size_increment":"1",
          "tick_size":"0.1",
          "base_currency":"BTC",
          "underlying":"BTC-USD",
          "settlement_currency":"BTC",
          "is_inverse":"true",
          "category":"1",
          "contract_val_currency":"USD"
        }.with_indifferent_access
      ]

      expect(client).to receive(:instruments).and_return(expected_result)

      result = api.instruments
      expect(result[0]["instrument_id"]).to_not eq(nil)
    end
  end
end
