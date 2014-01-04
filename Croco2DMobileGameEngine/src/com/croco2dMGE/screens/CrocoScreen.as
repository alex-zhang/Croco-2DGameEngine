package com.croco2dMGE.screens
{
	import com.croco2dMGE.AppConfig;
	import com.croco2dMGE.utils.assets.CrocoAssetsManager;
	
	import feathers.controls.Screen;
	
	public class CrocoScreen extends Screen
	{
		//assetManager object is create in the hub screen and pass to this instance.
		public var screenPreLoadAssetsManager:CrocoAssetsManager;
		
		public function CrocoScreen()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(screenPreLoadAssetsManager)
			{
				//deleet from the ScreenItem property
				delete getSlefCrocoScreenNavigatorItem().properties[AppConfig.KEY_SCEEN_PRELOAD_ASSETS_MANAGER];
				
				screenPreLoadAssetsManager.dispose();
				
				screenPreLoadAssetsManager = null;
			}
		}
		
		//help
		public function getSlefCrocoScreenNavigatorItem():CrocoScreenNavigatorItem
		{
			return CrocoScreenNavigator(owner).getCrocoScreenNavigatorItem(screenID);
		}

		public function getCrocoScreenNavigatorItem(screenID:String):CrocoScreenNavigatorItem
		{
			return CrocoScreenNavigator(owner).getCrocoScreenNavigatorItem(screenID);
		}
	}
}