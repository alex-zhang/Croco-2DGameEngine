package com.croco2d.core
{
	import com.croco2d.AppConfig;
	import com.croco2d.CrocoEngine;
	import com.croco2d.utils.CrocoMathUtil;
	import com.fireflyLib.utils.MathUtil;
	import com.llamaDebugger.Logger;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.events.TouchEvent;

	public class CrocoCamera extends CrocoObjectEntity
	{
		public var alpha:Number = 1.0;

		public var moveable:Boolean = true;
		public var zoomable:Boolean = true;
		public var rotatable:Boolean = true;

		/**	
		 * any type which has the x and y property Object. 
		 * 
		 * Tells the camera to follow this <code>FlxObject</code> object around.
		 */
		public var focusTarget:Object;
		
		/**
		 *  u can consider the watchTarget as Scene.
		 */
		public var watchTarget:CrocoGameObject;

		public var aabb:Rectangle = new Rectangle();

		/**
		 * How wide the camera display is, in game pixels.
		 */
		public var __width:Number = 0;
		/**
		 * How tall the camera display is, in game pixels.
		 */
		public var __height:Number = 0;
		
		/**
		 * How wide the camera display is, in game pixels.
		 */
		public var __halfWidth:Number = 0;
		/**
		 * How tall the camera display is, in game pixels.
		 */
		public var __halfHeight:Number = 0;

		/**
		 * The edges of the camera's range, i.e. where to stop scrolling.
		 * Measured in game pixels and world coordinates.
		 */
		public var __bounds:Rectangle;
		
		public var __pivotX:Number = 0;
		public var __pivotY:Number = 0;

		public var __zoom:Number = 1.0;
		public var __rotation:Number = 0.0;

		public var __transformMatrix:Matrix = null;
		public var __transformMatrixDirty:Boolean = true;
		
		public var __displayStage:DisplayObjectContainer;
		
		public function CrocoCamera()
		{
			super();
			
			this.name = AppConfig.KEY_CAMERA;
			this.eventEnable = true;
		}
		
		public final function get displayStage():DisplayObjectContainer
		{
			return __displayStage;
		}
		
		public function get width():Number
		{
			return __width;
		}
		
		public function get height():Number
		{
			return __height;
		}
		
		public function get halfWidth():Number
		{
			return __halfWidth;
		}
		
		public function get halfHeight():Number
		{
			return __halfHeight;
		}
		
		public function get pivotX():Number
		{
			return __pivotX;
		}
		
		public function get pivotY():Number
		{
			return __pivotY;
		}
		
		public function get zoom():Number
		{
			return __zoom;
		}
		
		public function get rotation():Number
		{
			return __rotation;
		}
		
		public function reset():void
		{
			__rotation = 0;
			__zoom = 1.0;
			__pivotX = 0;
			__pivotY = 0;
			__bounds = null;
			alpha = 1.0;
			focusTarget = null;
			__transformMatrixDirty = true;
		}
		
		public function setBounds(bounds:Rectangle):void
		{
			__bounds = bounds;
			__transformMatrixDirty = true;
		}
		
		public function lookAt(x:Number, y:Number):void
		{
			if(!moveable)
			{
				Logger.error(name, "lookAt moveable false!");
				return;
			}
			
			if(__pivotX != x && __pivotY != y)
			{
				__pivotX = x;
				__pivotY = y;
				
				__transformMatrixDirty = true;
			}
		}
		
		public function translate(deltaX:Number, deltaY:Number):void
		{
			lookAt(__pivotX + deltaX, __pivotY + deltaY);
		}
		
		public function setZoom(value:Number):void
		{
			if(!zoomable)
			{
				Logger.error(name, "setZoom zoomable false!");
				return;
			}
			
			if(__zoom != value)
			{
				__zoom = value;
				
				__transformMatrixDirty = true;
			}
		}
		
		public function zoomFitSize(sizeWidth:Number, sizeHeight:Number):void
		{
			var cameraRatio:Number = width / height;
			var sizeRatio:Number = sizeWidth / sizeHeight;
			
			var targetZoom:Number = cameraRatio > sizeRatio ?
				height / sizeHeight :
				width / sizeWidth;
			
			setZoom(targetZoom);
		}
		
		public function setRotation(value:Number):void
		{
			if(!rotatable)
			{
				Logger.error(name, "setRotation rotatable false!");
				return;
			}
			
			value = CrocoMathUtil.clampRadian(value);
			
			if(__rotation != value)
			{
				__rotation = value;
				
				__transformMatrixDirty = true;
			}
		}
		
		public function rotate(angle:Number):void
		{
			setRotation(__rotation + angle);
		}
		
		public function invalidateTransformMatrix():void
		{
			__transformMatrixDirty = true;
		}
		
		override protected function onInit():void
		{
			super.onInit();

			__displayStage = new CameraDisplayStage(this);
			Starling.current.stage.addChildAt(__displayStage, 0);
			
			__width = Starling.current.stage.stageWidth;
			__height = Starling.current.stage.stageHeight;
			__halfWidth = width * 0.5;
			__halfHeight = height * 0.5;
			__transformMatrixDirty = true;
			
			Starling.current.stage.addEventListener(ResizeEvent.RESIZE, stageResizeHandler);
			__displayStage.addEventListener(TouchEvent.TOUCH, cameraDisplayTouchHandler);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			__width = NaN;
			__height = NaN;
			__halfWidth = NaN;
			__halfHeight = NaN;
			
			if(__displayStage)
			{
				__displayStage.dispose();
				__displayStage = null;	
			}
		}

		protected function stageResizeHandler(event:Event = null):void
		{
			__width = Starling.current.stage.stageWidth;
			__height = Starling.current.stage.stageHeight;

			__halfWidth = width * 0.5;
			__halfHeight = height * 0.5;
			__transformMatrixDirty = true;
		}

		protected function cameraDisplayTouchHandler(event:TouchEvent):void
		{
			dispatchEvent(TouchEvent.TOUCH, event);
		}
		
		public function get transformMatrix():Matrix
		{
			if(!__transformMatrix) __transformMatrix = new Matrix();
			
			if(__transformMatrixDirty)
			{
				if(__bounds)
				{
					__pivotX = MathUtil.clamp(__pivotX, __bounds.x + halfWidth, __bounds.width - halfWidth);
					__pivotY = MathUtil.clamp(__pivotY, __bounds.y + halfHeight, __bounds.height - halfHeight);
				}
				
				if (__rotation == 0.0)
				{
					__transformMatrix.setTo(__zoom, 0, 0, __zoom, 
						halfWidth - __pivotX * __zoom , 
						halfHeight - __pivotY * __zoom);
				}
				else
				{	
					var cos:Number = Math.cos(__rotation);
					var sin:Number = Math.sin(__rotation);
					
					var a:Number   = __zoom *  cos;
					var b:Number   = __zoom *  sin;
					var c:Number   = -b;//zoom * -sin;
					var d:Number   = a;//zoom *  cos;
					var tx:Number  = halfWidth - __pivotX * a - __pivotY * c;
					var ty:Number  = halfHeight - __pivotX * b - __pivotY * d;
					
					__transformMatrix.setTo(a, b, c, d, tx, ty);
				}
				
				var helperMatrix:Matrix = CrocoMathUtil.helperMatrix;
				helperMatrix.copyFrom(__transformMatrix);
				helperMatrix.invert();
				
				aabb.setTo(0, 0, __width, __height);
				CrocoMathUtil.matrixTransformAABB(aabb, helperMatrix, aabb);
				
				__transformMatrixDirty = false;
			}
			
			return __transformMatrix;
		}
		
		override public function tick(deltaTime:Number):void
		{
//			var time:int = getTimer();

			super.tick(deltaTime);
			
			if(focusTarget != null)
			{
				lookAt(focusTarget.x, focusTarget.y);
			}
			
//			trace("camera tick time: " + (getTimer() - time));
		}
		
		public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			const debugDraw:Boolean = CrocoEngine.debug && debug;
			
			if(debugDraw) 
			{
				CrocoEngine.debugGraphics.clear();
			}
			
			if(watchTarget && watchTarget.__alive)
			{
				watchTarget.draw(support, parentAlpha * alpha);
			}
			
			if(debugDraw) 
			{
				onDrawDebug();
			}

			if(debugDraw) 
			{
				CrocoEngine.debugGraphics.endFill();
			}
//			trace("camera draw time: " + (getTimer() - time));
		}
		
		protected function onDrawDebug():void
		{
			var camera:CrocoCamera = CrocoEngine.camera;
			CrocoEngine.debugGraphics.lineStyle(2, 0xFF0000);
			CrocoEngine.debugGraphics.drawRect(0, 0, width, height);
			
			var lineLenth:Number = 20;
			
			CrocoEngine.debugGraphics.lineStyle(1, 0xFF0000);
			CrocoEngine.debugGraphics.moveTo(halfWidth, halfHeight - lineLenth);
			CrocoEngine.debugGraphics.lineTo(halfWidth, halfHeight + lineLenth);
			CrocoEngine.debugGraphics.moveTo(halfWidth - lineLenth, halfHeight);
			CrocoEngine.debugGraphics.lineTo(halfWidth + lineLenth, halfHeight);
		}

		public function localPointToGlobalPoint(localPoint:Point, result:Point = null):Point
		{
			return __displayStage.localToGlobal(localPoint, result);
		}
		
//		public function scenePointToLocalPoint(sceneX:Number, sceneY:Number, result:Point):Point
//		{
//			if(!result) result = new Point();
//			
//			CrocoMathUtil.helperMatrix.copyFrom(transformMatrix);
//			CrocoMathUtil.helperMatrix.invert();
//			
//			MatrixUtil.transformCoords(CrocoMathUtil.helperMatrix, sceneX, sceneY, result);
//			
//			return result;
//		}

		public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(watchTarget && watchTarget.__alive)
			{
				return watchTarget.hitTest(localPoint, forTouch);
			}

			return null;
		}
	}
}

//------------------------------------------------------------------------------

import com.croco2d.core.CrocoCamera;

import flash.geom.Point;

import starling.core.RenderSupport;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;

final class CameraDisplayStage extends DisplayObjectContainer
{
	private var mCrocoCamera:CrocoCamera;
	
	public function CameraDisplayStage(camera:CrocoCamera)
	{
		alpha = 0.999;//for starling gpu render state change.
		mCrocoCamera = camera;
	}
	
	override public function render(support:RenderSupport, parentAlpha:Number):void
	{
		mCrocoCamera.draw(support, parentAlpha * alpha);
	}
	
	override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
	{
		return mCrocoCamera.hitTest(localPoint, forTouch); 
	}
}