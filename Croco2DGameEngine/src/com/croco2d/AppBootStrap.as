package com.croco2d 
{
	import com.croco2d.core.croco_internal;
	import com.croco2d.screens.CrocoScreenNavigator;
	import com.croco2d.screens.IBootStrapScreen;
	import com.fireflyLib.utils.GlobalPropertyBag;
	import com.fireflyLib.utils.JsonObjectFactorUtil;
	import com.fireflyLib.utils.ObjectFactoryUtil;
	import com.llamaDebugger.Logger;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import feathers.controls.ScreenNavigatorItem;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;

	[Event(name="bootStrapComplete", type="flash.events.Event")]
	public class AppBootStrap extends Sprite
	{
		public static const EVENT_BOOT_STRAP_COMPLETE:String = "bootStrapComplete";
		
		protected var appConfigCls:Class = AppConfig;
		
		public var __starling:Starling;
		public var __crocoEngine:CrocoEngine;
		public var __screenNavigator:CrocoScreenNavigator;

		//will dispose after bootStrap complete.
		public var __bootStrapScreen:IBootStrapScreen;
		
		public function AppBootStrap()
		{
			super();
			
			GlobalPropertyBag.stage = stage;
			GlobalPropertyBag.write(AppConfig.KEY_APPBOOTSTRAP, this);
			
			//default
//			this.visible = this.mouseEnabled = this.mouseChildren = false;
			this.addEventListener(Event.ADDED_TO_STAGE, firstAddToStageHandler);
		}

		//pre init part befor starling created.
		//----------------------------------------------------------------------
		
		private function firstAddToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, firstAddToStageHandler);
			
			//listen the event for the whole bootstap process has completed.
			this.addEventListener(EVENT_BOOT_STRAP_COMPLETE, appBootStrapCompleteHandler);
			
			croco_internal::preInit();
		}
		
		//this is init process logic u'd better don't modify it. 
		//this is first init, there will be another init after the staling root created.
		croco_internal function preInit():void
		{
			const preInitCallbackConfig:Object = AppConfig.systemCallbackConfig.preInitCallbackConfig;
			
			onAppPreInit();
			if(preInitCallbackConfig.onAppPreInitedCallback)
			{
				preInitCallbackConfig.onAppPreInitedCallback.call(null);
			}

			globalPropertyBagInit();
			if(preInitCallbackConfig.onGlobalPropertyBagInitedCallback)
			{
				preInitCallbackConfig.onGlobalPropertyBagInitedCallback.call(null);
			}
			
			onStarlingInit();
			if(preInitCallbackConfig.onStarlingInitedCallback)
			{
				preInitCallbackConfig.onStarlingInitedCallback.call(null);
			}
			
			//the preInit last step.
			onAppPreInitComplete();
			if(preInitCallbackConfig.onAppPreInitCompletedCallback != null)
			{
				preInitCallbackConfig.onAppPreInitCompletedCallback.call(null);
			}
		}
		
		protected function onAppPreInit():void
		{
			Logger.info("onAppPreInit");
			
			//the appConfigConfig the before all.
			ObjectFactoryUtil.create(appConfigCls, 
				null, 
				null, 
				{
					appBootStrap:this
				});
			
			//default setting
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			const globalEvnConfig:Object = AppConfig.globalEvnConfig;
			
			stage.color = globalEvnConfig.backgroundColor;
			stage.frameRate = globalEvnConfig.frameRate;
			
			if(globalEvnConfig.startupLogger) Logger.startup();
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, appActivateHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, appDeactivateHandler);

			stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function globalPropertyBagInit():void
		{
			Logger.info("globalPropertyBagInit");
			
			const globalPropertyBagConfig:Object = AppConfig.globalPropertyBagConfig;

			var jsonConfig:Object;
			var instance:Object;
			
			for(var key:String in globalPropertyBagConfig)
			{
				jsonConfig = globalPropertyBagConfig[key];
				instance = JsonObjectFactorUtil.createFromJsonConfig(jsonConfig);
				GlobalPropertyBag.write(key, instance);
			}
		}
		
		protected function onStarlingInit():void
		{
			Logger.info("onStarlingInit");

			const starlingConfig:Object = AppConfig.starlingConfig;
			__starling = JsonObjectFactorUtil.createFromJsonConfig(starlingConfig);
			GlobalPropertyBag.write(AppConfig.KEY_STARLING, __starling);
			
			__starling.addEventListener("rootCreated", starlingRootCreatedHandler);
			__starling.start();
		}
		
		protected function onAppPreInitComplete():void
		{
			Logger.info("onAppPreInitComplete");
		}
		
		//init part after starling created.
		//----------------------------------------------------------------------
		private function starlingRootCreatedHandler(event:*):void
		{
			__starling.removeEventListener("rootCreated", starlingRootCreatedHandler);
			__starling.addEventListener("context3DCreate", starlingContextCreatedHandler);
			__screenNavigator = __starling.root as CrocoScreenNavigator; 

			croco_internal::init();
		}
		
		//this is init process logic u'd better don't modify it. 
		//this is second init, here will init something whitch based starling.
		croco_internal function init():void
		{
			const initCallbackConfig:Object = AppConfig.systemCallbackConfig.initCallbackConfig;
			
			onAppInit();
			if(initCallbackConfig.onAppInitedCallback)
			{
				initCallbackConfig.onAppInitedCallback.call(null);
			}
			
			onFeathersInit();
			if(initCallbackConfig.onFeathersInitedCallback)
			{
				initCallbackConfig.onFeathersInitedCallback.call(null);
			}
			
			onBootStrapScreenInit();
			if(initCallbackConfig.onBootStrapScreenInitedCallback)
			{
				initCallbackConfig.onBootStrapScreenInitedCallback.call(null);
			}
			
			onScreensInit();
			if(initCallbackConfig.onScreensInitedCallback)
			{
				initCallbackConfig.onScreensInitedCallback.call(null);
			}
			
			onCrocoEngineInit();
			if(initCallbackConfig.onCrocoEngineInitedCallback)
			{
				initCallbackConfig.onCrocoEngineInitedCallback.call(null);
			}

			var isNeedAppAssetsPreload:Boolean = checkIsNeedAppAssetsPreload();
			if(isNeedAppAssetsPreload)
			{
				onAppAssetsPreloadInit();
				if(initCallbackConfig.onAppAssetsPreloadInitedCallback)
				{
					initCallbackConfig.onAppAssetsPreloadInitedCallback.call(null);
				}
				
				onAppAssetsPreloadStart();
				if(initCallbackConfig.onAppAssetsPreloadStartedCallback)
				{
					initCallbackConfig.onAppAssetsPreloadStartedCallback.call(null);
				}
			}
			else
			{
				if(__bootStrapScreen)
				{
					__bootStrapScreen.onAssetsPreloadProgress(1);
				}	
			}
			
			onAppInitComplete();
			if(initCallbackConfig.onAppInitCompletedCallback != null)
			{
				initCallbackConfig.onAppInitCompletedCallback.call(null);
			}
			
			//no BootStrapScreen and No preload, just go.
			if(!isNeedAppAssetsPreload && !__bootStrapScreen)
			{
				dispatchEvent(new Event(EVENT_BOOT_STRAP_COMPLETE));
			}
		}
		
		protected function onAppInit():void
		{
			Logger.info("onAppInit");
		}
		
		protected function onFeathersInit():void
		{
			Logger.info("onFeathersInit");
			
			const feathersConfig:Object = AppConfig.feathersConfig;
			
			JsonObjectFactorUtil.createFromJsonConfig(feathersConfig);
		}
		
		protected function onScreensInit():void
		{
			const screensConfig:Array = AppConfig.screensConfig;
			var n:int = screensConfig ? screensConfig.length : 0;
			
			var screenNavigatorItem:ScreenNavigatorItem;
			var screenConfig:Object;
			var screenID:String;
			
			for(var i:int = 0; i < n; i++)
			{
				screenConfig = screensConfig[i];
				screenID = screenConfig.ctorParams[2][AppConfig.KEY_SCREEN_ID];
				
				screenNavigatorItem = JsonObjectFactorUtil.createFromJsonConfig(screenConfig) as ScreenNavigatorItem;

				__screenNavigator.addScreen(screenID, screenNavigatorItem);
			}
		}

		protected function onBootStrapScreenInit():void
		{
			Logger.info("onBootStrapScreenInit");
			
			const bootStrapSceenConfig:Object = AppConfig.bootStrapSceenConfig;
			if(!bootStrapSceenConfig) return;
			
			__bootStrapScreen = JsonObjectFactorUtil.createFromJsonConfig(bootStrapSceenConfig) as IBootStrapScreen;
			
			if(__bootStrapScreen)
			{
				__bootStrapScreen.bootStrap = this;
				
				if(__bootStrapScreen is flash.display.DisplayObject)
				{
					this.stage.addChild(flash.display.DisplayObject(__bootStrapScreen));
				}
				else if(__bootStrapScreen is starling.display.DisplayObject)
				{
					this.__starling.stage.addChild(starling.display.DisplayObject(__bootStrapScreen));
				}

				__bootStrapScreen.launch();
			}
		}
		
		protected function onCrocoEngineInit():void
		{
			Logger.info("onCrocoEngineInit");
			
			const crocoEngineConfig:Object = AppConfig.crocoEngineConfig;
			__crocoEngine = JsonObjectFactorUtil.createFromJsonConfig(crocoEngineConfig);
			
			__crocoEngine.init();
			__crocoEngine.active();
			
			GlobalPropertyBag.write(AppConfig.KEY_CROCO_ENGINE, __crocoEngine);
			
			__crocoEngine.start();
		}
		
		protected function checkIsNeedAppAssetsPreload():Boolean
		{
			return AppConfig.FILE_PRELOAD_DIR.exists;
		}
		
		protected function onAppAssetsPreloadInit():void
		{
			Logger.info("onAppAssetsPreload");
			
			CrocoEngine.globalAssetsManager.enqueue(AppConfig.FILE_PRELOAD_DIR);
		}
		
		protected function onAppAssetsPreloadStart():void
		{
			Logger.info("onAppAssetsPreloadStart");
			
			CrocoEngine.globalAssetsManager.loadQueue(onAppAssetsPreloadProgress);
		}
		
		protected function onAppInitComplete():void
		{
			Logger.info("onAppInitComplete");
		}
		
		//assets preload part.
		//----------------------------------------------------------------------
		private function onAppAssetsPreloadProgress(progress:Number):void
		{
			if(progress == 1)
			{
				onAppAssetsPreloadComplete();
				const initCallbackConfig:Object = AppConfig.systemCallbackConfig.initCallbackConfig;
				if(initCallbackConfig.onAppAssetsPreloadCompletedCallback != null)
				{
					initCallbackConfig.onAppAssetsPreloadCompletedCallback.call(null);
				}

				//if there is no BootStrapScreen and progress equal 1. just go.
				//or will wait the BootStrapScreen to dispatch the event.
				if(!__bootStrapScreen)
				{
					dispatchEvent(new Event(EVENT_BOOT_STRAP_COMPLETE));
				}
			}
			
			//the BootStrapScreen also watch the progress equal 1.
			if(__bootStrapScreen)
			{
				__bootStrapScreen.onAssetsPreloadProgress(progress);
			}
		}

		protected function onAppAssetsPreloadComplete():void
		{
			Logger.info("onAppAssetsPreloadComplete");
		}
		
		//event callback part
		//----------------------------------------------------------------------
		protected function appDeactivateHandler(event:Object):void
		{
			const globalEvnConfig:Object = AppConfig.globalEvnConfig;
			if(__crocoEngine) 
			{
				if(globalEvnConfig.pauseEngineWhenDeActivated)
				{
					__crocoEngine.stop();
				}
			}
			if(__starling) 
			{
				if(globalEvnConfig.pauseRenderingWhenDeActivated)
				{
					__starling.stop();
				}
			}
			
			const systemEventCallbackConfig:Object = AppConfig.systemCallbackConfig.systemEventCallbackConfig;
			if(systemEventCallbackConfig.onAppDeActivatedCallback != null)
			{
				systemEventCallbackConfig.onAppDeActivatedCallback.call(null, event);
			}
		}

		protected function appActivateHandler(event:Object):void
		{
			const globalEvnConfig:Object = AppConfig.globalEvnConfig;
			
			if(__crocoEngine) 
			{
				if(globalEvnConfig.pauseEngineWhenDeActivated)
				{
					__crocoEngine.start();
				}
			}
			if(__starling) 
			{
				if(globalEvnConfig.pauseRenderingWhenDeActivated)
				{
					__starling.start();
				}
			}
			
			const systemEventCallbackConfig:Object = AppConfig.systemCallbackConfig.systemEventCallbackConfig;
			if(systemEventCallbackConfig.onAppActivatedCallback != null)
			{
				systemEventCallbackConfig.onAppActivatedCallback.call(null, event);
			}
		}
		
		protected function stageResizeHandler(event:Event):void
		{
			if(__starling) updateStarlingViewPort();
		}
		
		protected function updateStarlingViewPort():void
		{
			var viewPortX:Number = 0;
			var viewPortY:Number = 0;
			var viewPortWidth:Number = 0;
			var viewPortHeight:Number = 0;
			
			const globalEvnConfig:Object = AppConfig.globalEvnConfig;
			
			var deviceWidth:int = stage.stageWidth;
			var deviceHeight:int = stage.stageHeight;
			
			var designWidth:int = globalEvnConfig.designWidth || deviceWidth;
			var desighHeight:int = globalEvnConfig.designHeight || deviceHeight;
			
			var designWHRatio:Number = designWidth / desighHeight;
			var deviceWHRatio:Number = deviceWidth / deviceHeight;
			
			if(designWHRatio > deviceWHRatio)
			{
				viewPortWidth = deviceWidth;
				viewPortHeight = viewPortWidth / designWHRatio;
				
				viewPortX = 0;
				viewPortY = (deviceHeight - viewPortHeight) >> 1;
			}
			else
			{
				viewPortHeight = deviceHeight;
				viewPortWidth = viewPortHeight * designWHRatio;
				
				viewPortY = 0;
				viewPortX = (deviceWidth - viewPortWidth) >> 1;
			}
			
			var viewPort:Rectangle = __starling.viewPort;
			viewPort.setTo(viewPortX, viewPortY, viewPortWidth, viewPortHeight);
			
			__starling.stage.stageWidth = designWidth;
			__starling.stage.stageHeight = desighHeight;
			__starling.viewPort = viewPort;
		}

		private function starlingContextCreatedHandler(event:*):void
		{
			const systemEventCallbackConfig:Object = AppConfig.systemCallbackConfig.systemEventCallbackConfig;
			if(systemEventCallbackConfig.onStarlingContextLostCallback != null)
			{
				systemEventCallbackConfig.onStarlingContextLostCallback.call(null, event);
			}
		}
		
		private function appBootStrapCompleteHandler(event:Event = null):void
		{
			this.removeEventListener(EVENT_BOOT_STRAP_COMPLETE, appBootStrapCompleteHandler);
			
			onAppBootStrapComplete();
			const systemEventCallbackConfig:Object = AppConfig.systemCallbackConfig;
			if(systemEventCallbackConfig.onAppBootStrapCompletedCallback != null)
			{
				systemEventCallbackConfig.onAppBootStrapCompletedCallback.call(null);
			}
			
			onAppBootStrapCompletedThenReady2EntryScreen();
			onAppBootStrapCompletedAndClearSomethingsBefor();
		}
		
		protected function onAppBootStrapComplete():void
		{
			Logger.info("onAppBootStrapComplete");
		}
		
		protected function onAppBootStrapCompletedThenReady2EntryScreen():void
		{
			Logger.info("onAppBootStrapCompletedThenReady2GoEntryScreen");
			
			const screensConfig:Array = AppConfig.screensConfig;
			
			var defaultScreenconfig:Object = screensConfig ? screensConfig[0] : null;
			if(defaultScreenconfig)
			{
				var screenID:String = defaultScreenconfig.ctorParams[2][AppConfig.KEY_SCREEN_ID];
				__screenNavigator.jumToScreen(screenID);		
			}
			else
			{
				Logger.warn("No defualt entry screen!");
				return;
			}
		}
		
		protected function onAppBootStrapCompletedAndClearSomethingsBefor():void
		{
			Logger.info("onAppBootStrapCompletedAndClearSomethingsBefor");
			
			if(__bootStrapScreen)
			{
				if(__bootStrapScreen is flash.display.DisplayObject)
				{
					this.stage.removeChild(flash.display.DisplayObject(__bootStrapScreen));
				}
				else if(__bootStrapScreen is starling.display.DisplayObject)
				{
					this.__starling.stage.removeChild(starling.display.DisplayObject(__bootStrapScreen));
				}

				__bootStrapScreen.dispose();
				__bootStrapScreen = null;
			}
		}
	}
}