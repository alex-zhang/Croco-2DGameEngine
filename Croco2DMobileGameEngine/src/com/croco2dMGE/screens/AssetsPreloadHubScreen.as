package com.croco2dMGE.screens
{
	import com.croco2dMGE.AppConfig;
	import com.croco2dMGE.utils.assets.CrocoAssetsManager;
	
	import flash.filesystem.File;

	public class AssetsPreloadHubScreen extends CrocoHubScreen
	{
		protected var mTargetSceenPreLoadAssetsManager:CrocoAssetsManager;
		
		public function AssetsPreloadHubScreen()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			//just clear the reference.
			mTargetSceenPreLoadAssetsManager = null;
		}
		
		override protected function initialize():void
		{
			if(checkIsNeedTargetScreenAssetsPreload())
			{
				onTargetScreenAssetsPreloadInit();
			}
			else// here is no assets to load just go.
			{
				jumToTargetScreen();
			}
		}
		
		protected function checkIsNeedTargetScreenAssetsPreload():Boolean
		{
			var targetScreenPreLoadAssetsFilePath:String = AppConfig.findScreensPathResource(getJumToTargetScreenID());
			var targetScreenPreLoadAssetsFile:File = File.applicationDirectory.resolvePath(targetScreenPreLoadAssetsFilePath);
			
			return targetScreenPreLoadAssetsFile.exists;
		}
		
		protected function onTargetScreenAssetsPreloadInit():void
		{
			mTargetSceenPreLoadAssetsManager = new CrocoAssetsManager();
			
			onTargetScreenAssetsQueueInit();
			onTargetScreenAssetsPreloadStart();
		}
		
		protected function onTargetScreenAssetsQueueInit():void
		{
			var targetScreenPreLoadAssetsFilePath:String = AppConfig.findScreensPathResource(getJumToTargetScreenID());
			var targetScreenPreLoadAssetsFile:File = File.applicationDirectory.resolvePath(targetScreenPreLoadAssetsFilePath);
			
			mTargetSceenPreLoadAssetsManager.enqueue(targetScreenPreLoadAssetsFile);
		}
		
		protected function onTargetScreenAssetsPreloadStart():void
		{
			mTargetSceenPreLoadAssetsManager.loadQueue(onTargetScreenAssetsPreloadProgress);
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
			var targetScreenItem:CrocoScreenNavigatorItem = getCrocoScreenNavigatorItem(getJumToTargetScreenID());
			
			targetScreenItem.properties[AppConfig.KEY_SCEEN_PRELOAD_ASSETS_MANAGER] = mTargetSceenPreLoadAssetsManager;
			mTargetSceenPreLoadAssetsManager = null;
			
			jumToTargetScreen();
		}
	}
}