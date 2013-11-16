package com.croco2dMGE.graphics.screens
{
	import com.croco2dMGE.CrocoEngine;
	import com.croco2dMGE.world.CrocoScene;
	
	import starling.events.Event;

	public class CrocoSceneScreen extends CrocoScreen
	{
		protected var mScene:CrocoScene;
		
		public function CrocoSceneScreen()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mScene)
			{
				mScene.dispose();
				mScene = null;
			}
		}
		
		override protected function initialize():void
		{
			onInitScene();
			
			if(mScene)
			{
				mScene.name = this.screenID;
				CrocoEngine.camera.setCurrentScene(mScene);
			}
		}
		
		protected function onInitScene():void
		{
		}
		
		override protected function screen_addedToStageHandler(event:Event):void
		{
			super.screen_addedToStageHandler(event);

			if(mScene)
			{
				CrocoEngine.camera.setCurrentScene(mScene);
			}
		}
		
		override protected function screen_removedFromStageHandler(event:Event):void
		{
			if(mScene)
			{
				CrocoEngine.camera.setCurrentScene(null);
			}
		}
	}
}