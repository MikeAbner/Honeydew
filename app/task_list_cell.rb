class TaskListCell < UITableViewCell

  attr_accessor :task

  def initWithStyle(style, reuse_identifier)
    super(style, reuseIdentifier:reuse_identifier)
  end

  def configure_cell(parent, task)
    @parent, @task = parent, task

    create_color_bar
    create_task_name
    create_trigger
  end

  def didPressTriggerButton
    @parent.didActivateMenuForCell(self)
  end

private

  def create_color_bar
    @color_bar = UIImageView.alloc.init
    @color_bar.frame = [[0, 0], [10, self.frame.size.height]]
    image_name = Group.color_for(@task[:assigned_to])
    @color_bar.setImage(UIImage.imageNamed("#{image_name}_indicator")) unless image_name == "clear"

    self.contentView.addSubview(@color_bar)
  end

  def create_task_name
    @task_name = UILabel.alloc.init
    @task_name.frame = [[20, 11], [240, 22]]
    @task_name.setFont(UIFont.fontWithName("Futura-Medium", size:16))
    @task_name.text = @task[:title]
    #@task_name.backgroundColor = UIColor.purpleColor

    self.contentView.addSubview(@task_name)
  end

  def create_trigger
    @trigger = UIButton.buttonWithType(UIButtonTypeCustom)
    @trigger.frame = [[280, 7], [30, 30]]
    @trigger.setImage(UIImage.imageNamed("city_find_me"), forState:UIControlStateNormal)
    @trigger.setImage(UIImage.imageNamed("city_find_me_down"), forState:UIControlStateHighlighted)
    @trigger.addTarget(self, action:"didPressTriggerButton", forControlEvents:UIControlEventTouchUpInside)

    self.contentView.addSubview(@trigger)
  end

end