class ListViewController < UIViewController

  # VIEW CONTROLLER LIFECYCLE
	def viewDidLoad
    super
		puts "list view did load"

		draw_interface
	end

  def viewDidUnload
    puts "list view did unload"
    super
  end

  # TABLE VIEW DATA SOURCE
  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    List.get_list.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @cellId = "cell"

    cell = tableView.dequeueReusableCellWithIdentifier(@cellId) || begin
      ListViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@cellId)
    end
  
    cell.configure_cell(self, List.get_item_at_index(indexPath.row))

    cell
  end

  # TABLE VIEW DELEGATE

  # ACTIONS
  def didPressAddButton
    puts "pressed the add button"
    add_controller = AddController.alloc.init
    self.presentViewController(add_controller, animated:true, completion:nil)
  end

  def didPressSettingsButton
    puts "pressed the settings button"
  end

  def didActivateMenuForCell(cell)
    @index_path = @table_view.indexPathForCell(cell)
    show_menu(cell.frame.origin.y)
  end

private

  def draw_interface
    draw_header
    draw_footer
    draw_table  #do this last so we can use the frames of the header/footer in the size calcs
  end

  def draw_header
    @header = UIView.alloc.init
    @header.frame = [[0, 0], [320, 35]]
    @header.backgroundColor = UIColor.whiteColor

    @title = UILabel.alloc.init
    @title.frame = [[10, 0], [100, 35]]
    @title.font = UIFont.fontWithName("Futura-Medium", size:14)
    @title.text = "Honeydew"

    @add_btn = UIButton.buttonWithType(UIButtonTypeContactAdd)
    @add_btn.frame = [[250, 5], [@add_btn.frame.size.width, @add_btn.frame.size.height]]
    @add_btn.addTarget(self, action:"didPressAddButton", forControlEvents:UIControlEventTouchUpInside)

    @settings_btn = UIButton.buttonWithType(UIButtonTypeContactAdd)
    @settings_btn.frame = [[280, 5], [@settings_btn.frame.size.width, @settings_btn.frame.size.height]]
    @settings_btn.addTarget(self, action:"didPressSettingsButton", forControlEvents:UIControlEventTouchUpInside)

    @header.addSubview(@title)
    @header.addSubview(@add_btn)
    @header.addSubview(@settings_btn)
    self.view.addSubview(@header)
  end

  def draw_table
    @table_view = UITableView.alloc.init
    @table_view.frame = [[0, @header.frame.size.height], [320, UIScreen.mainScreen.applicationFrame.size.height-50-@header.frame.size.height]]

    @table_view.delegate    = self
    @table_view.dataSource  = self

    @table_view.allowsSelection = false
    @table_view.separatorStyle = UITableViewCellSeparatorStyleNone
    self.view.addSubview(@table_view)
  end

  def draw_footer
    @footer = UIView.alloc.init
    @footer.frame = [[0, UIScreen.mainScreen.applicationFrame.size.height-50], [320, 50]]
    @footer.backgroundColor = UIColor.blueColor
    self.view.addSubview(@footer)
  end

  def show_menu(y_origin)
    @menu = UIView.alloc.init unless @menu

    start_x = 290
    x_origin = 100

    @menu.frame = [[start_x, y_origin+22], [0, 0]]

    UIView.animateWithDuration(0.35, animations:lambda { @menu.frame = [[x_origin, y_origin+22], [200, 200]] })

    @menu.backgroundColor = UIColor.greenColor;

    self.view.addSubview(@menu)
  end

end