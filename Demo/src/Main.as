package
{
	import com.croco2d.AppBootStrap;
	
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	
	public class Main extends AppBootStrap
	{
		public function Main()
		{
			super();
			
			MyAppConfig;
		}
		
		override protected function onAppInit():void
		{
			new ScreenSlidingStackTransitionManager(__screenNavigator);
		}
	}
}