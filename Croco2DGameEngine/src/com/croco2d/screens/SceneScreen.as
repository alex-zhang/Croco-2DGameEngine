package com.croco2d.screens
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.scene.CrocoScene;
	
	import starling.events.Event;

	public class SceneScreen extends CrocoScreen
	{
		public var scene:CrocoScene;

		public function SceneScreen()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(scene)
			{
				scene.dispose();
				scene = null;
			}
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			if(!scene)
			{
				scene = createScene();
			}
			
			onInitScene();
		}
		
		protected function createScene():CrocoScene
		{
			return new CrocoScene();
		}
		
		protected function onInitScene():void
		{
			scene.assetsManager = assetsManager;
			
			//if one screen has many scene we should change the name here.
			scene.name = this.screenID;
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