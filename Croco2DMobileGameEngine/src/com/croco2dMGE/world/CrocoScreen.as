package com.croco2dMGE.world
{
	import com.croco2dMGE.CrocoEngine;
	
	import feathers.controls.Screen;
	
	import starling.events.Event;

	public class CrocoScreen extends Screen
	{
		public var sceneCls:Class;
		
		protected var mScene:CrocoScene;
		
		public function CrocoScreen()
		{
			super();
		}
		
		public function get scene():CrocoScene { return mScene; }
		
		protected function onInitScene():void
		{
			sceneCls ||= CrocoScene;
			
			mScene = new sceneCls();
			mScene.name = this.name;
		}
		
		override protected function initialize():void
		{
			onInitScene();
			
			if(mScene)
			{
				CrocoEngine.camera.setCurrentScene(mScene);
			}
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