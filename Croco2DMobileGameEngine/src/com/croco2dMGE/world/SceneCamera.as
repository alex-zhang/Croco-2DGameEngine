package com.croco2dMGE.world
{
	import com.croco2dMGE.AppConfig;
	import com.croco2dMGE.CrocoEngine;
	import com.croco2dMGE.core.CrocoBasic;
	import com.croco2dMGE.utils.CrocoRect;
	import com.fireflyLib.utils.MathUtil;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;

	public class SceneCamera extends CrocoBasic
	{
		/**
		 * Stores the basic parallax scrolling values.
		 */
		public var scrollX:Number = 0;

		public var scrollY:Number = 0;
		
		public var alpha:Number = 1.0;
		
		/**
		 * You can assign a "dead zone" to the camera in order to better control its movement.
		 * The camera will always keep the focus object inside the dead zone,
		 * unless it is bumping up against the bounds rectangle's edges.
		 * The deadzone's coordinates are measured from the camera's upper left corner in game pixels.
		 * For rapid prototyping, you can use the preset deadzones (e.g. <code>STYLE_PLATFORMER</code>) with <code>follow()</code>.
		 */
		public var deadzone:CrocoRect;
		
		/**
		 * The edges of the camera's range, i.e. where to stop scrolling.
		 * Measured in game pixels and world coordinates.
		 */
		public var bounds:CrocoRect;

		/**
		 * How wide the camera display is, in game pixels.
		 */
		public var width:Number = 0;
		/**
		 * How tall the camera display is, in game pixels.
		 */
		public var height:Number = 0;
		
		public var zoom:Number = 1.0;
		
		public var viewPortWidth:uint = 0;
		
		public var viewPortHeight:uint = 0;
		
		/**
		 * any type which has the x and y property Object. 
		 * 
		 * Tells the camera to follow this <code>FlxObject</code> object around.
		 */
		public var target:Object;
		
		public var currentScene:CrocoScene;
		
		protected var mCameraDisplayStage:DisplayObject;
		
		public function SceneCamera()
		{
			super();

			this.name = AppConfig.KEY_SCENE_CAMERA;
		}
		
		public function setCurrentScene(value:CrocoScene):void
		{
			if(currentScene != value)
			{
				if(currentScene)
				{
					currentScene.onDeactive();
				}
				
				reset();
				
				currentScene = value; 
				
				if(currentScene)
				{
					currentScene.init();
					
					currentScene.onActive();
				}
			}
		}
		
		public function reset():void
		{
			zoom = 1.0;
			alpha = 1.0;
			focusOn(viewPortWidth >> 1, viewPortHeight >> 1);
		}
		
		override protected function onInit():void
		{
			mCameraDisplayStage = createCameraDisplayStage();
			CrocoEngine.crocoStarling.stage.addChildAt(mCameraDisplayStage, 0);
		}
		
		protected function createCameraDisplayStage():DisplayObject
		{
			var d:DisplayObject = new CameraDisplayStage(this);
			d.name = "Camera::" + name;
			return d;
		}
		
		/**
		 * Move the camera focus to this location instantly.
		 * 
		 * @param	Point		Where you want the camera to focus.
		 */
		public function focusOn(sceneX:Number, sceneY:Number):void
		{
			scrollX = sceneX - (width >> 1);
			scrollY = sceneY - (height >> 1);
		}
		
		override public function tick(deltaTime:Number):void
		{
			viewPortWidth = CrocoEngine.width;
			viewPortHeight = CrocoEngine.height;
			
			width = viewPortWidth * zoom;
			height = viewPortHeight * zoom;
			
			if(currentScene && currentScene.actived && currentScene.tickable)
			{
				currentScene.tick(deltaTime);
			}
			
			if(target != null)
			{
				if(deadzone != null)
				{
					scrollX = MathUtil.clamp(scrollX, scrollX - deadzone.x, scrollX - deadzone.x - deadzone.width);
					scrollY = MathUtil.clamp(scrollY, scrollY - deadzone.y, scrollY - deadzone.y - deadzone.height);
				}
				else
				{
					focusOn(target.x, target.y);
				}
			}
			
			//Make sure we didn't go outside the camera's bounds
			if(bounds != null)
			{
				scrollX = MathUtil.clamp(scrollX, bounds.x, bounds.width - width);
				scrollY = MathUtil.clamp(scrollY, bounds.y, bounds.height - height);
			}
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(currentScene && currentScene.actived && currentScene.visible)
			{
				currentScene.draw(support, parentAlpha);
			}
			
			mCameraDisplayStage.scaleX = mCameraDisplayStage.scaleY = 1 /  zoom;
			mCameraDisplayStage.alpha = alpha;
		}
		
		public function hitTest(screenX:Number, screenY:Number):DisplayObject
		{
			if(currentScene && currentScene.actived && currentScene.visible)
			{
				var sceneX:Number = screenX + scrollX;
				var sceneY:Number = screenY + scrollY;
				
				return currentScene.hitTest(sceneX, sceneY);
			}
			
			return null;
		}
	}
}

import com.croco2dMGE.world.SceneCamera;

import flash.geom.Point;

import starling.core.RenderSupport;
import starling.display.DisplayObject;

final class CameraDisplayStage extends DisplayObject
{
	private var mCamera:SceneCamera
	
	public function CameraDisplayStage(camera:SceneCamera)
	{
		this.mCamera = camera;
	}
	
	override public function render(support:RenderSupport, parentAlpha:Number):void
	{
		if(mCamera.actived)
		{
			support.pushMatrix();
			support.transformMatrix(this);
			
			mCamera.draw(support, parentAlpha);
			
			support.popMatrix();
		}
	}
	
	override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
	{
		if(mCamera.actived)
		{
			return mCamera.hitTest(localPoint.x, localPoint.y);
		}
		
		return null;
	}
}