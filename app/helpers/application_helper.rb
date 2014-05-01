module ApplicationHelper

	def body_class
		@body_class || ''
	end

	def sortable(column, title=nil)
		title ||= column.titleize
		css_class = (column == sort_column) ? "current #{sort_direction}" : nil
		direction = (column ==sort_column && sort_direction=="asc") ? "desc" : "asc"
		link_to title, :sort => column, :direction => direction
	end

	#Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "Use Your Foodle"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	def link_to_remove_fields(name, f)
		f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this")
	end



	def link_to_add_fields(name, f, association)
    	new_object = f.object.send(association).klass.new
    	id = new_object.object_id
    	fields = f.fields_for(association, new_object, child_index: id) do |builder|
      		render(association.to_s.singularize + "_fields", f: builder)
    	end
    	link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  	end

end
