package com.croco2d.screens
{
	import com.croco2d.AppConfig;
	import com.croco2d.assets.CrocoAssetsManager;
	
	import flash.filesystem.File;
	
	import feathers.controls.ScreenNavigatorItem;

	public class PreloadHubScreen extends CrocoScreen
	{
		protected var targeScreenAssetsManager:CrocoAssetsManager;
		
		public function PreloadHubScreen()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			//just clear the reference.
			targeScreenAssetsManager = null;
		}
		
		override protected function initialize():void
		{
			if(checkIsNeedTargetScreenAssetsPreload())
			{
				onTargetScreenAssetsPreloadInit();
			}
			else// here is no assets to load just go.
			{
				jump2OwnerScreen();
			}
		}
		
		protected function checkIsNeedTargetScreenAssetsPreload():Boolean
		{
			var targetScreenPreLoadAssetsFilePath:String = AppConfig.findScreenPath(ownerScreenID);
			var targetScreenPreLoadAssetsFile:File = File.applicationDirectory.resolvePath(targetScreenPreLoadAssetsFilePath);
			
			return targetScreenPreLoadAssetsFile.exists;
		}
		
		protected function onTargetScreenAssetsPreloadInit():void
		{
			targeScreenAssetsManager = new CrocoAssetsManager();
			
			onTargetScreenAssetsQueueInit();
			onTargetScreenAssetsPreloadStart();
		}
		
		protected function onTargetScreenAssetsQueueInit():void
		{
			var targetScreenPreLoadAssetsFilePath:String = AppConfig.findScreenPath(ownerScreenID);
			var targetScreenPreLoadAssetsFile:File = File.applicationDirectory.resolvePath(targetScreenPreLoadAssetsFilePath);
			
			targeScreenAssetsManager.enqueue(targetScreenPreLoadAssetsFile);
		}
		
		protected function onTargetScreenAssetsPreloadStart():void
		{
			targeScreenAssetsManager.loadQueue(onTargetScreenAssetsPreloadProgress);
		}
		
		protected function onTargetScreenAssetsPreloadProgress(progress:Number):void
		{
			if(progress == 1)
			{
				onTargetScreenAssetsPreloadComplete();
			}
		}
		
		protected function onTargetScreenAssetsPreloadComplete():void
		{
			var targetScreenItem:ScreenNavigatorItem = getScreenNavigatorItem(ownerScreenID);
			
			targetScreenItem.properties[AppConfig.KEY_SCREEN_ASSET_MANAGER] = targeScreenAssetsManager;
			targeScreenAssetsManager = null;
		
			jump2OwnerScreen();
		}
	}
}