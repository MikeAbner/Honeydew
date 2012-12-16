class ListViewCell < UITableViewCell

  def initWithStyle(style, reuse_identifier)
    super(style, reuseIdentifier:reuse_identifier)
  end

  def configure_cell(parent, item)
    @parent = parent

    @color_bar = UIView.alloc.init
    @color_bar.frame = [[0, 0], [10, self.frame.size.height]]
    @color_bar.backgroundColor = [UIColor.greenColor, UIColor.blueColor, UIColor.redColor, UIColor.yellowColor].sample

    @item_name = UILabel.alloc.init
    @item_name.frame = [[20, 11], [240, 22]]
    @item_name.setFont(UIFont.fontWithName("Futura-Medium", size:14))
    @item_name.text = item[:title]
    @item_name.backgroundColor = UIColor.purpleColor

    @trigger = UIView.alloc.init
    @trigger.frame = [[270, 2], [40, 40]]
    @trigger.backgroundColor = UIColor.blackColor

    @long_press = UILongPressGestureRecognizer.alloc.initWithTarget(self, action:"handleLongPressGesture")
    @trigger.addGestureRecognizer(@long_press)


    self.contentView.addSubview(@color_bar)
    self.contentView.addSubview(@item_name)
    self.contentView.addSubview(@trigger)
  end

  def handleLongPressGesture
    if (@long_press.state == UIGestureRecognizerStateEnded)
      @parent.didActivateMenuForCell(self)
    end
  end
end