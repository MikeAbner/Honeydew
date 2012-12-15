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
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@cellId)
    end

    cell.textLabel.text = List.get_item_at_index(indexPath.row)[:title]
    cell.textLabel.setFont(UIFont.fontWithName("Futura-Medium", size:14))
    cell
  end

  # TABLE VIEW DELEGATE

  # ACTIONS
  def didPressAddButton
    puts "pressed the add button"
  end

  def didPressSettingsButton
    puts "pressed the settings button"
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

end