require "okex/coin/bitcoin"

RSpec.describe OKEX::Coin::Bitcoin do
  it "has code name" do
    expect(described_class.code).to eq("BTC")
  end
end
