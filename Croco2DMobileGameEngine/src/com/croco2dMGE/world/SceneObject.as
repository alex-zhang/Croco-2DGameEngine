package com.croco2dMGE.world
{
	import com.croco2dMGE.CrocoEngine;
	import com.croco2dMGE.core.CrocoBasic;
	import com.croco2dMGE.utils.CrocoRect;
	import com.croco2dMGE.utils.CroroMathUtil;
	import com.fireflyLib.utils.ColorUtil;
	
	import flash.display.Graphics;
	
	import starling.core.RenderSupport;

	public class SceneObject extends CrocoBasic
	{
		/**
		 * X position of the upper left corner of this object in world space.
		 */
		public var x:Number = 0.0;
		
		/**
		 * Y position of the upper left corner of this object in world space.
		 */
		public var y:Number = 0.0;
		
		public var screenX:Number = 0.0;
		
		public var screenY:Number = 0.0;
		
		public var zFighting:Number = 0.0;
		
		/**
		 * A point that can store numbers from 0 to 1 (for X and Y independently)
		 * that governs how much this object is affected by the camera subsystem.
		 * 0 means it never moves, like a HUD element or far background graphic.
		 * 1 means it scrolls along a the same speed as the foreground layer.
		 * scrollFactor is initialized as (1,1) by default.
		 */
		public var scrollFactorX:Number = 1.0;
		
		public var scrollFactorY:Number = 1.0;
		
		public var visibleTestRect:CrocoRect;
		
		/**
		 * Setting this to true will prevent the object from appearing
		 * when the visual debug mode in the debugger overlay is toggled on.
		 */
		public var debug:Boolean = false;
		
		public var layerZIndex:int = 0;
		
		public function SceneObject()
		{
			super();
		}
		
		public function get sceneLayer():SceneLayer { return owner as SceneLayer};
		public function get scene():CrocoScene { return owner ? SceneLayer(owner).scene : null};
		
		//collision
		public function isOverlapCamera():Boolean
		{
			if(visibleTestRect != null)
			{
				return CroroMathUtil.isOverlapRectangleAndRectangle(screenX + visibleTestRect.x, 
					screenY + visibleTestRect.y, 
					visibleTestRect.width, visibleTestRect.height,
					0, 0, CrocoEngine.camera.width, CrocoEngine.camera.height);
			}
			else
			{
				return CroroMathUtil.isOverlapPointAndRectangle(screenX, screenY, 
					0, 0, CrocoEngine.camera.width, CrocoEngine.camera.height);
			}
		}
		
		public function isOverlapPoint(pointX:Number, pointY:Number):Boolean
		{
			var targetScreenPointX:Number = pointX - CrocoEngine.camera.scrollX;
			var targetScreenPointY:Number = pointY - CrocoEngine.camera.scrollY;
			
			if(visibleTestRect != null)
			{
				return CroroMathUtil.isOverlapPointAndRectangle(targetScreenPointX, targetScreenPointY, 
					screenX + visibleTestRect.x, screenY + visibleTestRect.y, 
					visibleTestRect.width, visibleTestRect.height);
			}
			else
			{
				return CroroMathUtil.isOverlapPointAndPoint(screenX, screenY, 
					targetScreenPointX, targetScreenPointY);
			}
		}
		
		public function isOverlapRect(rectX:Number, rectY:Number, rectWidth:Number, rectHeight:Number):Boolean
		{
			var targetScreenRectX:Number = rectX - CrocoEngine.camera.scrollX;
			var targetScreenRectY:Number = rectY - CrocoEngine.camera.scrollY;
			
			if(visibleTestRect != null)
			{
				return CroroMathUtil.isOverlapRectangleAndRectangle(screenX + visibleTestRect.x, 
					screenY + visibleTestRect.y, visibleTestRect.width, visibleTestRect.height,
					targetScreenRectX, targetScreenRectY, rectWidth, rectHeight);
			}
			else
			{
				return CroroMathUtil.isOverlapPointAndRectangle(screenX, screenY, 
					targetScreenRectX, targetScreenRectY, rectWidth, rectHeight);
			}
		}
		
		public function isOverlapCircle(circleCenterX:Number, circleCenterY:Number, circleRadius:Number):Boolean
		{
			var targetScreenCircleCenterX:Number = circleCenterX - CrocoEngine.camera.scrollX;
			var targetScreenCircleCenterY:Number = circleCenterY - CrocoEngine.camera.scrollY;
			
			if(visibleTestRect != null)
			{
				return CroroMathUtil.isOverlapRectangleAndCircle(screenX + visibleTestRect.x, 
					screenY + visibleTestRect.y, visibleTestRect.width, visibleTestRect.height,
					targetScreenCircleCenterX, targetScreenCircleCenterY, circleRadius);
			}
			else
			{
				return CroroMathUtil.isOverlapPointAndCircle(screenX, screenY, 
					targetScreenCircleCenterX, targetScreenCircleCenterY, circleRadius);
			}
		}
		
		public function isOverlapSceneObject(object:SceneObject):Boolean
		{
			if(this.visibleTestRect != null)
			{
				if(object.visibleTestRect != null)
				{
					return CroroMathUtil.isOverlapRectangleAndRectangle(this.screenX + this.visibleTestRect.x, 
						this.screenY + this.visibleTestRect.y, this.visibleTestRect.width, this.visibleTestRect.height,
						object.screenX + object.visibleTestRect.x, object.screenY + object.visibleTestRect.y, 
						object.visibleTestRect.width, object.visibleTestRect.height);
				}
				else
				{
					return CroroMathUtil.isOverlapPointAndRectangle(object.screenX, object.screenY, 
						this.screenX + this.visibleTestRect.x, 
						this.screenY + this.visibleTestRect.y, this.visibleTestRect.width, this.visibleTestRect.height);
				}
			}
			else
			{
				if(object.visibleTestRect != null)
				{
					return CroroMathUtil.isOverlapPointAndRectangle(this.screenX, this.screenY, 
						object.screenX + object.visibleTestRect.x, object.screenY + object.visibleTestRect.y, 
						object.visibleTestRect.width, object.visibleTestRect.height);
				}
				else
				{
					return CroroMathUtil.isOverlapPointAndPoint(this.screenX, this.screenY, object.screenX, object.screenY);
				}
			}
		}
		
		override public function tick(deltaTime:Number):void
		{
			screenX = x - CrocoEngine.camera.scrollX * scrollFactorX;
			screenY = y - CrocoEngine.camera.scrollY * scrollFactorY;
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(debug && CrocoEngine.debug)
			{
				drawDebug(CrocoEngine.debugGraphics);
			}
		}
		
		protected function drawDebug(debugGraphics:Graphics):void
		{
			var offset:Number = 25;
			debugGraphics.lineStyle(1, ColorUtil.PINK, 0.5);
			
			debugGraphics.moveTo(screenX - offset, screenY);
			debugGraphics.lineTo(screenX + offset, screenY);
			debugGraphics.moveTo(screenX, screenY - offset);
			debugGraphics.lineTo(screenX, screenY + offset);
		}
		
		override public function onDeactive():void
		{
			super.onDeactive();
			
			zFighting = 0;
		}
	}
}