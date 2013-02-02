class TaskList

  @list = [
    {id:1,  title:'Rake leaves',     assigned_to:'me' },
    {id:2,  title:'Do laundry',      assigned_to:nil},
    {id:3,  title:'Party shopping',  assigned_to:'them'},
    {id:4,  title:'Hang shelves',    assigned_to:'them'},
    {id:5,  title:'Cook dinner',     assigned_to:'me'},
    {id:6,  title:'Make sangria',    assigned_to:'me'},
    {id:7,  title:'Cut veggies',     assigned_to:nil},
    {id:8,  title:'Skewer veggies',  assigned_to:nil},
    {id:9,  title:'Grill veggies',   assigned_to:'me'},
    {id:10, title:'Sleep',           assigned_to:nil},
    {id:11, title:'Party!',          assigned_to:'them'}
  ]

	def self.get_task_list
    @list
  end

  def self.get_task_at_index(index)
    @list[index]
  end

  def self.delete_task(task_to_delete)
    @list = @list.select {|task| true unless task[:id] == task_to_delete[:id]}
  end
end