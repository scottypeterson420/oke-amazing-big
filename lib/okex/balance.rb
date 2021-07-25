class OKEX::Balance < Struct.new(:currency, :total, :available, :frozen, :upl)
end