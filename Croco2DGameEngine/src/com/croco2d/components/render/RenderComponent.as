package com.croco2d.components.render
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.components.GameObjectComponent;
	import com.croco2d.core.GameObject;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;

	public class RenderComponent extends GameObjectComponent
	{
		public function RenderComponent()
		{
			super();

			//default.
			this.name = GameObject.PROP_RENDER;
		}
		
		public function draw(support:RenderSupport, parentAlpha:Number):void
		{
		}
		
		override public function onDebugDraw():void
		{
			const lineLenth:Number = 10;
			const lastModeViewMatrix:Matrix =  transform.__lastModelViewMatrix;
			
			CrocoEngine.debugGraphics.lineStyle(1, 0xFF0000);
			CrocoEngine.debugGraphics.drawCircle(lastModeViewMatrix.tx, lastModeViewMatrix.ty, lineLenth * 0.5);
			
			CrocoEngine.debugGraphics.moveTo(lastModeViewMatrix.tx, lastModeViewMatrix.ty - lineLenth);
			CrocoEngine.debugGraphics.lineTo(lastModeViewMatrix.tx, lastModeViewMatrix.ty + lineLenth);
			CrocoEngine.debugGraphics.moveTo(lastModeViewMatrix.tx - lineLenth, lastModeViewMatrix.ty);
			CrocoEngine.debugGraphics.lineTo(lastModeViewMatrix.tx + lineLenth, lastModeViewMatrix.ty);
		}
		
		public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			return null;
		}
	}
}