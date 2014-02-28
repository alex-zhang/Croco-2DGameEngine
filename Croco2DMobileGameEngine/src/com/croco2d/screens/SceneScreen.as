package com.croco2d.screens
{
	import com.croco2d.AppConfig;
	import com.croco2d.CrocoEngine;
	import com.croco2d.entities.CrocoScene;
	
	import starling.events.Event;

	public class SceneScreen extends CrocoScreen
	{
		//see CrocoBootStrapConfig screen define props.
		public var sceneCls:*;//type see ObjectFactoryUtil.newInstance2
		
		public var scene:CrocoScene;
		
		public function SceneScreen()
		{
			super();
		}
		
		public function get sceneId():String
		{
			return entryScreenData ? 
				entryScreenData[AppConfig.KEY_SCREEN_ID] : 
				null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(scene)
			{
				scene.dispose();
				scene = null;
			}
			
			sceneCls = null;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			if(!scene)
			{
				scene = createScene();
			}

			if(scene)
			{
				onInitScene();
				
				CrocoEngine.camera.setCurrentScene(scene);
			}
		}
		
		protected function createScene():CrocoScene
		{
			return new sceneCls(); 
		}
		
		protected function onInitScene():void
		{
			scene.uid = sceneId;
			scene.screen = this;
			scene.screenAssetsManager = screenAssetsManager;
		}
		
		override protected function screen_addedToStageHandler(event:Event):void
		{
			super.screen_addedToStageHandler(event);

			if(scene)
			{
				CrocoEngine.camera.setCurrentScene(scene);
			}
		}
		
		override protected function screen_removedFromStageHandler(event:Event):void
		{
			if(scene)
			{
				CrocoEngine.camera.setCurrentScene(null);
			}
		}
	}
}