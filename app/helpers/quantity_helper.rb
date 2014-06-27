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
	  	fail TypeError unless other.is_a?(self.class)
	  	other
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

		def to_tablespoon
			self
		end

		def to_teaspoon
			Tablespoon.new(to_f*3.0)
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


end