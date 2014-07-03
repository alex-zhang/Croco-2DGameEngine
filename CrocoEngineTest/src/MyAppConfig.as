package
{
	import com.croco2d.AppConfig;
	import com.croco2d.screens.PreloadHubScreen;
	
	import feathers.controls.ScreenNavigatorItem;
	
	public class MyAppConfig extends AppConfig
	{
		globalEvnConfig.backgroundColor = 0;//0xffffff;
		
		bootStrapSceenConfig = null;
//		{
//			clsType:"(class)com.croco2d.screens::FlashBootStrapScreen",
//			
//			props:
//			{
//				launchImage:"launchImage.jpg",
//				fadeoutTime:2
//			}
//		}
			
		screensConfig = 
		[
			{
				clsType:ScreenNavigatorItem,
				ctorParams:
				[
					CrocoScreen1,
					"(null)",
					{
						screenID:"DefaultScreen"
					}
				]
			}
		];
		
		public function MyAppConfig()
		{
			super();
		}
	}
}