package com.croco2dMGE.graphics.screens
{
	import com.croco2dMGE.bootStrap.CrocoBootStrapConfig;
	import com.croco2dMGE.utils.CrocoAssetsManager;
	
	import feathers.controls.Screen;
	
	public class CrocoScreen extends Screen
	{
		//assetManager object is create in the hub screen and pass to this instance.
		public var sceenPreLoadAssetsManager:CrocoAssetsManager;
		
		public function CrocoScreen()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(sceenPreLoadAssetsManager)
			{
				//deleet from the ScreenItem property
				delete getSlefCrocoScreenNavigatorItem().properties[CrocoBootStrapConfig.KEY_SCEEN_PRELOAD_ASSETS_MANAGER];
				
				sceenPreLoadAssetsManager.dispose();
				
				sceenPreLoadAssetsManager = null;
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