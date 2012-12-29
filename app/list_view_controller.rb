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
    #add_controller = AddController.alloc.init
    #self.presentViewController(add_controller, animated:true, completion:nil)
  end

  def didPressSettingsButton
    puts "pressed the settings button"
  end

  def didActivateMenuForCell(cell)
    slider_height           = UIScreen.mainScreen.applicationFrame.size.height
    top_slider_origin_y     = -slider_height
    bottom_slider_origin_y  = slider_height

    if @sliders_shown
      UIView.animateWithDuration(0.35, animations:lambda { 
        @top_slider.frame     = [[0, top_slider_origin_y],    [320, slider_height]]
        @bottom_slider.frame  = [[0, bottom_slider_origin_y], [320, slider_height]]
      })
    else
      if !@top_slider
        @top_slider         = UIView.alloc.init
        @top_slider.frame   = [[0, top_slider_origin_y], [320, slider_height]]
        @top_slider.opaque  = false
        @top_slider.alpha   = 0.90
        @top_slider.backgroundColor = UIColor.blackColor

        @bottom_slider        = UIView.alloc.init
        @bottom_slider.frame  = [[0, bottom_slider_origin_y], [320, slider_height]]
        @bottom_slider.opaque = false
        @bottom_slider.alpha  = 0.90
        @bottom_slider.backgroundColor = UIColor.blackColor

        self.view.addSubview(@top_slider)
        self.view.addSubview(@bottom_slider)
      end

      top_slider_offset       = @table_view.frame.origin.y + cell.frame.origin.y - @table_view.contentOffset.y
      top_slider_origin_y_new = top_slider_origin_y + top_slider_offset

      bottom_slider_offset        = @table_view.frame.origin.y + cell.frame.origin.y + cell.frame.size.height - @table_view.contentOffset.y

      UIView.animateWithDuration(0.35, animations:lambda { 
        @top_slider.frame     = [[0, top_slider_origin_y_new], [320, slider_height]] 
        @bottom_slider.frame  = [[0, bottom_slider_offset], [320, slider_height]]
      })
    end
    @sliders_shown = !@sliders_shown
  end

  def didPressMenuCancelBtn
    @menu_bg.hidden = true
    @menu.hidden    = true
  end

private

  def draw_interface
    draw_header
    draw_footer
    draw_table  #do this last so we can use the frames of the header/footer in the size calcs
  end

  def draw_header
    @header           = UIView.alloc.init
    @header.frame     = [[0, 0], [320, 44]]
    @header_bg        = UIImageView.alloc.initWithImage(UIImage.imageNamed("header-bg"))
    @header_bg.frame  = @header.frame
    @header.addSubview(@header_bg)

    @title        = UILabel.alloc.init
    @title.frame  = [[110, 6], [100, 35]]
    @title.font   = UIFont.fontWithName("Futura-CondensedExtraBold", size:20)
    @title.text   = "Honeydew"
    @title.backgroundColor = UIColor.clearColor

    @add_btn       = UIButton.buttonWithType(UIButtonTypeCustom)
    @add_btn.frame = [[280, 8], [30, 30]]
    @add_btn.setImage(UIImage.imageNamed("simple_plus"), forState:UIControlStateNormal)
    @add_btn.setImage(UIImage.imageNamed("simple_plus_down"), forState:UIControlStateHighlighted)
    @add_btn.addTarget(self, action:"didPressAddButton", forControlEvents:UIControlEventTouchUpInside)

    @settings_btn       = UIButton.buttonWithType(UIButtonTypeCustom)
    @settings_btn.frame = [[10, 8], [30, 30]]
    @settings_btn.setImage(UIImage.imageNamed("simple_minus"), forState:UIControlStateNormal)
    @settings_btn.setImage(UIImage.imageNamed("simple_minus_down"), forState:UIControlStateHighlighted)
    @settings_btn.addTarget(self, action:"didPressSettingsButton", forControlEvents:UIControlEventTouchUpInside)

    @header.addSubview(@title)
    @header.addSubview(@add_btn)
    @header.addSubview(@settings_btn)

    self.view.addSubview(@header)
  end

  def draw_table
    @table_view       = UITableView.alloc.init
    @table_view.frame = [[0, @header.frame.size.height], [320, UIScreen.mainScreen.applicationFrame.size.height-50-@header.frame.size.height]]

    @table_view.delegate    = self
    @table_view.dataSource  = self

    @table_view.allowsSelection = false
    @table_view.separatorStyle  = UITableViewCellSeparatorStyleNone

    self.view.addSubview(@table_view)
  end

  def draw_footer
    @footer       = UIView.alloc.init
    @footer.frame = [[0, UIScreen.mainScreen.applicationFrame.size.height-50], [320, 50]]
    @footer.backgroundColor = UIColor.blueColor

    self.view.addSubview(@footer)
  end

  def show_menu(y_origin)
    @menu_bg        = UIView.alloc.init unless @menu_bg
    @menu_bg.hidden = false
    @menu_bg.frame  = self.view.frame
    @menu_bg.alpha  = 0.85
    @menu_bg.backgroundColor = UIColor.lightGrayColor

    start_x   = 290
    x_origin  = 90
    start_y   = @table_view.frame.origin.y
    y_origin  = @table_view.frame.origin.y + y_origin - @table_view.contentOffset.y
    
    @menu         = UIView.alloc.init unless @menu
    @menu.hidden  = false
    @menu.frame   = [[start_x, start_y], [0, 0]]

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