package com.croco2d
{
	import com.croco2d.core.croco_internal;
	import com.croco2d.screens.CrocoScreenNavigator;
	import com.croco2d.screens.IBootStrapScreen;
	import com.fireflyLib.utils.GlobalPropertyBag;
	import com.fireflyLib.utils.ObjectFactoryUtil;
	import com.llamaDebugger.Logger;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	import feathers.controls.ScreenNavigatorItem;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;

	[Event(name="bootStrapComplete", type="flash.events.Event")]
	public class AppBootStrap extends Sprite
	{
		public static const EVENT_BOOT_STRAP_COMPLETE:String = "bootStrapComplete";
		
		public var appConfigCls:Class = AppConfig;
		
		public var __starling:Starling;
		public var __crocoEngine:CrocoEngine;
		public var __starlingRoot:CrocoScreenNavigator;

		//will dispose after bootStrap complete.
		public var __bootStrapScreen:IBootStrapScreen;
		public var __defaultEntryScreenConfig:Object;
		
		public function AppBootStrap()
		{
			super();
			
			GlobalPropertyBag.stage = stage;
			GlobalPropertyBag.write(AppConfig.KEY_APPBOOTSTRAP, this);
			
			//default
			this.visible = this.mouseEnabled = this.mouseChildren = false;
			this.addEventListener(Event.ADDED_TO_STAGE, firstAddToStageHandler);
		}

		//pre init part befor starling created.
		//----------------------------------------------------------------------
		
		private function firstAddToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, firstAddToStageHandler);
			
			croco_internal::preInit();
			
			//listen the event for the whole bootstap process has completed.
			this.addEventListener(EVENT_BOOT_STRAP_COMPLETE, appBootStrapCompleteHandler);
		}
		
		//this is init process logic u'd better don't modify it. 
		//this is first init, there will be another init after the staling root created.
		croco_internal function preInit():void
		{
			const preInitCallbackConfig:Object = AppConfig.systemCallbackConfig.preInitCallbackConfig;
			
			//step 1.
			onAppPreInit();
			if(preInitCallbackConfig.onAppPreInitedCallback)
			{
				preInitCallbackConfig.onAppPreInitedCallback.call(null);
			}

			//step 2.
			onGlobalObjectsInit();
			if(preInitCallbackConfig.onGlobalObjectsInitedCallback)
			{
				preInitCallbackConfig.onGlobalObjectsInitedCallback.call(null);
			}
			
			//step 3.
			onStarlingInit();
			if(preInitCallbackConfig.onStarlingInitedCallback)
			{
				preInitCallbackConfig.onStarlingInitedCallback.call(null);
			}
			
			//step 4.the preInit last step.
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
			ObjectFactoryUtil.newInstance(appConfigCls, 
				null, 
				null, 
				{
					appBootStrap:this
				});
			
			//default setting
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			const globalParamsConfig:Object = AppConfig.globalParamsConfig;
			
			stage.color = globalParamsConfig.backgroundColor;
			stage.frameRate = globalParamsConfig.frameRate;
			
			if(globalParamsConfig.startupLogger)
			{
				Logger.startup();
			}
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, appActivateHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, appDeactivateHandler);
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function onGlobalObjectsInit():void
		{
			Logger.info("onGlobalObjectsInit");
			
			const globalObjectsConfig:Array = AppConfig.globalObjectsConfig;
			var n:int = globalObjectsConfig.length;
			if(n > 0)
			{
				var extentionConfigItem:Object;
				var extentionItem:Object;
				for(var i:int = 0; i < n; i++)
				{
					extentionConfigItem = globalObjectsConfig[i];
					
					extentionItem = ObjectFactoryUtil.newInstanceFromConfig(extentionConfigItem);
					
					GlobalPropertyBag.write(extentionConfigItem.key, extentionItem);
				}
			}
		}
		
		protected function onStarlingInit():void
		{
			Logger.info("onStarlingInit");

			const starlingConfig:Object = AppConfig.starlingConfig;
			__starling = ObjectFactoryUtil.newInstanceFromConfig(starlingConfig);
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
			
			__starlingRoot = __starling.root as CrocoScreenNavigator;
			__starling.addEventListener("context3DCreate", starlingContextCreatedHandler);
			
			croco_internal::init();
		}
		
		//this is init process logic u'd better don't modify it. 
		//this is second init, here will init something whitch based starling.
		croco_internal function init():void
		{
			const initCallbackConfig:Object = AppConfig.systemCallbackConfig.initCallbackConfig;
			
			//step 5.
			onAppInit();
			if(initCallbackConfig.onAppInitedCallback)
			{
				initCallbackConfig.onAppInitedCallback.call(null);
			}
			
			//step 6.
			onFeathersInit();
			if(initCallbackConfig.onFeathersInitedCallback)
			{
				initCallbackConfig.onFeathersInitedCallback.call(null);
			}
			
			//step 7.
			onBootStrapScreenInit();
			if(initCallbackConfig.onBootStrapScreenInitedCallback)
			{
				initCallbackConfig.onBootStrapScreenInitedCallback.call(null);
			}

			//step 8.
			onScreensInit();
			if(initCallbackConfig.onScreensInitedCallback)
			{
				initCallbackConfig.onScreensInitedCallback.call(null);
			}
			
			//step 9.
			onCrocoEngineInit();
			if(initCallbackConfig.onCrocoEngineInitedCallback)
			{
				initCallbackConfig.onCrocoEngineInitedCallback.call(null);
			}

			//step 10.
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
			
			//step 11.
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
			
			ObjectFactoryUtil.newInstance(feathersConfig);
		}

		protected function onBootStrapScreenInit():void
		{
			Logger.info("onBootStrapScreenInit");
			
			const bootStrapSceenConfig:Object = AppConfig.bootStrapSceenConfig;
			__bootStrapScreen = ObjectFactoryUtil.newInstanceFromConfig(bootStrapSceenConfig) as IBootStrapScreen;
			
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
		
		protected function onScreensInit():void
		{
			Logger.info("onScreensInit");
			
			var screensConfig:Array = AppConfig.screensConfig;
			var n:int = screensConfig ? screensConfig.length : 0;
			
			var screenNavigatorItem:ScreenNavigatorItem;
			var screenConfig:Object;
			
			for(var i:int = 0; i < n; i++)
			{
				screenConfig = screensConfig[i];
				
				screenNavigatorItem = ObjectFactoryUtil.newInstanceFromConfig(screenConfig);
				
				__starlingRoot.addScreen(screenConfig[AppConfig.KEY_SCREEN_ID], screenNavigatorItem);
				
				//default is first one config setting.
				if(i == 0) 
				{
					__defaultEntryScreenConfig = screenConfig;
				}
			}
		}
		
		protected function onCrocoEngineInit():void
		{
			Logger.info("onCrocoEngineInit");
			
			const crocoEngineConfig:Object = AppConfig.crocoEngineConfig;
			__crocoEngine = ObjectFactoryUtil.newInstanceFromConfig(crocoEngineConfig);
			__crocoEngine.init();
			__crocoEngine.active();
			GlobalPropertyBag.write(AppConfig.KEY_CROCO_ENGINE, __crocoEngine);
			
			__crocoEngine.start();
		}
		
		protected function checkIsNeedAppAssetsPreload():Boolean
		{
			var preloadFile:File = File.applicationDirectory.resolvePath(AppConfig.PATH_PRELOAD_URL);
			return preloadFile.exists;
		}
		
		protected function onAppAssetsPreloadInit():void
		{
			Logger.info("onAppAssetsPreload");
			
			var appPreLoadAssetsFile:File = File.applicationDirectory.resolvePath(AppConfig.PATH_PRELOAD_URL);
			CrocoEngine.globalAssetsManager.enqueue(appPreLoadAssetsFile);
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
			const globalParamsConfig:Object = AppConfig.globalParamsConfig;
			if(__crocoEngine) 
			{
				if(globalParamsConfig.pauseEngineWhenDeActivated)
				{
					__crocoEngine.stop();
				}
			}
			if(__starling) 
			{
				if(globalParamsConfig.pauseRenderingWhenDeActivated)
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
			const globalParamsConfig:Object = AppConfig.globalParamsConfig;
			
			if(__crocoEngine) 
			{
				if(globalParamsConfig.pauseEngineWhenDeActivated)
				{
					__crocoEngine.start();
				}
			}
			if(__starling) 
			{
				if(globalParamsConfig.pauseRenderingWhenDeActivated)
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
			if(__starling)
			{
				updateStarlingViewPort();
			}
		}
		
		protected function updateStarlingViewPort():void
		{
			var viewPortX:Number = 0;
			var viewPortY:Number = 0;
			var viewPortWidth:Number = 0;
			var viewPortHeight:Number = 0;
			
			const globalParamsConfig:Object = AppConfig.globalParamsConfig;
			
			var deviceWidth:int = stage.stageWidth;
			var deviceHeight:int = stage.stageHeight;
			
			var designWidth:int = globalParamsConfig.designWidth || deviceWidth;
			var desighHeight:int = globalParamsConfig.designHeight || deviceHeight;
			
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
			
			//step 12.
			onAppBootStrapComplete();
			const systemEventCallbackConfig:Object = AppConfig.systemCallbackConfig;
			if(systemEventCallbackConfig.onAppBootStrapCompletedCallback != null)
			{
				systemEventCallbackConfig.onAppBootStrapCompletedCallback.call(null);
			}
			
			//step 13.
			onAppBootStrapCompletedThenReady2EntryScreen();
			
			//step 14.
			onAppBootStrapCompletedAndClearSomethingsBefor();
		}
		
		protected function onAppBootStrapComplete():void
		{
			Logger.info("onAppBootStrapComplete");
		}
		
		protected function onAppBootStrapCompletedThenReady2EntryScreen():void
		{
			Logger.info("onAppBootStrapCompletedThenReady2GoEntryScreen");
			
			const systemEventCallbackConfig:Object = AppConfig.systemCallbackConfig.systemEventCallbackConfig;
			if(systemEventCallbackConfig.onAppBootStrapEntryScreenCallback != null)
			{
				__defaultEntryScreenConfig = systemEventCallbackConfig.onAppBootStrapEntryScreenCallback.call(null, __defaultEntryScreenConfig); 
			}
			
			var entryScreenId:String = __defaultEntryScreenConfig[AppConfig.KEY_SCREEN_ID];
			var targetScreenProprotity:Object = __defaultEntryScreenConfig.constructorParams[2];
			var entryScreenData:Object = targetScreenProprotity[AppConfig.KEY_ENTRY_SCREEN_DATA];
			
			__starlingRoot.jumToScreen(entryScreenId, entryScreenData);
			__defaultEntryScreenConfig = null;
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