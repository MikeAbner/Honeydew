class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    UIApplication.sharedApplication.setStatusBarHidden(true, animated:false)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  
  	@task_list = TaskListViewController.alloc
  	@task_list.wantsFullScreenLayout = true

    @window.rootViewController = @task_list

    @window.makeKeyAndVisible

    true
  end
end
