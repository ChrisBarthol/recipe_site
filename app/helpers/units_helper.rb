module UnitsHelper

		def self.conversion(q1,q2,u1,u2)
		volume = ['tsp','tbsp','floz','cup','pint','quart','gallon','mL','L','dL']
		mass = ['lb','oz','mg','g','kg']
		length = ['inch','foot','mm','cm','m']

		if volume.include?(u1)
			if volume.include?(u2)
				combine = volume_conversion(u1,q1)+volume_conversion(u2,q2)
				return combine
			elsif mass.include?(u2)
				combine = volume_conversion(u1,q1)+mass_to_volume(u2,q2)
				return combine
			else
				return "add new entry"
			end
		elsif mass.include?(u1)
			if mass.include?(u2)
				return mass(u1,q1)+mass(u2,q2)
			elsif volume.include?(u2)
				return volume_conversion(u2,q2)+mass_to_volume(u1,q1)
			else
				return "add new entry"
			end
		elsif length.include?(u1)
			if length.include?(u2)
				return length(u1,q1)+length(u2,q2)
			else
				return "add new entry"
			end
		else
			return nil
		end
	end


	def self.volume_conversion(unit,quantity)
		case unit
		when 'tsp'
			return quantity
		when 'tbsp'
			#1tbsp = 3tsp
			q=quantity*3
			return q
		when 'floz'
			#1floz=2tbsp || 1floz = 6tsp
			q=quantity *6
			return q
		when 'cup'
			#1cup = 16tbsp || 1cup = 3*16
			q=quantity*16*3
			return q
		when 'pint'
			#1pint = 2cups || 1 pint = 2*16*3
			q=quantity*2*16*3
			return q
		when 'quart'
			#1quart = 2pints  || 1 quart = 2*2*16*3
			q=quantity *2*2*16*3
			return q
		when 'gallon'
			#1gallon = 4quarts || 1gallon = 4*2*2*16*3
			q=quantity *4*2*2*16*3
			return q
		when 'mL'
			#1ml = .202884 tsp
			q=quantity*0.202884
		when 'L'
			#1L = 202.884 tsp
			q=quantity*202.884
		when 'dL'
			#1dL = 20.2884 tsp
			q=quantity*20.2884
		else
			return "#{unit} is not a volume"
		end
			
	end

	def self.mass(unit,quantity)
		case unit
		when 'lb'
			#1lb = 16oz
			q=quantity*16
			return q
		when 'oz'
			return quantity
		when 'mg'
			q=quantity*0.00035274
			return q
		when 'g' 
			#1g = 0.035274 oz
			q= quantity*0.035274
			return q
		when 'kg'
			#1kg = 35.274 oz
			q=quantity*35.274
			return q
		else
			return "#{unit} is not a mass"
		end
			
	end

	def self.length(unit,quantity)
		case unit
		when 'inch'
			return quantity
		when 'foot'
			#1foot = 12inches
			q=quantity*12
			return q
		when 'mm'
			#1mm = 0.0393701 inches
			q=quantity*0.0393701
			return q
		when 'cm'
			#1cm = 0.393701 inches
			q=quantity*0.393701
			return q
		when 'm'  
			#m = 39.3701 inches
			q=quantity*39.3701
			return q
		else
			return "#{unit} is not a length"
		end
	end

	def self.mass_to_volume(unit,quantity)
		amount = mass(unit,quantity)
		return amount*6 #oz-->floz--->tsp
	end
end