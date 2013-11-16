package com.croco2dMGE.bootStrap
{
	import com.croco2dMGE.CrocoEngine;
	import com.croco2dMGE.graphics.screens.CrocoScreenNavigator;
	import com.croco2dMGE.graphics.screens.CrocoScreenNavigatorItem;
	import com.croco2dMGE.graphics.screens.ICrocoBootStrapScreen;
	import com.croco2dMGE.utils.CrocoAssetsManager;
	import com.fireflyLib.debug.Logger;
	import com.fireflyLib.utils.ClassFactory;
	import com.fireflyLib.utils.GlobalPropertyBag;
	
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
	
	public class CrocoBootStrap extends Sprite
	{
		public static const BOOT_STRAP_COMPLETE:String = "bootStrapComplete";
		
		protected var mStarling:Starling;
		protected var mCrocoEngine:CrocoEngine;
		
		protected var mStarlingRoot:CrocoScreenNavigator;

		//will dispose after bootStrap complete.
		protected var mBootStrapScreen:ICrocoBootStrapScreen;
		
		protected var mDefaultEntryScreenName:String;
		
		public function CrocoBootStrap()
		{
			super();
			
			GlobalPropertyBag.stage = stage;
			
			onBootStrapConfigInit();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		protected function onBootStrapConfigInit():void 
		{
			Logger.info(this, "onInitConfig");
		}
		
		private function addToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.addEventListener(BOOT_STRAP_COMPLETE, appBootStrapCompleteHandler);
			
			onInit();
		}
		
		protected function onInit():void
		{
			Logger.info(this, "onInit");
			
			//default
			this.visible = this.mouseEnabled = this.mouseChildren = false;
			
			onStageInit();
			
			if(CrocoBootStrapConfig.bootStrapScreenClass) 
			{
				onBootStrapScreenInit();
			}
			
			onStarlingInit();
		}
		
		protected function onStageInit():void
		{
			Logger.info(this, "onStageInit");
			
			//stage default setting
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.color = CrocoBootStrapConfig.backgroundColor;
			stage.frameRate = CrocoBootStrapConfig.frameRate;
			
			if(!CrocoEngine.debug)
			{
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, appActivateHandler);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, appDeactivateHandler);
			}
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function onBootStrapScreenInit():void
		{
			mBootStrapScreen = ClassFactory.classInstance(CrocoBootStrapConfig.bootStrapScreenClass);
			mBootStrapScreen.bootStrap = this;
			mBootStrapScreen.launch(CrocoBootStrapConfig.ASSETS_LAUNCH_IMAGE_DIR_PATH + CrocoBootStrapConfig.launchImageName);
			
			if(mBootStrapScreen is DisplayObject)
			{
				this.stage.addChild(DisplayObject(mBootStrapScreen));
			}
		}
		
		protected function onStarlingInit():void
		{
			Logger.info(this, "onStarlingInit");
			
			//config
			Starling.handleLostContext = CrocoBootStrapConfig.starlingHandleLostContext;
			Starling.multitouchEnabled = CrocoBootStrapConfig.starlingMultitouchEnabled;
			
			mStarling = new Starling(CrocoBootStrapConfig.starlingRootClass, 
				stage, 
				null,
				stage.stage3Ds[0],
				"auto", 
				CrocoBootStrapConfig.starlingProfile);
			
			mStarling.addEventListener("rootCreated", starlingRootCreatedHandler);
			mStarling.start();
		}
		
		protected function onFeathersInit():void
		{
			Logger.info(this, "onFeathersInit");
			
			if(CrocoBootStrapConfig.feathersThemeClass)
			{
				new CrocoBootStrapConfig.themeClass();
			}
		}
		
		protected function onCrocoEngineInit():void
		{
			Logger.info(this, "onCrocoEngineInit");
			
			mCrocoEngine = CrocoEngine.startUp(stage, 
				mStarling, 
				CrocoBootStrapConfig.designWidth, 
				CrocoBootStrapConfig.designHeight);
			mCrocoEngine.start();
		}
		
		protected function onScreenNavigatorInit():void
		{
			Logger.info(this, "onScreenNavigatorInit");
			
			var screens:Array = CrocoBootStrapConfig.screens;
			
			var screenItem:Object;
			
			var n:int = screens ? screens.length : 0;
			
			for(var i:int = 0; i < n; i++)
			{
				screenItem = screens[i];
				
				//default is first one config setting.
				if(i == 0) 
				{
					mDefaultEntryScreenName = screenItem.name;
				}
				
				mStarlingRoot.addScreen(screenItem.name, 
					new CrocoScreenNavigatorItem(screenItem.cls, 
						screenItem.events, 
						screenItem.props, 
						screenItem.blackBoard));
			}
		}
		
		protected function onExtentionsInit():void
		{
			Logger.info(this, "onExtentionsInit");
			
			var extentions:Array = CrocoBootStrapConfig.extentions;
			
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
		
		protected function checkIsNeedAppAssetsPreload():Boolean
		{
			return File.applicationDirectory.resolvePath(CrocoBootStrapConfig.ASSETS_PRELOAD_DIR_PATH).exists;
		}
		
		protected function onAppAssetsPreloadInit():void
		{
			Logger.info(this, "onAppAssetsPreload");
			
			var appPreLoadAssetsFile:File = File.applicationDirectory.resolvePath(CrocoBootStrapConfig.ASSETS_PRELOAD_DIR_PATH);
			
			var appPreloadAssetManager:CrocoAssetsManager = CrocoAssetsManager(GlobalPropertyBag.read(CrocoBootStrapConfig.KEY_APPP_RELOAD_ASSETS_MANAGER));
			appPreloadAssetManager.enqueue(appPreLoadAssetsFile);
			
			onAppAssetsPreloadStart();
		}
		
		protected function onAppAssetsPreloadStart():void
		{
			Logger.info(this, "onAppAssetsPreloadStart");
			
			var appPreloadAssetManager:CrocoAssetsManager = CrocoAssetsManager(GlobalPropertyBag.read(CrocoBootStrapConfig.KEY_APPP_RELOAD_ASSETS_MANAGER));
			appPreloadAssetManager.loadQueue(onAppAssetsPreloadProgress);
		}
		
		protected function onAppAssetsPreloadProgress(progress:Number):void
		{
			if(progress == 1)
			{
				onAppAssetsPreloadComplete();
				
				//if there is no BootStrapScreen and progress equal 1. just go.
				//or will wait the BootStrapScreen to dispatch the event.
				if(!mBootStrapScreen)
				{
					dispatchEvent(new Event(BOOT_STRAP_COMPLETE));
				}
			}
			
			if(mBootStrapScreen)
			{
				mBootStrapScreen.onAssetsPreloadProgress(progress);
			}
		}
		
		protected function onAppAssetsPreloadComplete():void
		{
			Logger.info(this, "onAppAssetsPreloadComplete");
		}
		
		protected function appDeactivateHandler(event:*):void
		{
			Logger.info(this, "stageDeactivateHandler");
			
			if(mCrocoEngine) mCrocoEngine.stop();
			if(mStarling) mStarling.stop();
		}
		
		protected function appActivateHandler(event:*):void
		{
			Logger.info(this, "stageDeactivateHandler");
			
			if(mCrocoEngine) mCrocoEngine.start();
			if(mStarling) mStarling.start();
		}
		
		protected function stageResizeHandler(event:Event):void
		{
			if(mStarling) updateStarlingViewPort();
		}
		
		protected function updateStarlingViewPort():void
		{
			var viewPortX:Number = 0;
			var viewPortY:Number = 0;
			var viewPortWidth:Number = 0;
			var viewPortHeight:Number = 0;
			
			var designWidth:int = CrocoBootStrapConfig.designWidth;
			var desighHeight:int = CrocoBootStrapConfig.designHeight;
			
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
		
		private function starlingRootCreatedHandler(event:*):void
		{
			mStarling.removeEventListener("rootCreated", starlingRootCreatedHandler);
			
			onStarlingRootCreated();
		}
		
		protected function onStarlingRootCreated():void
		{
			Logger.info(this, "starlingRootCreatedHandler");
			
			mStarlingRoot = mStarling.root as CrocoScreenNavigator;
			
			onFeathersInit();
			
			onCrocoEngineInit();
			
			onScreenNavigatorInit();
			
			onExtentionsInit();
			
			if(checkIsNeedAppAssetsPreload())
			{
				onAppAssetsPreloadInit();
			}
			else
			{
				//no BootStrapScreen and No preload, just go.
				if(!mBootStrapScreen)
				{
					dispatchEvent(new Event(BOOT_STRAP_COMPLETE));
				}	
			}
		}
		
		private function appBootStrapCompleteHandler(event:Event = null):void
		{
			this.removeEventListener(BOOT_STRAP_COMPLETE, appBootStrapCompleteHandler);
			
			onAppBootStrapCompleted();
		}
		
		protected function onAppBootStrapCompleted():void
		{
			Logger.info(this, "appBootStrapCompleteHandler");
			
			onAppBootStrapCompletedThenReady2GoEntryScreen();
			onAppBootStrapCompletedThenClearSomethingsBefor();
		}
		
		protected function onAppBootStrapCompletedThenClearSomethingsBefor():void
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
			mStarlingRoot = null;
		}
		
		protected function onAppBootStrapCompletedThenReady2GoEntryScreen():void
		{
			Logger.info(this, "onAppBootStrapCompletedThenReady2GoEntryScreen");
			
			mStarlingRoot.jumToScreen(mDefaultEntryScreenName);
		}
	}
}