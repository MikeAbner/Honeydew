class TaskListCell < UITableViewCell

  attr_accessor :task

  def initWithStyle(style, reuse_identifier)
    super(style, reuseIdentifier:reuse_identifier)
  end

  def configure_cell(parent, task)
    @parent = parent
    @task = task

    @color_bar = UIImageView.alloc.init
    @color_bar.frame = [[0, 0], [10, self.frame.size.height]]
    image_name = ["clear", 
                  "yellow_pastel", "natural_pastel", "orange_pastel", "pink_pastel", "purple_pastel", "blue_pastel", "green_pastel", 
                  "grey_monochrome", "light-grey_monochrome", "mid-grey_monochrome", "dark-grey_monochrome",
                  "purple_dark", "red_dark", "gold_dark", "green_dark", "orange_dark", "pink_dark", "blue_dark",
                  "red_bright", "yellow_bright", "green_bright", "orange_bright", "pink_bright", "purple_bright", "blue_bright"].sample
    @color_bar.setImage(UIImage.imageNamed("#{image_name}_indicator")) unless image_name == "clear"

    @task_name = UILabel.alloc.init
    @task_name.frame = [[20, 11], [240, 22]]
    @task_name.setFont(UIFont.fontWithName("Futura-Medium", size:16))
    @task_name.text = @task[:title]
    #@task_name.backgroundColor = UIColor.purpleColor

    @trigger = UIButton.buttonWithType(UIButtonTypeCustom)
    @trigger.frame = [[280, 7], [30, 30]]
    @trigger.setImage(UIImage.imageNamed("city_find_me"), forState:UIControlStateNormal)
    @trigger.setImage(UIImage.imageNamed("city_find_me_down"), forState:UIControlStateHighlighted)
    @trigger.addTarget(self, action:"didPressActionTrigger", forControlEvents:UIControlEventTouchUpInside)

    self.contentView.addSubview(@color_bar)
    self.contentView.addSubview(@task_name)
    self.contentView.addSubview(@trigger)
  end

  def didPressActionTrigger
    @parent.didActivateMenuForCell(self)
  end

end