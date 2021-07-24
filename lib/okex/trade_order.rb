module OKEX
  class TradeOrder < Order

    # 预估强平价
    def est_liq_price
      dig("liqPx").to_f
    end

    # 最新成交价
    def last_price
      dig("fillPx").to_f
    end

    # 未实现收益
    def upl
      dig("pnl").to_f
    end

    # 持仓张数
    def pos
      dig("sz").to_i
    end
  end
end
