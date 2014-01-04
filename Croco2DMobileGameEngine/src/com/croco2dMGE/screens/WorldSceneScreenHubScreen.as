package com.croco2dMGE.screens
{
	import com.croco2dMGE.AppConfig;
	
	import flash.filesystem.File;

	public class WorldSceneScreenHubScreen extends AssetsPreloadHubScreen
	{
		public function WorldSceneScreenHubScreen()
		{
			super();
		}
		
		public function getJumToTargetScreenSceneID():String
		{
			var targetScreenData:Object = getJumToTargetScreenData();
			return targetScreenData[AppConfig.KEY_SCENE_ID];
		}
		
		override protected function checkIsNeedTargetScreenAssetsPreload():Boolean
		{
			var targetScenePreLoadAssetsFilePath:String = AppConfig.findScenesPathResource(getJumToTargetScreenSceneID());
			var targetScenePreLoadAssetsFile:File = File.applicationDirectory.resolvePath(targetScenePreLoadAssetsFilePath);
			
			return targetScenePreLoadAssetsFile.exists || super.checkIsNeedTargetScreenAssetsPreload();
		}
		
		override protected function onTargetScreenAssetsQueueInit():void
		{
			super.onTargetScreenAssetsQueueInit();
			
			var targetScenePreLoadAssetsFilePath:String = AppConfig.findScenesPathResource(getJumToTargetScreenSceneID());
			var targetScenePreLoadAssetsFile:File = File.applicationDirectory.resolvePath(targetScenePreLoadAssetsFilePath);
			
			mTargetSceenPreLoadAssetsManager.enqueue(targetScenePreLoadAssetsFile);
		}
	}
}