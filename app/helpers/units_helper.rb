module UnitsHelper

	def unit(amount, unit)

	end

	def volume
		case unit
		when tsp
			put something
		when tbsp
			put something
		when floz
			put something
		when cup
			put something
		when pint
			put something
		when quart
			put something
		when gallon
			put something
		when mL 
			put something
		when L 
			put something
		when dL 
			put something
		else
			put "#{unit} is not a volume"
		end
			
	end

	def mass
		case unit
		when lb
			put something
		when oz
			put something
		when mg
			put something
		when g 
			put something
		when kg
			put something
		else
			put "#{unit} is not a mass"
		end
			
	end

	def length
		case unit
		when inch
			put something
		when foot
			put something
		when mm
			put something
		when cm
			put something
		when m  
			put something
		else
			put "#{unit} is not a length"
		end
	end

	def conversion
		a="1 tbsp = 3tsp"
		b="1cup = 16 tbsp"
		c="1 pint = 2 cups"
		d="1 quart = 2 pints"
		e="1 gallon = 4 quarts"
		f="1 cup = 8 floz"
		g="1floz = 2tbsp"
	end


end