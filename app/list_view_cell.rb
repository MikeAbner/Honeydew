class ListViewCell < UITableViewCell

  def initWithStyle(style, reuse_identifier)
    super(style, reuseIdentifier:reuse_identifier)
  end

  def configure_cell(parent, item)
    @parent = parent
    @item = item

    @color_bar = UIView.alloc.init
    @color_bar.frame = [[0, 0], [10, self.frame.size.height]]
    @color_bar.backgroundColor = [UIColor.greenColor, UIColor.blueColor].sample

    @item_name = UILabel.alloc.init
    @item_name.frame = [[20, 11], [240, 22]]
    @item_name.setFont(UIFont.fontWithName("Futura-Medium", size:14))
    @item_name.text = item[:title]
    @item_name.backgroundColor = UIColor.purpleColor

    @trigger = UIButton.buttonWithType(UIButtonTypeCustom)
    @trigger.frame = [[280, 7], [30, 30]]
    @trigger.setImage(UIImage.imageNamed("city_find_me"), forState:UIControlStateNormal)
    @trigger.setImage(UIImage.imageNamed("city_find_me_down"), forState:UIControlStateHighlighted)

    # @trigger.backgroundColor = UIColor.blackColor
    # @long_press = UILongPressGestureRecognizer.alloc.initWithTarget(self, action:"handleLongPressGesture")
    # @long_press.minimumPressDuration = 0.35
    # @trigger.addGestureRecognizer(@long_press)


    self.contentView.addSubview(@color_bar)
    self.contentView.addSubview(@item_name)
    self.contentView.addSubview(@trigger)
  end

  def handleLongPressGesture
    if (@long_press.state == UIGestureRecognizerStateBegan)
      #@parent.didActivateMenuForCell(self)
      @expandingSelect = KLExpandingSelect.alloc.initWithDelegate(self, dataSource:self)

      self.contentView.setExpandingSelect(@expandingSelect)
      self.contentView.addSubview(@expandingSelect)
    end
  end

  # KLEXPANDINGSELECT DELEGATE
  def expandingSelector(expandingSelect, numberOfRowsInSection:section)
    puts "num petals"
    3
  end

  def expandingSelector(expandingSelect, itemForRowAtIndexPath:indexPath)
    puts "item for petal"
    petal = KLExpandingPetal.alloc.initWithImage(UIImage.imageNamed:"gear");
  end

end