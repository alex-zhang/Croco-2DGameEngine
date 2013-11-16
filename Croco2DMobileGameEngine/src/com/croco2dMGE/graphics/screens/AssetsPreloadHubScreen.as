package com.croco2dMGE.graphics.screens
{
	import com.croco2dMGE.bootStrap.CrocoBootStrapConfig;
	import com.croco2dMGE.utils.CrocoAssetsManager;
	
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
			var targetScreenPreLoadAssetsFile:File = File.applicationDirectory.resolvePath(CrocoBootStrapConfig.ASSETS_SCREENS_DIR_PATH + 
					getJumToTargetScreenID());
			
			return targetScreenPreLoadAssetsFile.exists;
		}
		
		protected function onTargetScreenAssetsPreloadInit():void
		{
			var targetScreenPreLoadAssetsFile:File = File.applicationDirectory.resolvePath(CrocoBootStrapConfig.ASSETS_SCREENS_DIR_PATH  + 
				getJumToTargetScreenID());
			
			mTargetSceenPreLoadAssetsManager = new CrocoAssetsManager();
			mTargetSceenPreLoadAssetsManager.enqueue(targetScreenPreLoadAssetsFile);
			
			onTargetScreenAssetsPreloadStart();
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
			
			targetScreenItem.properties[CrocoBootStrapConfig.KEY_SCEEN_PRELOAD_ASSETS_MANAGER] = mTargetSceenPreLoadAssetsManager;
			mTargetSceenPreLoadAssetsManager = null;
			
			jumToTargetScreen();
		}
	}
}