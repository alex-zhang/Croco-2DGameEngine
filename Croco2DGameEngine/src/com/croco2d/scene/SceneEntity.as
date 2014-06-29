package com.croco2d.scene
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.components.DisplayComponent;
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.CrocoObjectEntity;
	import com.croco2d.utils.CrocoMathUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.utils.MatrixUtil;
	
	public class SceneEntity extends CrocoObjectEntity
	{
		public var x:Number = 0.0;
		public var y:Number = 0.0;
		
		public var ignoreCameraMatrix:Boolean = false;

		public var aabb:Rectangle = null;
		
		public var scene:CrocoScene;
		public var sceneLayer:SceneLayer;
		
		public var __displayComponet:DisplayComponent;

		public function SceneEntity()
		{
			super();

			//draw able.
			visible = true;
		}
		
		public function get displayComponet():DisplayComponent
		{
			return __displayComponet;
		}

		override protected function onPluginComponent(component:CrocoObject):void
		{
			super.onPluginComponent(component);
			
			if(component is DisplayComponent)
			{
				__displayComponet = component as DisplayComponent;
			}
		}
		
		override protected function onPlugoutComponent(component:CrocoObject, needDispose:Boolean = false):void
		{
			super.onPlugoutComponent(component, needDispose);

			if(__displayComponet === component)
			{
				__displayComponet = null;
			}
		}
		
		public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(forTouch && (!visible)) return null;
			
			if(__displayComponet && __displayComponet.__alive)
			{
				return __displayComponet.hitTest(localPoint, forTouch);
			}
			else
			{
				return null;
			}
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			super.draw(support, parentAlpha);

			if(__displayComponet &&
				__displayComponet.__alive && 
				__displayComponet.visible)
			{
				__displayComponet.draw(support, parentAlpha);
			}
		}
		
		override protected function onDrawDebug():void
		{
			var camera:CrocoCamera = CrocoEngine.camera;
			
			var globalX:Number = this.x;
			var globalY:Number = this.y;
			
			if(!ignoreCameraMatrix)
			{
				var helpPoint:Point = CrocoMathUtil.helperFlashPoint;
				MatrixUtil.transformCoords(camera.transformMatrix, globalX, globalY, helpPoint);
				
				globalX = helpPoint.x;
				globalY = helpPoint.y;
			}

			var lineLenth:Number = 20;
			
			camera.debugGraphics.lineStyle(1, 0xFF0000);
			camera.debugGraphics.moveTo(globalX, globalY - lineLenth);
			camera.debugGraphics.lineTo(globalX, globalY + lineLenth);
			camera.debugGraphics.moveTo(globalX - lineLenth, globalY);
			camera.debugGraphics.lineTo(globalX + lineLenth, globalY);
		}
		
		override public function dispose():void
		{
			super.dispose();

			//__displayComponet will dispose by super.
			__displayComponet = null;
			aabb = null;
			x = NaN;
			y = NaN;
		}
		
		override public function toString():String
		{
			var results:String = super.toString() + "\n" +
				"x: " + x + "\n" +
				"y: " + y + "\n" +
				"ignoreCameraMatrix :" + ignoreCameraMatrix + "\n" +
				"aabb: " + aabb;

			return results;
		}
	}
}