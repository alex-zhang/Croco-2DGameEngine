package com.croco2dMGE.screens
{
	import com.croco2dMGE.AppConfig;
	import com.croco2dMGE.CrocoEngine;
	import com.croco2dMGE.world.CrocoScene;
	
	import starling.events.Event;

	public class CrocoWorldSceneScreen extends CrocoScreen
	{
		//see CrocoBootStrapConfig screen define props.
		public var wroldSceneCls:Class;
		
		protected var worldScene:CrocoScene;
		
		public function CrocoWorldSceneScreen()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(worldScene)
			{
				worldScene.dispose();
				worldScene = null;
			}
			
			wroldSceneCls = null;
		}
		
		override protected function initialize():void
		{
			worldScene = createWorldScene();
			
			if(worldScene)
			{
				onInitWorldScene();
				
				CrocoEngine.camera.setCurrentScene(worldScene);
			}
		}
		
		protected function createWorldScene():CrocoScene
		{
			//default in the 
			return new wroldSceneCls();
		}
		
		protected function onInitWorldScene():void
		{
			var entryScreenData:Object = getSlefCrocoScreenNavigatorItem().blackBoard.read(AppConfig.KEY_ENTRY_SCREEN_DATA);
			worldScene.name = entryScreenData[AppConfig.KEY_SCENE_ID];
			worldScene.screen = this;
		}
		
		override protected function screen_addedToStageHandler(event:Event):void
		{
			super.screen_addedToStageHandler(event);

			if(worldScene)
			{
				CrocoEngine.camera.setCurrentScene(worldScene);
			}
		}
		
		override protected function screen_removedFromStageHandler(event:Event):void
		{
			if(worldScene)
			{
				CrocoEngine.camera.setCurrentScene(null);
			}
		}
	}
}