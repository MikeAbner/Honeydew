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
    puts cell.frame.origin.y
    puts @table_view.contentOffset.y
  end

  def didPressMenuCancelBtn
    @menu_bg.hidden = true
    @menu.hidden = true
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

    @add_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    @add_btn.frame = [[250, 5], [20, 20]]
    @add_btn.setImage(UIImage.imageNamed("plus-sign"), forState:UIControlStateNormal)
    @add_btn.addTarget(self, action:"didPressAddButton", forControlEvents:UIControlEventTouchUpInside)

    @settings_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    @settings_btn.frame = [[280, 5], [20, 20]]
    @settings_btn.setImage(UIImage.imageNamed("gear"), forState:UIControlStateNormal)
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
    @menu_bg = UIView.alloc.init unless @menu_bg
    @menu_bg.hidden = false
    @menu_bg.frame = self.view.frame
    @menu_bg.backgroundColor = UIColor.lightGrayColor
    @menu_bg.alpha = 0.85

    start_x = 290
    x_origin = 90
    start_y = @table_view.frame.origin.y
    y_origin = @table_view.frame.origin.y + y_origin - @table_view.contentOffset.y
    
    @menu = UIView.alloc.init unless @menu
    @menu.hidden = false
    @menu.frame = [[start_x, start_y], [0, 0]]

    UIView.animateWithDuration(0.35, animations:lambda { @menu.frame = [[x_origin, y_origin], [200, 200]] })

    @menu.backgroundColor = UIColor.greenColor;
    @claim_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @claim_btn.frame = [[10, 10], [100, 25]]
    @claim_btn.setTitle("Claim", forState:UIControlStateNormal)

    @assign_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @assign_btn.frame = [[10, 45], [100, 25]]
    @assign_btn.setTitle("Assign", forState:UIControlStateNormal)

    @cancel_btn = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @cancel_btn.frame = [[10, 80], [100, 25]]
    @cancel_btn.setTitle("Cancel", forState:UIControlStateNormal)
    @cancel_btn.addTarget(self, action:"didPressMenuCancelBtn", forControlEvents:UIControlEventTouchUpInside)

    @menu.addSubview(@claim_btn)
    @menu.addSubview(@assign_btn)
    @menu.addSubview(@cancel_btn)


    self.view.addSubview(@menu_bg)
    self.view.addSubview(@menu)
  end

end