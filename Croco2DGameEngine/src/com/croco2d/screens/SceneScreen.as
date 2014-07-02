package com.croco2d.screens
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.core.CrocoGameObject;
	
	import starling.events.Event;

	public class SceneScreen extends CrocoScreen
	{
		public var scene:CrocoGameObject

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
			
			if(scene)
			{
				onActiveScene();
			}
		}
		
		protected function onActiveScene():void
		{
			CrocoEngine.camera.reset();
			
			scene.init();
			scene.active();
			
			CrocoEngine.rootGameObject = scene;
			CrocoEngine.camera.watchTarget = scene;
		}
		
		protected function onDeactiveScene():void
		{
			scene.deactive();
			
			CrocoEngine.rootGameObject = null;
			CrocoEngine.camera.watchTarget = null;
		}
		
		protected function createScene():CrocoGameObject
		{
			var scene:CrocoGameObject = CrocoGameObject.createEmpty();
			scene.name = this.screenID;
			
			return scene;
		}
		
		override protected function screen_addedToStageHandler(event:Event):void
		{
			super.screen_addedToStageHandler(event);

			if(scene)
			{
				onActiveScene();
			}
		}
		
		override protected function screen_removedFromStageHandler(event:Event):void
		{
			if(scene)
			{
				onDeactiveScene();
			}
		}
	}
}