package com.croco2d.components.render
{
	import com.croco2d.CrocoEngine;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.ResizeEvent;

	public class CameraComponent extends MonitorComponent
	{
		public var aabb:Rectangle = new Rectangle();
		public var size:Rectangle = new Rectangle();
		
		public function CameraComponent()
		{
			super();
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			CrocoEngine.camera = this;
			
			watchTarget = CrocoEngine.rootGameObject;
			
			size.width = Starling.current.stage.stageWidth;
			size.height = Starling.current.stage.stageHeight;

			CrocoEngine.instance.addEventListener(CrocoEngine.EVENT_STAGE_RESIZE, stageResizeHandler);
		}
		
		override public function onDebugDraw():void
		{
			CrocoEngine.debugGraphics.lineStyle(2, 0xFF0000);
			CrocoEngine.debugGraphics.drawRect(0, 0, size.width, size.height);
			
			const lineLenth:Number = 20;
			
			const halfWidth:Number = size.width * 0.5;
			const halfHeight:Number = size.height * 0.5;
			
			CrocoEngine.debugGraphics.lineStyle(1, 0xFF0000);
			CrocoEngine.debugGraphics.moveTo(halfWidth, halfHeight - lineLenth);
			CrocoEngine.debugGraphics.lineTo(halfWidth, halfHeight + lineLenth);
			CrocoEngine.debugGraphics.moveTo(halfWidth - lineLenth, halfHeight);
			CrocoEngine.debugGraphics.lineTo(halfWidth + lineLenth, halfHeight);
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			return null;
			if(watchTarget && watchTarget.__alive)
			{
				return watchTarget.hitTest(localPoint, forTouch);
			}

			return null;
		}
		
		protected function stageResizeHandler(event:ResizeEvent = null):void
		{
			size.width = Starling.current.stage.stageWidth;
			size.height = Starling.current.stage.stageHeight;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			CrocoEngine.camera = null;
		}
	}
}