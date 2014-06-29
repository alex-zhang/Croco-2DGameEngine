package com.croco2d.screens
{
	import com.croco2d.assets.CrocoAssetsManager;
	
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigatorItem;
	
	public class CrocoScreen extends Screen
	{
		//assetsManager object is create in the hub screen and pass to this instance.
		public var assetsManager:CrocoAssetsManager;
		public var hubScreenID:String;
		public var ownerScreenID:String;
		
		public function CrocoScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			if(!assetsManager)
			{
				assetsManager = new CrocoAssetsManager();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(assetsManager)
			{
				assetsManager.dispose();
				assetsManager = null;
			}
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
		
		protected function jump2OwnerScreen():void
		{
			owner.showScreen(ownerScreenID);
		}
	}
}