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
end
