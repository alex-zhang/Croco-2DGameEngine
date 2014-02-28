package com.croco2d.screens
{
	import com.croco2d.AppConfig;
	import com.croco2d.assets.CrocoAssetsManager;
	
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	
	public class CrocoScreen extends Screen
	{
		//assetManager object is create in the hub screen and pass to this instance.
		public var screenAssetsManager:CrocoAssetsManager;
		
		public var entryScreenData:Object;
		
		public function CrocoScreen()
		{
			super();
		}
		
		public function get hubScreenId():String
		{
			return entryScreenData ? 
				entryScreenData[AppConfig.KEY_HUB_SCREEN_ID] : 
				null;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			if(!screenAssetsManager)
			{
				screenAssetsManager = new CrocoAssetsManager();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(screenAssetsManager)
			{
				screenAssetsManager.dispose();
				screenAssetsManager = null;
			}
			
			entryScreenData = null;
		}
		
		//help
		public function getSlefScreenNavigatorItem():ScreenNavigatorItem
		{
			return getScreenNavigatorItem(screenID);
		}

		public function getScreenNavigatorItem(screenId:String):ScreenNavigatorItem
		{
			return owner.getScreen(screenId);
		}
	}
}