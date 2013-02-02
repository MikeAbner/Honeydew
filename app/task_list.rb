class TaskList

  @list = [
    {title:'Rake leaves',     assigned_to:'me' },
    {title:'Do laundry',      assigned_to:nil},
    {title:'Party shopping',  assigned_to:'them'},
    {title:'Hang shelves',    assigned_to:'them'},
    {title:'Cook dinner',     assigned_to:'me'},
    {title:'Make sangria',    assigned_to:'me'},
    {title:'Cut veggies',     assigned_to:nil},
    {title:'Skewer veggies',  assigned_to:nil},
    {title:'Grill veggies',   assigned_to:'me'},
    {title:'Sleep',           assigned_to:nil},
    {title:'Party!',          assigned_to:'them'}
  ]

	def self.get_task_list
    @list
  end

  def self.get_task_at_index(index)
    @list[index]
  end
end