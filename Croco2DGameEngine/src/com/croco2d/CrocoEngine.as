package com.croco2d
{
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.core.CrocoCamera;
	import com.croco2d.core.CrocoGameObject;
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.CrocoObjectEntity;
	import com.croco2d.input.InputManager;
	import com.croco2d.sound.SoundManager;
	import com.fireflyLib.utils.GlobalPropertyBag;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	public class CrocoEngine extends CrocoObjectEntity
	{
		/** The version of the Engine. */
		public static const VERSION:String = "0.0.1";
		
		//Events.		
		public static const EVENT_START_ENGINE:String = "startEngine";
		public static const EVENT_STOP_ENGINE:String = "stopEngine";
		
		public static var instance:CrocoEngine;
		
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
		 *  u can consider the rootGameObject as Scene.
		 */		
		public static var rootGameObject:CrocoGameObject;
		
		/**
		 * If the game should stop updating/rendering.
		 */
		public static var __running:Boolean = false;
		
		public static var __tickTime:Number = 0.0;
		
		public static var __tickTimes:int = 0;
		
		public static var __curTime:int = -1;
		
		public static var __lastTime:int = -1;

		//helper for reference.
		public static var camera:CrocoCamera;
		public static var inputManager:InputManager;
		public static var soundManager:SoundManager;
		public static var globalAssetsManager:CrocoAssetsManager;

		public static var debugGraphics:Graphics;
		
		public static function hasPluginComponent(pluginName:String):Boolean
		{
			return instance.hasPluginComponent(pluginName);
		}
		
		public static function findPluinComponent(pluginName:String):*
		{
			return instance.findPluinComponent(pluginName);
		}
		
		public static function findStaticPropertity(key:String):*
		{
			return engineCls[key];
		}
		
		//----------------------------------------------------------------------
		
		public var __onAdvanceCallback:Function = onAdvance;
		public var __onStartEngineCallback:Function = onStartEngine;
		public var __onStopEngineCallback:Function = onStopEngine;
		public var __onEnterFrameHandlerCallback:Function = onEnterFrameHandler;
		
		public function CrocoEngine()
		{
			super();
			
			if(instance) throw new Error("CrocoEngine is a singleton mode Class!");
			instance = this;
			
			this.name = AppConfig.KEY_CROCO_ENGINE;
			this.eventEnable = true;
		}
		
		public final function start():void 
		{ 
			if(__running) return;
			
			__running = true;
			
			__onStartEngineCallback();
		}
		
		protected function onStartEngine():void
		{
			__lastTime = -1;
			GlobalPropertyBag.stage.addEventListener(Event.ENTER_FRAME, __onEnterFrameHandlerCallback);
			
			if(eventEnable && eventEmitter.hasEventListener(EVENT_START_ENGINE))
			{
				eventEmitter.dispatchEvent(EVENT_START_ENGINE);
			}
		}
		
		public final function stop():void 
		{ 
			if(!__running) return;
			
			__running = false;
			
			__onStopEngineCallback();
		}
		
		protected function onStopEngine():void
		{
			GlobalPropertyBag.stage.removeEventListener(Event.ENTER_FRAME, __onEnterFrameHandlerCallback);
			
			if(eventEnable && eventEmitter.hasEventListener(EVENT_STOP_ENGINE))
			{
				eventEmitter.dispatchEvent(EVENT_STOP_ENGINE);
			}
		}
		
		public final function get running():Boolean
		{ 
			return __running;
		}
		
		public function advance(elapsedTime:Number):void
		{
			__onAdvanceCallback(elapsedTime * timeScale, true);
		}
		
		override protected function onPluginComponent(component:CrocoObject):void
		{
			super.onPluginComponent(component);
			
			switch(component.name)
			{
				case AppConfig.KEY_CAMERA:
					camera = CrocoCamera(component);
					break;
				
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
				case AppConfig.KEY_CAMERA:
					camera = null;
					break;
				
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

		protected function onEnterFrameHandler(event:Event):void
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
		
		override protected function onInit():void
		{
			debugGraphics = Starling.current.nativeOverlay.graphics;
			
			super.onInit();
		}
		
		override public function tick(deltaTime:Number):void
		{
			if(rootGameObject && rootGameObject.__alive && rootGameObject.tickable)
			{
				rootGameObject.tick(deltaTime);
			}
			
			super.tick(deltaTime);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			rootGameObject = null;
			
			//just clear the reference.
			camera = null;
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