package
{
	import com.croco2d.AppBootStrap;
	import com.croco2d.AppConfig;
	
	[SWF(width="1024", height="600")]
	public class PreLoad extends AppBootStrap
	{
		public function PreLoad()
		{
			super();
			
			AppConfig.bootStrapSceenConfig = 
			{
				clsType:PreloadScreen,
				
				props:
				{
					launchImage:null,
					fadeoutTime:50
				}
			}
		}
	}
}