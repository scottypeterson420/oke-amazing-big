module OKEX
  class ApiError < StandardError
    def initialize(code, data, msg)
      @code = code
      @data = data
      @msg = msg
    end

    def to_s
      "code=#{@code}, data=#{@data}, msg=#{@msg}"
    end
  end
end