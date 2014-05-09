package com.croco2d.screens
{
	import com.croco2d.AppConfig;
	
	import flash.filesystem.File;

	public class SceneScreenHubScreen extends PreloadHubScreen
	{
		public function SceneScreenHubScreen()
		{
			super();
		}
		
		public function get targetSceneId():String
		{
			var tdata:Object = this.targetScreenEntryData;
			return tdata ?
				tdata[AppConfig.KEY_SCENE_ID] :
				null;
		}
		
		override protected function checkIsNeedTargetScreenAssetsPreload():Boolean
		{
			var targetScenePreLoadAssetsFilePath:String = AppConfig.findScenesPathResource(targetSceneId);
			var targetScenePreLoadAssetsFile:File = File.applicationDirectory.resolvePath(targetScenePreLoadAssetsFilePath);
			
			return targetScenePreLoadAssetsFile.exists || super.checkIsNeedTargetScreenAssetsPreload();
		}
		
		override protected function onTargetScreenAssetsQueueInit():void
		{
			super.onTargetScreenAssetsQueueInit();
			
			var targetScenePreLoadAssetsFilePath:String = AppConfig.findScenesPathResource(targetSceneId);
			var targetScenePreLoadAssetsFile:File = File.applicationDirectory.resolvePath(targetScenePreLoadAssetsFilePath);
			
			targetSceenPreLoadAssetsManager.enqueue(targetScenePreLoadAssetsFile);
		}
	}
}