module QuantityHelper

	class Quantity
	  include Comparable

	  CoercedNumber = Struct.new(:value) do
	    def +(other) fail TypeError; end
	    def -(other) fail TypeError; end
	    def *(other)
	      other * value
	    end
	    def /(other) fail TypeError; end
	  end

	  attr_reader :magnitude
	  alias_method :to_f, :magnitude
	  private :magnitude

	  def initialize(magnitude)
	    @magnitude = magnitude.to_f
	    freeze
	  end

	  def to_s
	    "#{@magnitude} #{self.class.name.downcase}"
	  end

	  def to_i
	    to_f.to_i
	  end
	  
	  def inspect
	    "#<#{self.class}:#{@magnitude}>"
	  end

	  def +(other)
	    other = ensure_compatible(other)
	    self.class.new(@magnitude + other.to_f)
	  end

	  def -(other)
	    other = ensure_compatible(other)
	    self.class.new(@magnitude - other.to_f)
	  end

	  def *(other)
	    multiplicand = case other
	                   when Numeric then other
	                   when self.class then other.to_f
	                   else 
	                     fail TypeError, "Don't know how to multiply by #{other}"
	                   end
	    self.class.new(@magnitude * multiplicand)
	  end

	  def /(other)
	    other = ensure_compatible(other)
	    self.class.new(@magnitude / other.to_f)
	  end

	  def <=>(other)
	    other = ensure_compatible(other)
	    other.is_a?(self.class) && magnitude <=> other.to_f
	  end

	  def ensure_compatible(other)
	  	if other.is_a?(self.class)
	  		other
	  	elsif other.respond_to?(:conver_to)
	  		other.convert_to(self.class)
	  	else
	  		fail TypeError
	  	end
	  end

	  def convert_to(target_type)
	  	ratio = ConversionRatio.find(self.class, target_type) or 
	  	   fail TypeError, "Can't convert #{self.class} to #{target_type}"
	  	target_type.new(magnitude * ratio.number)
	  end

	  def hash
	    [magnitude, self.class].hash
	  end

	  def coerce(other)
	    unless other.is_a?(Numeric)
	      fail TypeError, "Can't coerce #{other}" 
	    end
	    [CoercedNumber.new(other), self]
	  end

	  alias_method :eql?, :==
	end

	ConversionRatio = Struct.new(:from, :to, :number) do
		def self.registry
			@registry ||=[]
		end

		def self.find(from, to)
			registry.detect{|ratio| ratio.from == from && rato.to == to}
		end
	end

	# ConversionRatio.registry <<
	# 	ConversionRatio.new(Foot, Meter, 0.3048) <<
	# 	ConversionRatio.new(Meter, Foot, 3.2804)

	class Tablespoon < Quantity
		def aliases
			%w{tbsp tablespoon tablespoons}
		end

		#check if conversion is available otherwise defer to super
		def ensure_compatible(other)
			if other.respond_to?(:to_tablespoon)
				other.to_tablespoon
			else
				super
			end
		end
	end

	class Teaspoon < Quantity
	end

	class FluidOunce < Quantity
	end

	class Cup < Quantity
	end

	class Pint < Quantity
	end

	class Quart < Quantity
	end

	class Gallon < Quantity
	end

	class Milliliter < Quantity
	end

	class Liter < Quantity
	end

	class Pound < Quantity
	end

	class Ounce < Quantity
	end

	class Milligram < Quantity
	end

	class Gram < Quantity
	end

	class Kilogram < Quantity
	end

	class Inch < Quantity
	end

	class Foot < Quantity
	end

	class Millimeter < Quantity
	end

	class Centimeter < Quantity
	end

	class Meter < Quantity
	end

	class Can < Quantity
	end
end


