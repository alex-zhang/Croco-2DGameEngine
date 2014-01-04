package com.croco2dMGE
{
	import com.croco2dMGE.core.croco_internal;
	import com.croco2dMGE.screens.CrocoScreenNavigator;
	import com.croco2dMGE.screens.CrocoScreenNavigatorItem;
	import com.croco2dMGE.screens.IBootStrapScreen;
	import com.croco2dMGE.utils.assets.CrocoAssetsManager;
	import com.fireflyLib.debug.Logger;
	import com.fireflyLib.utils.ClassFactory;
	import com.fireflyLib.utils.GlobalPropertyBag;
	import com.fireflyLib.utils.PropertyBag;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;

	[Event(name="bootStrapComplete", type="flash.events.Event")]
	
	public class AppBootStrap extends Sprite
	{
		public static const BOOT_STRAP_COMPLETE:String = "bootStrapComplete";
		
		protected var mStarling:Starling;
		protected var mCrocoEngine:CrocoEngine;
		
		protected var mStarlingRoot:CrocoScreenNavigator;

		//will dispose after bootStrap complete.
		protected var mBootStrapScreen:IBootStrapScreen;
		
		protected var mDefaultEntryScreenName:String;
		protected var mDefaultebtryScreenNavigatorItem:CrocoScreenNavigatorItem;;
		
		public function AppBootStrap()
		{
			super();
			
			GlobalPropertyBag.stage = stage;
			
			//default
			this.visible = this.mouseEnabled = this.mouseChildren = false;
			
			onBootStrapConfigInit();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		protected function onBootStrapConfigInit():void 
		{
			new AppConfig(this);
		}
		
		//pre init part befor starling created.
		//----------------------------------------------------------------------
		
		private function addToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			//listen the event for the whole bootstap process has completed.
			this.addEventListener(BOOT_STRAP_COMPLETE, appBootStrapCompleteHandler);
			
			croco_internal::preInit();
		}
		
		//this is init process logic u'd better don't modify it. 
		//this is first init, there will be another init after the staling root created.
		croco_internal function preInit():void
		{
			onPreInit();
			
			if(AppConfig.bootStrapSceen && AppConfig.bootStrapSceen.cls) onBootStrapScreenInit();
			
			onStarlingInit();
			
			if(AppConfig.onAppPreInitdCallback != null)
			{
				AppConfig.onAppPreInitdCallback.call(null, this);
			}
		}
		
		protected function onPreInit():void
		{
			Logger.info(this, "onPreInit");
			
			//stage default setting
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.color = AppConfig.backgroundColor;
			stage.frameRate = AppConfig.frameRate;
			
			if(!CrocoEngine.debug)
			{
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, appActivateHandler);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, appDeactivateHandler);
			}
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function onBootStrapScreenInit():void
		{
			Logger.info(this, "onBootStrapScreenInit");
			
			mBootStrapScreen = ClassFactory.classInstance(AppConfig.bootStrapSceen.cls);
			
			mBootStrapScreen.bootStrap = this;
			
			if(mBootStrapScreen is DisplayObject)
			{
				this.stage.addChild(DisplayObject(mBootStrapScreen));
			}
			
			mBootStrapScreen.launch(AppConfig.bootStrapSceen);
		}
		
		protected function onStarlingInit():void
		{
			Logger.info(this, "onStarlingInit");
			
			//config
			Starling.handleLostContext = AppConfig.starlingHandleLostContext;
			Starling.multitouchEnabled = AppConfig.starlingMultitouchEnabled;
			
			mStarling = new Starling(AppConfig.starlingRootClass, 
				stage, 
				null,
				stage.stage3Ds[0],
				"auto", 
				AppConfig.starlingProfile);
			
			mStarling.addEventListener("rootCreated", starlingRootCreatedHandler);
			mStarling.start();
		}
		
		//init part after starling created.
		//----------------------------------------------------------------------
		
		private function starlingRootCreatedHandler(event:*):void
		{
			mStarling.removeEventListener("rootCreated", starlingRootCreatedHandler);
			mStarling.addEventListener("context3DCreate", starlingContextCreatedHandler);
			
			croco_internal::init();
		}
		
		//this is init process logic u'd better don't modify it. 
		//this is second init, here will init something whitch based starling.
		croco_internal function init():void
		{
			mStarlingRoot = mStarling.root as CrocoScreenNavigator;
			
			onInit();
			
			onFeathersInit();
			
			onCrocoEngineInit();
			
			onScreenNavigatorInit();
			
			onExtentionsInit();
			
			if(AppConfig.onAppInitdCallback != null)
			{
				AppConfig.onAppInitdCallback.call(null, this);
			}

			//--
			//pre load.
			var isNeedAppAssetsPreload:Boolean = checkIsNeedAppAssetsPreload();
			if(isNeedAppAssetsPreload) 
			{
				onAppAssetsPreloadInit();
			}
			
			//-----
			
			//no BootStrapScreen and No preload, just go.
			if(!isNeedAppAssetsPreload && !mBootStrapScreen)
			{
				dispatchEvent(new Event(BOOT_STRAP_COMPLETE));	
			}
		}
		
		protected function onInit():void
		{
			Logger.info(this, "onInit");
		}
		
		protected function onFeathersInit():void
		{
			Logger.info(this, "onFeathersInit");
			
			if(AppConfig.feathersThemeClass)
			{
				new AppConfig.themeClass();
			}
		}
		
		protected function onCrocoEngineInit():void
		{
			Logger.info(this, "onCrocoEngineInit");
			
			mCrocoEngine = CrocoEngine.startUp(stage, 
				mStarling, 
				AppConfig.designWidth, 
				AppConfig.designHeight);
			mCrocoEngine.start();
		}
		
		protected function onScreenNavigatorInit():void
		{
			Logger.info(this, "onScreenNavigatorInit");
			
			var screens:Array = AppConfig.screens;
			
			var screenNavigatorItem:CrocoScreenNavigatorItem;
			var screenItem:Object;
			
			var n:int = screens ? screens.length : 0;
			
			for(var i:int = 0; i < n; i++)
			{
				screenItem = screens[i];
				
				screenNavigatorItem = new CrocoScreenNavigatorItem(screenItem.cls, 
					screenItem.events, 
					screenItem.props, 
					screenItem.blackBoard);
				
				mStarlingRoot.addScreen(screenItem.name, screenNavigatorItem);
				
				//default is first one config setting.
				if(i == 0) 
				{
					mDefaultEntryScreenName = screenItem.name;
					mDefaultebtryScreenNavigatorItem = screenNavigatorItem;
				}
			}
		}
		
		protected function onExtentionsInit():void
		{
			Logger.info(this, "onExtentionsInit");
			
			var extentions:Array = AppConfig.extentions;
			
			var extentionItem:Object;
			
			var n:int = extentions ? extentions.length : 0;
			for(var i:int = 0; i < n; i++)
			{
				extentionItem = extentions[i];
				
				GlobalPropertyBag.write(extentionItem.name, 
					ClassFactory.classInstance(extentionItem.cls, 
						extentionItem.clsParms));
			}
		}
		
		//assets preload part.
		//----------------------------------------------------------------------
		
		protected function checkIsNeedAppAssetsPreload():Boolean
		{
			var preloadFile:File = File.applicationDirectory.resolvePath(AppConfig.PATH_PRELOAD_URL);
			return preloadFile.exists;
		}
		
		protected function onAppAssetsPreloadInit():void
		{
			Logger.info(this, "onAppAssetsPreload");
			
			var appPreLoadAssetsFile:File = File.applicationDirectory.resolvePath(AppConfig.PATH_PRELOAD_URL);
			
			var appPreloadAssetManager:CrocoAssetsManager = CrocoAssetsManager(GlobalPropertyBag.read(AppConfig.KEY_APP_RELOAD_ASSETS_MANAGER));
			appPreloadAssetManager.enqueue(appPreLoadAssetsFile);
			
			onAppAssetsPreloadStart();
		}
		
		protected function onAppAssetsPreloadStart():void
		{
			Logger.info(this, "onAppAssetsPreloadStart");
			
			var appPreloadAssetManager:CrocoAssetsManager = CrocoAssetsManager(GlobalPropertyBag.read(AppConfig.KEY_APP_RELOAD_ASSETS_MANAGER));
			appPreloadAssetManager.loadQueue(onAppAssetsPreloadProgress);
		}
		
		protected function onAppAssetsPreloadProgress(progress:Number):void
		{
			if(progress == 1)
			{
				if(AppConfig.appBootStrapAssetsPreloadCompletedCallback != null)
				{
					AppConfig.appBootStrapAssetsPreloadCompletedCallback.call(null, this);
				}
				
				//if there is no BootStrapScreen and progress equal 1. just go.
				//or will wait the BootStrapScreen to dispatch the event.
				if(!mBootStrapScreen)
				{
					dispatchEvent(new Event(BOOT_STRAP_COMPLETE));
				}
			}
			
			//the BootStrapScreen also watch the progress equal 1.
			if(mBootStrapScreen)
			{
				mBootStrapScreen.onAssetsPreloadProgress(progress);
			}
		}
		
		
		//event callback part
		//----------------------------------------------------------------------
		
		protected function appDeactivateHandler(event:*):void
		{
			if(mCrocoEngine) mCrocoEngine.stop();
			if(mStarling) mStarling.stop();
			
			if(AppConfig.appDeactivatedCallback != null)
			{
				AppConfig.appDeactivatedCallback.call(null, this, event);
			}
		}
		
		protected function appActivateHandler(event:*):void
		{
			if(mCrocoEngine) mCrocoEngine.start();
			if(mStarling) mStarling.start();
			
			if(AppConfig.appActivatedCallback != null)
			{
				AppConfig.appActivatedCallback.call(null, this, event);
			}
		}
		
		protected function stageResizeHandler(event:Event):void
		{
			if(mStarling)
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
			
			var designWidth:int = AppConfig.designWidth;
			var desighHeight:int = AppConfig.designHeight;
			
			var deviceWidth:int = stage.stageWidth;
			var deviceHeight:int = stage.stageHeight;
			
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
			
			var viewPort:Rectangle = mStarling.viewPort;
			viewPort.setTo(viewPortX, viewPortY, viewPortWidth, viewPortHeight);
			
			mStarling.stage.stageWidth = designWidth;
			mStarling.stage.stageHeight = desighHeight;
			mStarling.viewPort = viewPort;
		}
		
		private function starlingContextCreatedHandler(event:*):void
		{
			if(AppConfig.starlingContextLostCallback != null)
			{
				AppConfig.starlingContextLostCallback.call(null, event);
			}
		}
		
		private function appBootStrapCompleteHandler(event:Event = null):void
		{
			this.removeEventListener(BOOT_STRAP_COMPLETE, appBootStrapCompleteHandler);
			
			if(AppConfig.appBootStrapCompletedCallback != null)
			{
				AppConfig.appBootStrapCompletedCallback.call(null, this);
			}
			
			onAppBootStrapCompletedThenReady2EntryScreen();
			onAppBootStrapCompletedAndClearSomethingsBefor();
		}
		
		protected function onAppBootStrapCompletedThenReady2EntryScreen():void
		{
			Logger.info(this, "onAppBootStrapCompletedThenReady2GoEntryScreen");
			
			var entryScreenData:Object = null;
			
			var defualtScreenNavigatorItemBlackBoard:PropertyBag = mDefaultebtryScreenNavigatorItem.blackBoard;
			if(defualtScreenNavigatorItemBlackBoard.has(AppConfig.KEY_ENTRY_SCREEN_DATA))
			{
				entryScreenData = defualtScreenNavigatorItemBlackBoard.read(AppConfig.KEY_ENTRY_SCREEN_DATA);
			}
			
			if(AppConfig.appBootStrapEntryScreenCallback != null)
			{
				var results:Array = AppConfig.appBootStrapEntryScreenCallback.call(null, this, mDefaultEntryScreenName, entryScreenData); 
			
				mStarlingRoot.jumToScreen(results[0], results[1]);
			}
			else
			{
				mStarlingRoot.jumToScreen(mDefaultEntryScreenName, entryScreenData);
			}
		}
		
		protected function onAppBootStrapCompletedAndClearSomethingsBefor():void
		{
			Logger.info(this, "onAppBootStrapCompletedThenClearSomethingsBefor");
			
			if(mBootStrapScreen)
			{
				if(mBootStrapScreen is DisplayObject)
				{
					this.stage.removeChild(DisplayObject(mBootStrapScreen));
				}

				mBootStrapScreen.dispose();
				mBootStrapScreen = null;
			}
			
			mDefaultEntryScreenName = null;
			mDefaultebtryScreenNavigatorItem = null;
			mStarlingRoot = null;
		}
	}
}