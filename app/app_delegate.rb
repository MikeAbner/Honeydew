class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    UIApplication.sharedApplication.setStatusBarHidden(true, animated:false)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  
  	@list = ListViewController.alloc
  	@list.wantsFullScreenLayout = true

    @window.rootViewController = @list

    @window.makeKeyAndVisible

    true
  end
end
