class List

  @list = [
    {:title => "Rake leaves"},
    {:title => "Do laundry"},
    {:title => "Party shopping"},
    {:title => "Hang shelves"},
    {:title => "Cook dinner"},
    {:title => 'Make sangria'},
    {:title => 'Cut veggies'},
    {:title => 'Skewer veggies'},
    {:title => 'Grill veggies'},
    {:title => 'Sleep'},
    {:title => 'Party!'}
  ]

	def self.get_list
    @list
  end

  def self.get_item_at_index(index)
    @list[index]
  end
end