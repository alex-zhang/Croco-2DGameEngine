package com.croco2d.screens
{
	import com.croco2d.AppConfig;
	import com.croco2d.assets.CrocoAssetsManager;
	
	import flash.filesystem.File;
	
	import feathers.controls.ScreenNavigatorItem;

	public class PreloadHubScreen extends HubScreen
	{
		protected var targetSceenPreLoadAssetsManager:CrocoAssetsManager;
		
		public function PreloadHubScreen()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			//just clear the reference.
			targetSceenPreLoadAssetsManager = null;
		}
		
		override protected function initialize():void
		{
			if(checkIsNeedTargetScreenAssetsPreload())
			{
				onTargetScreenAssetsPreloadInit();
			}
			else// here is no assets to load just go.
			{
				jump2TargetScreen();
			}
		}
		
		protected function checkIsNeedTargetScreenAssetsPreload():Boolean
		{
			var targetScreenPreLoadAssetsFilePath:String = AppConfig.findScreensPathResource(jump2TargetScreenId);
			var targetScreenPreLoadAssetsFile:File = File.applicationDirectory.resolvePath(targetScreenPreLoadAssetsFilePath);
			
			return targetScreenPreLoadAssetsFile.exists;
		}
		
		protected function onTargetScreenAssetsPreloadInit():void
		{
			targetSceenPreLoadAssetsManager = new CrocoAssetsManager();
			
			onTargetScreenAssetsQueueInit();
			onTargetScreenAssetsPreloadStart();
		}
		
		protected function onTargetScreenAssetsQueueInit():void
		{
			var targetScreenPreLoadAssetsFilePath:String = AppConfig.findScreensPathResource(jump2TargetScreenId);
			var targetScreenPreLoadAssetsFile:File = File.applicationDirectory.resolvePath(targetScreenPreLoadAssetsFilePath);
			
			targetSceenPreLoadAssetsManager.enqueue(targetScreenPreLoadAssetsFile);
		}
		
		protected function onTargetScreenAssetsPreloadStart():void
		{
			targetSceenPreLoadAssetsManager.loadQueue(onTargetScreenAssetsPreloadProgress);
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
			var targetScreenItem:ScreenNavigatorItem = getScreenNavigatorItem(jump2TargetScreenId);
			
			targetScreenItem.properties[AppConfig.KEY_SCEEN_ASSETS_MANAGER] = targetSceenPreLoadAssetsManager;
			targetSceenPreLoadAssetsManager = null;
		
			jump2TargetScreen();
		}
	}
}