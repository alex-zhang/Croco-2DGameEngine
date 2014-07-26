package
{
	import com.croco2d.AppBootStrap;
	
	[SWF(width="1024", height="600")]
	public class BasicSimulation extends AppBootStrap
	{
		public function BasicSimulation()
		{
			super();
		}
	}
}

import com.croco2d.AppConfig;

import feathers.controls.ScreenNavigatorItem;

class BasicSimulationAppConfig extends AppConfig
{
	screensConfig = 
		[
			{
				clsType:ScreenNavigatorItem,
				
				ctorParams:
				[
					MainScreen,
					null,
					{
						screenID:"MainScreen"
					}
				]
			}
		];
}