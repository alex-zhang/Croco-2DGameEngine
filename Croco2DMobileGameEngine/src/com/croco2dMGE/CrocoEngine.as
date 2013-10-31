package com.croco2dMGE
{
	import com.croco2dMGE.core.CrocoListGroup;
	import com.croco2dMGE.world.SceneCamera;
	import com.fireflyLib.core.SystemGlobal;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.Stage;
	
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
		
		public static var flashStage:flash.display.Stage;
		public static var starlingStage:starling.display.Stage;
		
		public static var crocoStarling:Starling;
		
		public static var data:Object;
		
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
									   startUpConfig:Object = null,
									   data:Object = null, 
									   crocoEngineImplCls:Class = null):CrocoEngine
		{
			if(instance) throw new Error("CrocoEngine::static method 'startUp': CrocoEngine is a singleton mode Class!");
			if (!flashStage  || !crocoStarling) throw new ArgumentError("Stage must not be null");
			
			SystemGlobal.stage = flashStage;
			
			//default setting
			CrocoEngine.crocoStarling = crocoStarling;
			CrocoEngine.flashStage = flashStage;
			CrocoEngine.starlingStage = crocoStarling.stage;
			
			CrocoEngine.width = width;
			CrocoEngine.height = height;
			CrocoEngine.data = data;
			
			//you can extend the CrocoEngin and override the default engine logic
			crocoEngineImplCls ||= CrocoEngine;
			instance = new crocoEngineImplCls();

			for(var key:String in startUpConfig)
			{
				crocoEngineImplCls[key] = startUpConfig[key];
			}
			
			instance.init();
			
			trace("[CrocoEngine] startUp Complete.")
			
			return instance;
		}
		
		//======================================================================
		
		public function CrocoEngine()
		{
			super();
			
			this.name = "CrocoEngine";
		}
		
		public function start():void 
		{ 
			if(mRunning) return;
			
			mRunning = true;
			
			lastTime = -1;
			
			flashStage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function stop():void 
		{ 
			if(!mRunning) return;
			
			mRunning = false;
			
			flashStage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function get running():Boolean 
		{ 
			return mRunning;
		}
		
		override protected function onInit():void
		{
			addItem(camera ||= new SceneCamera());
			
			if(debug && !debugGraphics)
			{
				var shape:Shape = new Shape();
				SystemGlobal.stage.addChild(shape);
				debugGraphics = shape.graphics;
			}
		}
		
		public function advance(elapsedTime:Number):void
		{
			onAdvance(elapsedTime * timeScale, true);
		}
		
		protected function onAdvance(deltaTime:Number, suppressSafety:Boolean = false):void
		{
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
			if(debug)
			{
				debugGraphics.clear();
				crocoStarling.render();
				debugGraphics.endFill();
			}
			else
			{
				crocoStarling.render();
			}
		}
		
		protected static var lastTime:int = -1;
		
		protected function enterFrameHandler(event:Event):void
		{
			var currentTime:int = getTimer();
			if(lastTime < 0)
			{
				lastTime = currentTime;
				return;
			}
			
			onAdvance((currentTime - lastTime) * 0.001 * timeScale);
			
			lastTime = currentTime;
		}
	}
}