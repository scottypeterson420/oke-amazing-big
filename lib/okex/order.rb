module OKEX
  class Order
    POS_LONG = 'long'.freeze
    POS_SHORT = 'short'.freeze

    def initialize(params)
      @params = params
    end

    def instrument_id
      dig("instId")
    end
    
    # 杠杆倍数
    def leverage
      dig("lever")
    end

    def created_at
      Time.at(dig("cTime").to_i / 1000)
    end

    # 平均开仓价
    def avg_open_price
      dig("avgPx").to_f
    end

    # 预估强平价
    def est_liq_price
      dig("liqPx").to_f
    end

    # 持仓方向
    def position_side
      side = dig("posSide")
      if [POS_SHORT, POS_LONG].include?(side)
        return side
      end
    end

    # 未实现收益
    def upl
      dig("upl").to_f
    end

    private

    def dig(key)
      @params[key]
    end
  end
end