class TaskListViewController < UIViewController

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
    TaskList.get_task_list.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @cellId = "cell"

    cell = tableView.dequeueReusableCellWithIdentifier(@cellId) || begin
      TaskListCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@cellId)
    end
  
    cell.configure_cell(self, TaskList.get_task_at_index(indexPath.row))

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
    @active_cell = cell
    scroll_cell_fully_into_view
    slide_in_shades
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

  def scroll_cell_fully_into_view
    #scroll the cell completely into view if it is partially behind the header
    #TODO: SCROLL CELL INTO VIEW IF IT IS BEHIND THE FOOTER
    if @active_cell.frame.origin.y - @table_view.contentOffset.y < 0
      @table_view.scrollToRowAtIndexPath(@table_view.indexPathForCell(@active_cell), atScrollPosition:UITableViewScrollPositionTop, animated:true)
    end
  end

  def slide_in_shades
    #slide in the shades from the top and bottom
    slider_height           = UIScreen.mainScreen.applicationFrame.size.height
    top_slider_origin_y     = -slider_height
    bottom_slider_origin_y  = slider_height

    if @sliders_shown
      hide_menu(@top_slider.frame.origin.y + slider_height)

      UIView.animateWithDuration(0.35, animations:lambda { 
        @top_slider.frame     = [[0, top_slider_origin_y],    [320, slider_height]]
        @bottom_slider.frame  = [[0, bottom_slider_origin_y], [320, slider_height]]
      })

      @table_view.scrollEnabled = true
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

      top_slider_offset = @table_view.frame.origin.y + @active_cell.frame.origin.y - @table_view.contentOffset.y

      #if the offset is smaller than the header or the cell is being scrolled on screen
      if top_slider_offset < @header.size.height || @active_cell.frame.origin.y - @table_view.contentOffset.y < 0
        top_slider_offset = @header.size.height
      end

      top_slider_origin_y_new = top_slider_origin_y + top_slider_offset

      bottom_slider_offset = @table_view.frame.origin.y + @active_cell.frame.origin.y + @active_cell.frame.size.height - @table_view.contentOffset.y

      #adjustment needed if the cell started partially offscreen
      if @active_cell.frame.origin.y - @table_view.contentOffset.y < 0
        bottom_slider_offset = @table_view.frame.origin.y + @active_cell.frame.size.height
      end

      UIView.animateWithDuration(0.35, animations:lambda { 
        @top_slider.frame     = [[0, top_slider_origin_y_new], [320, slider_height]] 
        @bottom_slider.frame  = [[0, bottom_slider_offset], [320, slider_height]]
      })

      show_menu(@top_slider.frame.origin.y + @top_slider.frame.size.height)

      @table_view.scrollEnabled = false
    end
    @sliders_shown = !@sliders_shown
  end

  def show_menu(top_of_cell_y)
    y_origin = top_of_cell_y
    start_y = -44
    end_y   = y_origin - 44

    if y_origin - @table_view.contentOffset.y <= 44
      start_y = UIScreen.mainScreen.applicationFrame.size.height
      end_y   = y_origin + 44
    end

    @menu = UIView.alloc.init
    @menu.clipsToBounds = true

    if (@active_cell.task[:assigned_to] == 'me')
      draw_menu_for_owned_cell
    elsif (@active_cell.task[:assigned_to] == 'them')
      draw_menu_for_assigned_cell
    else
      draw_menu_for_unclaimed_cell
    end
    
    @menu.frame = [[0, start_y], [320, 44]]
    @menu.backgroundColor = UIColor.purpleColor

    self.view.addSubview(@menu)

    UIView.animateWithDuration(0.35, animations:lambda {
      @menu.frame = [[0, end_y], [320, 44]]
    })
  end

  def draw_menu_for_owned_cell
    @menu_unclaim_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    @menu_unclaim_btn.setImage(UIImage.imageNamed("minus-sign"), forState:UIControlStateNormal)
    @menu_unclaim_btn.frame = [[10+75, 8], [30, 30]]

    @menu_complete_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    @menu_complete_btn.setImage(UIImage.imageNamed("plus-sign"), forState:UIControlStateNormal)
    @menu_complete_btn.frame = [[50+75, 8], [30, 30]]

    @menu.addSubview(@menu_unclaim_btn)
    @menu.addSubview(@menu_complete_btn)
    draw_edit_and_delete_buttons
  end

  def draw_menu_for_assigned_cell
    @menu_claim_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    @menu_claim_btn.setImage(UIImage.imageNamed("minus-sign"), forState:UIControlStateNormal)
    @menu_claim_btn.frame = [[10+75, 8], [30, 30]]

    @menu.addSubview(@menu_claim_btn)
    draw_edit_and_delete_buttons
  end

  def draw_menu_for_unclaimed_cell
    @menu_claim_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    @menu_claim_btn.setImage(UIImage.imageNamed("minus-sign"), forState:UIControlStateNormal)
    @menu_claim_btn.frame = [[10+75, 8], [30, 30]]

    @menu_assign_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    @menu_assign_btn.setImage(UIImage.imageNamed("plus-sign"), forState:UIControlStateNormal)
    @menu_assign_btn.frame = [[50+75, 8], [30, 30]]

    @menu.addSubview(@menu_claim_btn)
    @menu.addSubview(@menu_assign_btn)
    draw_edit_and_delete_buttons
  end

  def draw_edit_and_delete_buttons
    @menu_edit_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    @menu_edit_btn.setImage(UIImage.imageNamed("gear"), forState:UIControlStateNormal)
    @menu_edit_btn.frame = [[90+75, 8], [30, 30]]

    @menu_delete_btn = UIButton.buttonWithType(UIButtonTypeCustom)
    @menu_delete_btn.setImage(UIImage.imageNamed("unchecked"), forState:UIControlStateNormal)
    @menu_delete_btn.frame = [[130+75, 8], [30, 30]]
    @menu_delete_btn.addTarget(self, action:"didPressDeleteTaskButton", forControlEvents:UIControlEventTouchUpInside)

    @menu.addSubview(@menu_edit_btn)
    @menu.addSubview(@menu_delete_btn)
  end

  def hide_menu(top_of_cell_y)
    y_origin = top_of_cell_y
    start_y = -44
    
    if y_origin - @table_view.contentOffset.y <= 44
      start_y = UIScreen.mainScreen.applicationFrame.size.height
    end

    UIView.animateWithDuration(0.35, animations:lambda {
      @menu.frame = [[0, start_y], [320, 44]]
    })

    @active_cell = nil
  end

  def didPressDeleteTaskButton

  end

end