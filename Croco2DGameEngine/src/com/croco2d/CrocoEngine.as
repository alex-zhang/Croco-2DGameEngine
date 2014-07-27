package com.croco2d
{
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.CrocoObjectEntity;
	import com.croco2d.core.GameObject;
	import com.croco2d.input.InputManager;
	import com.croco2d.sound.SoundManager;
	import com.fireflyLib.utils.GlobalPropertyBag;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.events.ResizeEvent;
	import starling.events.TouchEvent;
	
	public class CrocoEngine extends CrocoObjectEntity
	{
		/** The version of the Engine. */
		public static const VERSION:String = "0.0.2";

		//Events.		
		public static const EVENT_START_ENGINE:String = "startEngine";
		public static const EVENT_STOP_ENGINE:String = "stopEngine";
		public static const EVENT_PRE_DRAW:String = "preDraw";
		public static const EVENT_AFTER_DRAW:String = "afterDraw";
		public static const EVENT_CHANGED_ROOT_GAME_OBJECT:String = "changedRootGameObject";
		public static const EVENT_CHANGED_CAMERA:String = "changedCamera";
		public static const EVENT_CANVAS_STAGE_TOUCH:String = "canvasStageTouch";
		public static const EVENT_STAGE_RESIZE:String = "stageResize";
		
		public static var engineCls:Class = CrocoEngine;
		
		/**
		 * The scale at which time advances. If this is set to 2, the game
		 * will play twice as fast. A value of 0.5 will run the
		 * game at half speed. A value of 1 is normal.
		 */
		public static var timeScale:Number = 1.0;
		
		/**
		 * Whether to show visual debug displays or not.
		 * Default = false.
		 */
		public static var debug:Boolean = false;
		
		/**
		 * The rate at which ticks are fired, in seconds.
		 */
		public static var tickDeltaTime:Number = 1.0 / 60;
		
		public static var maxTicksPerFrame:int = 5;
		
		
		/**
		 * If the game should stop updating/rendering.
		 */
		public static var __running:Boolean = false;
		
		public static var __tickTime:Number = 0.0;
		
		public static var __tickTimes:int = 0;
		
		public static var __curTime:int = -1;
		
		public static var __lastTime:int = -1;

		public static var __canvasStage:DisplayObject;
		
		//helper for reference.
		public static var instance:CrocoEngine;

        public static var camera:GameObject;
        /**
         *  u can consider the rootGameObject as Scene.
         */
        public static var rootGameObject:GameObject;

		public static var inputManager:InputManager;
		public static var soundManager:SoundManager;
		public static var globalAssetsManager:CrocoAssetsManager;

		public static var stageWidth:int = 0;
		public static var stageHeight:int = 0;

		public static var debugGraphics:Graphics;
		
		public static function findClsProperty(key:String):*
		{
			return engineCls[key];
		}
		
		//----------------------------------------------------------------------
		
		public var __onAdvanceCallback:Function = onAdvance;
		public var __onStartEngineCallback:Function = onStartEngine;
		public var __onStopEngineCallback:Function = onStopEngine;
		public var __onEnterFrameCallback:Function = onEnterFrame;
		public var __onCanvasStageTouchCallback:Function = onCanvasStageTouch;
		public var __onStageResizeCallback:Function = onStageResize;
		
		public function CrocoEngine()
		{
			super();
			
			if(instance) throw new Error("CrocoEngine is a singleton mode Class!");
			instance = this;
			
			name = AppConfig.KEY_CROCO_ENGINE;
			eventEnable = true;
			debug = CrocoEngine.debug;
		}
		
		public final function start():void
		{ 
			if(__running) return;
			
			__running = true;
			
			__onStartEngineCallback();
			__lastTime = -1;
			
			dispatchEvent(EVENT_START_ENGINE);
			
			GlobalPropertyBag.stage.addEventListener(flash.events.Event.ENTER_FRAME, __onEnterFrameCallback);
		}
		
		protected function onStartEngine():void {};
		
		public final function stop():void 
		{ 
			if(!__running) return;
			
			__running = false;
			
			__onStopEngineCallback();
			
			dispatchEvent(EVENT_STOP_ENGINE);
			
			GlobalPropertyBag.stage.removeEventListener(flash.events.Event.ENTER_FRAME, __onEnterFrameCallback);
		}
		
		protected function onStopEngine():void {};
		
		public final function get running():Boolean
		{ 
			return __running;
		}
		
		public final function setRootGameObject(value:GameObject):void
		{
			if(rootGameObject != value)
			{
				if(rootGameObject)
				{
					rootGameObject.deactive();
				}

				rootGameObject = value;
				
				if(!inited) return;
				
				if(rootGameObject)
				{
					rootGameObject.init();
					rootGameObject.active();
				}
				
				dispatchEvent(EVENT_CHANGED_ROOT_GAME_OBJECT, rootGameObject);
			}
		}


        public final function setCamera(value:GameObject):void
        {
            if(camera != value)
            {
                if(camera)
                {
                    camera.deactive();
                }

                camera = value;

                if(!inited) return;

                if(camera)
                {
                    camera.init();
                    camera.active();
                }

                dispatchEvent(EVENT_CHANGED_CAMERA, camera);
            }
        }
		
		public final function advance(elapsedTime:Number):void
		{
			__onAdvanceCallback(elapsedTime * timeScale, true);
		}
		
		override protected function onPluginComponent(component:CrocoObject):void
		{
			super.onPluginComponent(component);
			
			switch(component.name)
			{
				case AppConfig.KEY_INPUT_MANAGER:
					inputManager = InputManager(component);
					break;
				
				case AppConfig.KEY_SOUND_MANAGER:
					soundManager = SoundManager(component);
					break;
				
				case AppConfig.KEY_GLOBAL_ASSETS_MANAGER:
					globalAssetsManager = CrocoAssetsManager(component);
					break;
			}
		}
		
		override protected function onPlugoutComponent(component:CrocoObject, needDispose:Boolean=false):void
		{
			switch(component.name)
			{
				case AppConfig.KEY_INPUT_MANAGER:
					inputManager = null;
					break;
				
				case AppConfig.KEY_SOUND_MANAGER:
					soundManager = null;
					break;
				
				case AppConfig.KEY_GLOBAL_ASSETS_MANAGER:
					globalAssetsManager = null;
					break;
			}
			
			super.onPlugoutComponent(component, needDispose);
		}
		
		protected function onAdvance(deltaTime:Number, suppressSafety:Boolean = false):void
		{
			__tickTimes = 0;
			__tickTime += deltaTime;

			while(__tickTime > 0 && (suppressSafety || __tickTimes < maxTicksPerFrame))
			{
				tick(tickDeltaTime);

				__tickTime -= tickDeltaTime;
				__tickTimes++;
			}
		}

		protected function onEnterFrame(event:flash.events.Event = null):void
		{
			__curTime = getTimer();
			if(__lastTime < 0)
			{
				__lastTime = __curTime;
				return;
			}
			
			onAdvance((__curTime - __lastTime) * timeScale * 0.001);

			__lastTime = __curTime;
		}
		
		protected function onCanvasStageTouch(event:TouchEvent = null):void
		{
			dispatchEvent(EVENT_CANVAS_STAGE_TOUCH, event);
		}
		
		protected function onStageResize(event:ResizeEvent = null):void
		{
			stageWidth = event.width;
			stageHeight = event.height;

			dispatchEvent(EVENT_STAGE_RESIZE);
		}
		
		override protected function onInit():void
		{
			debugGraphics = Starling.current.nativeOverlay.graphics;

			var sStage:Stage = Starling.current.stage;
			
			__canvasStage = new CanvasStage();
			__canvasStage.addEventListener(TouchEvent.TOUCH, __onCanvasStageTouchCallback);

			stageWidth = sStage.stageWidth;
			stageHeight = sStage.stageHeight;

			super.onInit();

            if(camera)
            {
                camera.init();
                camera.active();
            }
			
			if(rootGameObject)
			{
				rootGameObject.init();
				rootGameObject.active();
			}
			
			Starling.current.stage.addEventListener(ResizeEvent.RESIZE, __onStageResizeCallback);
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);

            if(camera && camera.__alive && camera.tickable)
            {
                camera.tick(deltaTime);
            }

			if(rootGameObject && rootGameObject.__alive && rootGameObject.tickable)
			{
				rootGameObject.tick(deltaTime);
			}
		}
		
		public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			//displayDraw.
			if(camera && camera.__alive && camera.visible)
			{
				dispatchEvent(EVENT_PRE_DRAW);
				camera.draw(support, parentAlpha);
				dispatchEvent(EVENT_AFTER_DRAW);
			}

			//debug draw.
			if(CrocoEngine.debug)
			{
				CrocoEngine.debugGraphics.clear();
				__onDebugDrawCallback();
				CrocoEngine.debugGraphics.endFill();
			}
		}
		
		override public function onDebugDraw():void
		{
			super.onDebugDraw();
			
			if(camera && camera.__alive && camera.debug)
			{
				camera.__onDebugDrawCallback();
			}
			
			if(rootGameObject && rootGameObject.__alive && rootGameObject.debug)
			{
				rootGameObject.__onDebugDrawCallback();
			}
		}
		
		public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(camera && camera.__alive)
			{
				return camera.hitTest(localPoint, forTouch);
			}
			
			return null;
		}
		
		override public function dispose():void
		{
			super.dispose();

			__onAdvanceCallback = null;
			__onStartEngineCallback = null;
			__onStopEngineCallback = null;
			__onEnterFrameCallback = null;
			__onCanvasStageTouchCallback = null;
			__onStageResizeCallback = null;

			if(__canvasStage)
			{
				__canvasStage.removeFromParent();
				__canvasStage.removeEventListener(TouchEvent.TOUCH, __onCanvasStageTouchCallback);
				__canvasStage.dispose();
				__canvasStage = null;
			}
			
			if(camera)
			{
				camera.dispose();
				camera = null;
			}
			
			if(rootGameObject)
			{
				rootGameObject.dispose();
				rootGameObject = null;
			}
			
			//just clear the reference.
			inputManager = null;
			soundManager = null;
			globalAssetsManager = null;
		}
		
		override public function toString():String
		{
			var results:String = super.toString() + "\n" +
				"CrocoEngine::timeScale: " + CrocoEngine.timeScale + "\n" +
				"CrocoEngine::debug: " + CrocoEngine.debug + "\n" +
				"CrocoEngine::tickDeltaTime: " + CrocoEngine.tickDeltaTime + "\n" +
				"CrocoEngine::maxTicksPerFrame: " + CrocoEngine.maxTicksPerFrame + "\n" +
				"CrocoEngine::running: " + CrocoEngine.__running + "\n" +
				"CrocoEngine::tickTime: " + CrocoEngine.__tickTime + "\n" +
				"CrocoEngine::tickTimes: " + CrocoEngine.__tickTimes + "\n" +
				"CrocoEngine::curTime: " + CrocoEngine.__curTime + "\n" +
				"CrocoEngine::lastTime: " + CrocoEngine.__lastTime;

			return results;
		}
	}
}


import com.croco2d.CrocoEngine;

import flash.geom.Point;

import starling.core.RenderSupport;
import starling.display.DisplayObject;

final internal class CanvasStage extends DisplayObject
{
	public function CanvasStage()
	{
		super();
	}
	
	override public function render(support:RenderSupport, parentAlpha:Number):void
	{
		CrocoEngine.instance.draw(support, parentAlpha * alpha);
	}
	
	override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
	{
		return CrocoEngine.instance.hitTest(localPoint, forTouch);
	}
}