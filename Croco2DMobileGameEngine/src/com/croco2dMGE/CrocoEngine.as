package com.croco2dMGE
{
	import com.croco2dMGE.core.CrocoBasic;
	import com.croco2dMGE.core.CrocoListGroup;
	import com.croco2dMGE.input.InputManager;
	import com.croco2dMGE.sound.SoundManager;
	import com.croco2dMGE.world.SceneCamera;
	import com.fireflyLib.utils.GlobalPropertyBag;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	
	public class CrocoEngine extends CrocoListGroup
	{
		/**
		 * The game current width.
		 */
		public static var width:uint = 0;
		
		/**
		 * The game current height
		 */
		public static var height:uint = 0;
		
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
		
		public static var debugGraphics:Graphics = null;
		
		/**
		 * By default this just refers to the first entry in the cameras array
		 * declared above, but you can do what you like with it.
		 */
		public static var camera:SceneCamera;
		
		public static var input:InputManager;
		
		public static var soundManager:SoundManager;
		
		public static var crocoStarling:Starling;
		
		/**
		 * The rate at which ticks are fired, in seconds.
		 */
		public static var tickDeltaTime:Number = 1.0 / 60;
		
		public static var maxTicksPerFrame:int = 5;
		
		/**
		 * Framerate of the Flash player (NOT the game loop). Default = 30.
		 */
		public static var instance:CrocoEngine;
		
		public static var deltaTime:Number = 0.0;
		
		/**
		 * If the game should stop updating/rendering.
		 */
		protected static var mRunning:Boolean = false;
		
		protected static var mTickTime:Number = 0.0;
		
		/**
		 *  StartUp The Engine, we can pass value to the Engine through the config.
		 * eg. {stage:stage, screenRoot:screenRoot, width:XX, height:XX}
		 * 
		 * @param config
		 * @param crocoEngineImplCls
		 * 
		 */		
		public static function startUp(flashStage:flash.display.Stage, crocoStarling:Starling, 
									   width:uint, height:uint,
									   startUpParams:Object = null,
									   startUpExtensions:Object = null,
									   crocoEngineImplCls:Class = null):CrocoEngine
		{
			if(instance) throw new Error("CrocoEngine::static method 'startUp': CrocoEngine is a singleton mode Class!");
			
			if (!flashStage  || !crocoStarling) throw new ArgumentError("Stage must not be null");
			
			GlobalPropertyBag.stage = flashStage;
			
			//default setting
			CrocoEngine.crocoStarling = crocoStarling;
			
			CrocoEngine.width = width;
			CrocoEngine.height = height;
			
			//you can extend the CrocoEngin and override the default engine logic
			crocoEngineImplCls ||= CrocoEngine;
			instance = new crocoEngineImplCls();

			var key:String;
			for(key in startUpParams)
			{
				crocoEngineImplCls[key] = startUpParams[key];
			}
			
			instance.init();
			
			for each(var extension:CrocoBasic in startUpExtensions)
			{
				instance.addItem(extension);
			}
			
			trace("[CrocoEngine] startUp Complete.")
			
			return instance;
		}
		
		//======================================================================
		
		public function CrocoEngine()
		{
			super();
			
			this.name = AppConfig.KEY_CROCO_ENGINE;
		}
		
		public function start():void 
		{ 
			if(mRunning) return;
			
			mRunning = true;
			
			mLastTime = -1;
			
			GlobalPropertyBag.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function stop():void 
		{ 
			if(!mRunning) return;
			
			mRunning = false;
			
			GlobalPropertyBag.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function get running():Boolean
		{ 
			return mRunning;
		}
		
		override protected function onInit():void
		{
			addItem(camera ||= new SceneCamera());
			addItem(input ||= new InputManager());
			addItem(soundManager ||= new SoundManager());
			
			if(debug && !debugGraphics)
			{
				var shape:Shape = new Shape();
				GlobalPropertyBag.stage.addChild(shape);
				debugGraphics = shape.graphics;
			}
		}
		
		public function advance(elapsedTime:Number):void
		{
			onAdvance(elapsedTime * timeScale, true);
		}
		
		protected function onAdvance(deltaTime:Number, suppressSafety:Boolean = false):void
		{
			if(debug)
			{
				debugGraphics.clear();
			}
			
			CrocoEngine.deltaTime = deltaTime;
			crocoStarling.advanceTime(deltaTime);
			
//			gaming ticking.
			mTickTime += deltaTime;
			var tickCount:int = 0;
			while(mTickTime > 0 && (suppressSafety || tickCount < maxTicksPerFrame))
			{
				tick(tickDeltaTime);
				
				mTickTime -= tickDeltaTime;
				tickCount++;
//				trace(mTickTime, tickCount, maxTicksPerFrame);
			}
			
			//game rendering.
			crocoStarling.render();
			
			if(debug)
			{
				debugGraphics.endFill();
			}
		}
		
		protected static var mLastTime:int = -1;
		
		protected function enterFrameHandler(event:Event):void
		{
			var currentTime:int = getTimer();
			if(mLastTime < 0)
			{
				mLastTime = currentTime;
				return;
			}
			
			onAdvance((currentTime - mLastTime) * 0.001 * timeScale);
			mLastTime = currentTime;
		}
	}
}