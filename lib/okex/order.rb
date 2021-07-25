module OKEX
  class Order
    POS_LONG = 'long'.freeze
    POS_SHORT = 'short'.freeze

    def initialize(params)
      @params = params
    end

    def inst_id
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

    # 最新成交价
    def last_price
      dig("last").to_f
    end

    # 持仓方向
    def position_side
      side = dig("posSide")
      if [POS_SHORT, POS_LONG].include?(side)
        return side
      end
    end

    def long?
      position_side == POS_LONG
    end

    def short?
      position_side == POS_SHORT
    end

    # 开仓方向名称
    def position_name
      case position_side
      when POS_SHORT
        '空'
      when POS_LONG
        '多'
      end
    end

    # 未实现收益
    def upl
      dig("upl").to_f
    end

    # 持仓张数
    def pos
      dig("pos").to_i
    end

    # 是否正在持仓
    def open?
      pos > 0
    end

    # 已经平仓
    def closed?
      pos == 0
    end

    private

    def dig(key)
      @params[key]
    end
  end
end