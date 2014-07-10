package com.croco2d.components.render
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.GameObject;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;

	public class CameraRenderComponent extends RenderComponent
	{
		public var watchTarget:GameObject;

		public function CameraRenderComponent()
		{
			super();
		}

		override protected function onActive():void
		{
			GameObject(owner).cameraRender = this;
			
			watchTarget = CrocoEngine.rootGameObject;
			
			CrocoEngine.instance.addEventListener(CrocoEngine.EVENT_CANVAS_STAGE_TOUCH, canvasTouchHandler);
			CrocoEngine.instance.addEventListener(CrocoEngine.EVENT_CHANGED_ROOT_GAME_OBJECT, rootGameObjectChangedHandler);
//			CrocoEngine.instance.addEventListener(CrocoEngine.EVENT_STAGE_RESIZE, stageResizeHandler);
		}
		
		override protected function onDeactive():void
		{
			GameObject(owner).cameraRender = null;
			
			watchTarget = null;
			
			CrocoEngine.instance.removeEventListener(CrocoEngine.EVENT_CANVAS_STAGE_TOUCH, canvasTouchHandler);
			CrocoEngine.instance.removeEventListener(CrocoEngine.EVENT_CHANGED_ROOT_GAME_OBJECT, rootGameObjectChangedHandler);
//			CrocoEngine.instance.addEventListener(CrocoEngine.EVENT_STAGE_RESIZE, stageResizeHandler);
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(watchTarget && watchTarget.__alive && watchTarget.visible)
			{
				watchTarget.draw(support, parentAlpha);
			}
		}
		
		override public function onDebugDraw():void
		{
			CrocoEngine.debugGraphics.lineStyle(1, 0xFF0000);
			
			CrocoEngine.debugGraphics.drawRect(0, 0, CrocoEngine.stageWidth - 1, CrocoEngine.stageHeight);

			var lineLenth:Number = 20;
			var halfWidth:Number = CrocoEngine.stageWidth * 0.5;
			var halfHeight:Number = CrocoEngine.stageHeight * 0.5;
			
			CrocoEngine.debugGraphics.moveTo(halfWidth, halfHeight - lineLenth);
			CrocoEngine.debugGraphics.lineTo(halfWidth, halfHeight + lineLenth);
			CrocoEngine.debugGraphics.moveTo(halfWidth - lineLenth, halfHeight);
			CrocoEngine.debugGraphics.lineTo(halfWidth + lineLenth, halfHeight);
		}
		
		protected function canvasTouchHandler(event:TouchEvent = null):void
		{
			var touches:Vector.<Touch> = event.data as Vector.<Touch>;
			var n:int = touches ? touches.length: 0;
			
			var touch:Touch;
			var target:DisplayObject;
			var owner:CrocoObject
			var gameObject:GameObject;
			
			for(var i:int = 0; i < n; i++)
			{
				touch = touches[i];
				target = touch.target;
				
				if(target.myData.owner)
				{
					owner = target.myData.owner as CrocoObject;
					if(owner)
					{
						gameObject = owner.owner as GameObject;
						if(gameObject)
						{
							gameObject.dispatchEvent(GameObject.EVENT_TOUCH, touch);
						}
					}
				}
			}
		}
		
		protected function rootGameObjectChangedHandler(rootGameObject:GameObject = null):void
		{
			watchTarget = CrocoEngine.rootGameObject;
		}
		
//		protected function stageResizeHandler(eventData:Object = null):void
//		{
//			
//		}
	}
}