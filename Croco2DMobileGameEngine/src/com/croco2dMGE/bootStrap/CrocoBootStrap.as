package com.croco2dMGE.bootStrap
{
	import com.croco2dMGE.CrocoEngine;
	import com.fireflyLib.core.SystemGlobal;
	import com.fireflyLib.debug.Logger;
	import com.fireflyLib.utils.ClassFactory;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	
	import starling.core.Starling;
	import starling.utils.AssetManager;

	[Event(name="bootStrapComplete", type="flash.events.Event")]
	
	public class CrocoBootStrap extends Sprite
	{
		public static const BOOT_STRAP_COMPLETE:String = "bootStrapComplete";
		
		protected var mStarling:Starling;
		protected var mCrocoEngine:CrocoEngine;
		protected var mStarlingRoot:ScreenNavigator;
		protected var mLaunchImage:ICrocoLaunchImage;
		
		protected var mDefaultScreenName:String;
		
		public function CrocoBootStrap()
		{
			super();
			
			SystemGlobal.stage = stage;
			
			onBootStrapConfigInit();
			
			this.mouseEnabled = this.mouseChildren = false;
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		protected function onBootStrapConfigInit():void 
		{
			Logger.info(this, "onInitConfig", "onInitConfig");
		}
		
		private function addToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			onInit();
		}
		
		protected function onInit():void
		{
			Logger.info(this, "onInit", "onInit");
			
			this.addEventListener(BOOT_STRAP_COMPLETE, appBootStrapCompleteHandler);
			
			onStageInit();
			
			if(CrocoBootStrapConfig.launchImageClass) 
			{
				onLaunchImageInit();
			}
			
			onStarlingInit();
		}
		
		protected function onStageInit():void
		{
			Logger.info(this, "onStageInit", "onStageInit");
			
			//stage default setting
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.color = CrocoBootStrapConfig.backgroundColor;
			stage.frameRate = CrocoBootStrapConfig.frameRate;
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, appActivateHandler);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, appDeactivateHandler);
			
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function onLaunchImageInit():void
		{
			mLaunchImage = ClassFactory.classInstance(CrocoBootStrapConfig.launchImageClass);
			mLaunchImage.launch(CrocoBootStrapConfig.launchImagePath);
			this.stage.addChild(DisplayObject(mLaunchImage));
		}
		
		protected function onStarlingInit():void
		{
			Logger.info(this, "onStarlingInit", "onStarlingInit");
			
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
			Logger.info(this, "onFeathersInit", "onFeathersInit");
			
			if(CrocoBootStrapConfig.feathersThemeClass)
			{
				new CrocoBootStrapConfig.themeClass();
			}
		}
		
		protected function onCrocoEngineInit():void
		{
			Logger.info(this, "onCrocoEngineInit", "onCrocoEngineInit");
			
			mCrocoEngine = CrocoEngine.startUp(stage, mStarling, CrocoBootStrapConfig.designWidth, CrocoBootStrapConfig.designHeight);
			mCrocoEngine.start();
		}
		
		protected function onScreenNavigatorInit():void
		{
			Logger.info(this, "onScreenNavigatorInit", "onScreenNavigatorInit");
			
			var crocoScreenNavigator:ScreenNavigator = ScreenNavigator(mStarling.root);
			
			var screenConfigs:Array = CrocoBootStrapConfig.screens;
			var screenConfigItems:Array;//name, class, constructorParameters
			
			var screenName:String;
			var screenConstructorParameters:Array;//screen:Object = null, events:Object = null, properties:Object = null, 
			
			var n:int = screenConfigs ? screenConfigs.length : 0;
			for(var i:int = 0; i < n; i++)
			{
				screenConfigItems = screenConfigs[i];//0, 1->[Class]
				
				screenName = screenConfigItems[0];
				screenConstructorParameters = screenConfigItems[1];
				
				if(i == 0) mDefaultScreenName = screenName;
				
				mStarlingRoot.addScreen(screenName,
					ClassFactory.classInstance(ScreenNavigatorItem, screenConstructorParameters));
			}
		}
		
		protected function onExtentionsInit():void
		{
			Logger.info(this, "onExtentionsInit", "onExtentionsInit");
			
			var extentionConfigs:Array = CrocoBootStrapConfig.extentions;
			var extentionConfigItems:Array;//name, classs, constructorParameters
			
			var extentionName:String;
			var extentionCls:Class;
			var extentionConstructorParameters:Array;
			
			var n:int = extentionConfigs ? extentionConfigs.length : 0;
			for(var i:int = 0; i < n; i++)
			{
				extentionConfigItems = extentionConfigs[i];
				
				extentionName = extentionConfigItems[0];
				extentionCls = extentionConfigItems[1];
				extentionConstructorParameters = extentionConfigItems[2] as Array;
				
				SystemGlobal.set(extentionName, ClassFactory.classInstance(extentionCls, extentionConstructorParameters));
			}
		}
		
		protected function onAssetsPreload():void
		{
			Logger.info(this, "onAssetsPreload", "onAssetsPreload");
			
			var preLoadAssetsFile:File = File.applicationDirectory.resolvePath(CrocoBootStrapConfig.preLoadAssetsPath);
			var assetManager:AssetManager = AssetManager(SystemGlobal.get("AssetManager"));
			assetManager.enqueue(preLoadAssetsFile);
			assetManager.loadQueue(onAssetsPreloadProgress);	
		}
		
		protected function onAssetsPreloadProgress(progress:Number):void
		{
			if(mLaunchImage)
			{
				mLaunchImage.onAssetsPreloadProgress(progress);
			}
			
			if(progress == 1)
			{
				onAssetsPreloadComplete();
			}
		}
		
		protected function onAssetsPreloadComplete():void
		{
			Logger.info(this, "onAssetsPreloadComplete", "onAssetsPreloadComplete");
			
			onInitedComplete();
		}
		
		protected function onInitedComplete():void
		{
			Logger.info(this, "onInitedComplete", "onInitedComplete");
			
			dispatchEvent(new Event(BOOT_STRAP_COMPLETE));
		}
		
		protected function appDeactivateHandler(event:*):void
		{
			Logger.info(this, "stageDeactivateHandler", "stageDeactivateHandler");
			
			if(mStarling) mStarling.stop();
			if(mCrocoEngine) mCrocoEngine.stop();
		}
		
		protected function appActivateHandler(event:*):void
		{
			Logger.info(this, "stageDeactivateHandler", "stageDeactivateHandler");
			
			if(mStarling) mStarling.start();
			if(mCrocoEngine) mCrocoEngine.start();
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
		
		protected function starlingRootCreatedHandler(event:*):void
		{
			Logger.info(this, "starlingRootCreatedHandler", "starlingRootCreatedHandler");
			
			mStarling.removeEventListener("rootCreated", starlingRootCreatedHandler);
			
			mStarlingRoot = mStarling.root as ScreenNavigator;
			
			onFeathersInit();
			
			onCrocoEngineInit();
			
			onScreenNavigatorInit();
			
			onExtentionsInit();
			
			if(CrocoBootStrapConfig.preLoadAssetsPath && 
				File.applicationDirectory.resolvePath(CrocoBootStrapConfig.preLoadAssetsPath).exists)
			{
				onAssetsPreload();
			}
			else
			{
				onInitedComplete();
			}
		}
		
		protected function appBootStrapCompleteHandler(event:Event = null):void
		{
			Logger.info(this, "appBootStrapCompleteHandler", "appBootStrapCompleteHandler");
			
			this.removeEventListener(BOOT_STRAP_COMPLETE, appBootStrapCompleteHandler);
			
			if(mLaunchImage)
			{
				this.stage.removeChild(DisplayObject(mLaunchImage));
				mLaunchImage.dispose();
				mLaunchImage = null;
			}
			
			if(mDefaultScreenName)
			{
				mStarlingRoot.showScreen(mDefaultScreenName);
				mDefaultScreenName = null;
			}
		}
	}
}