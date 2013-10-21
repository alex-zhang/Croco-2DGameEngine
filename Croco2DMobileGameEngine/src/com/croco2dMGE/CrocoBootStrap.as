package com.croco2dMGE
{
	import com.fireflyLib.core.SystemGlobal;
	import com.fireflyLib.debug.Logger;
	import com.fireflyLib.utils.ClassFactory;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	
	import starling.core.Starling;
	import starling.utils.AssetManager;

	[Event(name="bootStrapComplete", type="flash.events.Event")]
	
	public class CrocoBootStrap extends Sprite
	{
		public static const BOOT_STRAP_COMPLETE:String = "bootStrapComplete";
		
		public var mStarling:Starling;
		public var crocoEngine:CrocoEngine;
		public var starlingRoot:ScreenNavigator;
		
		protected var mDefaultScreenName:String;
		protected var mLunchImage:Loader;
		
		public function CrocoBootStrap()
		{
			super();
			
			SystemGlobal.stage = stage;
			
			onInitConfig();
			
			this.visible = false;
			this.mouseEnabled = this.mouseChildren = false;
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		protected function onInitConfig():void 
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
			
			if(CrocoBootStrapConfig.launchImage) onLaunchImageInit();
			
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
			
			stage.addEventListener(Event.ACTIVATE, stageActivateHandler,true, int.MAX_VALUE);
			stage.addEventListener(Event.DEACTIVATE, stageDeactivateHandler,true, int.MAX_VALUE);
		}
		
		protected function onLaunchImageInit():void
		{
			var launchImageFile:File = File.applicationDirectory.resolvePath(CrocoBootStrapConfig.launchImage);
			if(launchImageFile.exists)
			{
				var bytes:ByteArray = new ByteArray();
				var stream:FileStream = new FileStream();
				stream.open(launchImageFile, FileMode.READ);
				stream.readBytes(bytes, 0, stream.bytesAvailable);
				stream.close();
				
				mLunchImage = new Loader();
				mLunchImage.loadBytes(bytes);
				this.stage.addChild(mLunchImage);
			}
		}
		
		protected function onStarlingInit():void
		{
			Logger.info(this, "onStarlingInit", "onStarlingInit");
			
			//config
			Starling.handleLostContext = CrocoBootStrapConfig.starlingHandleLostContext;
			Starling.multitouchEnabled = CrocoBootStrapConfig.starlingMultitouchEnabled;
			
			mStarling = new Starling(CrocoBootStrapConfig.starlingRootClass, 
				stage, 
				CrocoBootStrapConfig.screenViewPort, 
				stage.stage3Ds[0],
				"auto", 
				CrocoBootStrapConfig.starlingProfile);
			
			mStarling.addEventListener("rootCreated", starlingRootCreatedHandler);
			mStarling.start();
		}
		
		protected function onFeathersInit():void
		{
			Logger.info(this, "onFeathersInit", "onFeathersInit");
			
			if(CrocoBootStrapConfig.themeClass)
			{
				new CrocoBootStrapConfig.themeClass();
			}
		}
		
		protected function onCrocoEngineInit():void
		{
			Logger.info(this, "onCrocoEngineInit", "onCrocoEngineInit");
			
			crocoEngine = CrocoEngine.startUp(stage, mStarling);
			crocoEngine.start();
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
				
				starlingRoot.addScreen(screenName,
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
			
			var preLoadAssetsFile:File = File.applicationDirectory.resolvePath("assets/preload");
			
			var assetManager:AssetManager = AssetManager(SystemGlobal.get("AssetManager"));
			assetManager.enqueue(preLoadAssetsFile);
			assetManager.loadQueue(onAssetsPreloadProgress);
		}
		
		protected function onAssetsPreloadProgress(progress:Number):void
		{
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
		
		protected function stageDeactivateHandler(event:*):void
		{
			Logger.info(this, "stageDeactivateHandler", "stageDeactivateHandler");
			
			if(mStarling) mStarling.stop();
			if(crocoEngine) crocoEngine.stop();
		}
		
		protected function stageActivateHandler(event:*):void
		{
			Logger.info(this, "stageDeactivateHandler", "stageDeactivateHandler");
			
			if(mStarling) mStarling.start();
			if(crocoEngine) crocoEngine.start();
		}
		
		protected function starlingRootCreatedHandler(event:*):void
		{
			Logger.info(this, "starlingRootCreatedHandler", "starlingRootCreatedHandler");
			
			mStarling.removeEventListener("rootCreated", starlingRootCreatedHandler);
			
			starlingRoot = mStarling.root as ScreenNavigator;
			
			onFeathersInit();
			
			onCrocoEngineInit();
			
			onScreenNavigatorInit();
			
			onExtentionsInit();
			
			if(CrocoBootStrapConfig.assetsPreLoad)
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
			
			if(mLunchImage)
			{
				mLunchImage.unloadAndStop(false);
				this.stage.removeChild(mLunchImage);
				mLunchImage = null;
			}
			
			if(mDefaultScreenName)
			{
				starlingRoot.showScreen(mDefaultScreenName);
				mDefaultScreenName = null;
			}
		}
	}
}