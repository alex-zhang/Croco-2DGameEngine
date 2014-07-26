package
{
	import com.croco2d.AppBootStrap;
	import com.croco2d.AppConfig;
	import com.croco2d.CrocoEngine;
	
	[SWF(width="1024", height="600")]
	public class Basic extends AppBootStrap
	{
		public function Basic()
		{
			super();
			
			CrocoEngine.debug = true;
			
			AppConfig.screensConfig = 
			[
				{
					clsType:"(class)feathers.controls::ScreenNavigatorItem",
					
					ctorParams:
					[
						MainScreen,
						"(null)",
						{
							screenID:"MainScreen",
							hubScreenID:"PreloadHubScreen"
						}
					]
				},
				
				//hub screens
				{
					clsType:"(class)feathers.controls::ScreenNavigatorItem",
					
					ctorParams:
					[
						"(class)com.croco2d.screens::PreloadHubScreen",
						"(null)",
						{
							screenID:"PreloadHubScreen"
						}
					]
				}
			]
		}
	}
}