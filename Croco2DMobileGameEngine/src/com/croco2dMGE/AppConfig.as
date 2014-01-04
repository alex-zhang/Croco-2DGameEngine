package com.croco2dMGE
{
	import com.croco2dMGE.screens.AssetsPreloadHubScreen;
	import com.croco2dMGE.screens.BootStrapScreen;
	import com.croco2dMGE.screens.CrocoScreen;
	import com.croco2dMGE.screens.CrocoScreenNavigator;
	import com.croco2dMGE.utils.assets.AnimationSetAsset;
	import com.croco2dMGE.utils.assets.BinaryAsset;
	import com.croco2dMGE.utils.assets.BitmapFontAsset;
	import com.croco2dMGE.utils.assets.CoralDirPackAsset;
	import com.croco2dMGE.utils.assets.CrocoAssetsManager;
	import com.croco2dMGE.utils.assets.ExcelDataRepositoryAsset;
	import com.croco2dMGE.utils.assets.ImageAsset;
	import com.croco2dMGE.utils.assets.JSONAsset;
	import com.croco2dMGE.utils.assets.ParticleSetAsset;
	import com.croco2dMGE.utils.assets.SoundAsset;
	import com.croco2dMGE.utils.assets.SpriteSheetAsset;
	import com.croco2dMGE.utils.assets.TextAsset;
	import com.croco2dMGE.utils.assets.XMLAsset;
	import com.croco2dMGE.utils.tmx.world.ornaments.OrtAnimationSetSpriteEntity;
	import com.croco2dMGE.utils.tmx.world.ornaments.OrtAnimationSpriteEntity;
	import com.croco2dMGE.utils.tmx.world.ornaments.OrtImageEntity;
	import com.croco2dMGE.utils.tmx.world.ornaments.OrtLineUVAnimationEntity;
	import com.croco2dMGE.utils.tmx.world.ornaments.OrtParticalSpriteEntity;
	import com.croco2dMGE.utils.tmx.world.ornaments.OrtSurroundingSoundEntity;
	import com.fireflyLib.debug.Logger;

	public class AppConfig
	{
		OrtAnimationSetSpriteEntity;
		OrtAnimationSpriteEntity;
		OrtImageEntity;
		OrtLineUVAnimationEntity;
		OrtParticalSpriteEntity;
		OrtSurroundingSoundEntity;
		
		//System Path Define
		//if u modify the path u'd better modify all.
		public static var PATH_ROOT_URL:String = "app:/";
		public static var PATH_ASSETS_URL:String = PATH_ROOT_URL + "assets/";
		public static var PATH_APP_URL:String = PATH_ASSETS_URL + "app/";
		
		public static var PATH_PRELOAD_URL:String = PATH_APP_URL + "preload/";
		public static var PATH_SHARED_URL:String = PATH_APP_URL + "shared/";
		public static var PATH_SCREENS_URL:String = PATH_APP_URL + "screens/";
		public static var PATH_SCENES_URL:String = PATH_APP_URL + "scenes/";
		
		public static var findRootPathResource:Function = function(relativeURL:String):String {
			return PATH_ROOT_URL + relativeURL;
		}
			
		public static var findAssetsPathResource:Function = function(relativeURL:String):String {
			return PATH_ASSETS_URL + relativeURL;
		}
			
		public static var findAppPathResource:Function = function(relativeURL:String):String {
			return PATH_APP_URL + relativeURL;
		}
			
		public static var findPreloadPathResource:Function = function(relativeURL:String):String {
			return PATH_PRELOAD_URL + relativeURL;
		}
			
		public static var findSharedPathResource:Function = function(relativeURL:String):String {
			return PATH_SHARED_URL + relativeURL;
		}
			
		public static var findScreensPathResource:Function = function(relativeURL:String):String {
			return PATH_SCREENS_URL + relativeURL;
		}
		
		public static var findTargetScreenPathResource:Function = function(screenName:String, relativeURL:String):String {
			return AppConfig.findScreensPathResource(screenName + "/" + relativeURL);
		}
			
		public static var findScenesPathResource:Function = function(relativeURL:String):String {
			return PATH_SCENES_URL + relativeURL;
		}
		
		public static var findTargetScenePathResource:Function = function(sceneName:String, relativeURL:String):String {
			return AppConfig.findScenesPathResource(sceneName + "/" + relativeURL);
		}
		
		//System Chars Key Define
		public static var KEY_APP_RELOAD_ASSETS_MANAGER:String = "appPreloadAssetsManager";
		public static var KEY_JUMP2TARGET_SCREEN_ID:String = "jump2TargetScreenId";
		public static var KEY_ENTRY_SCREEN_DATA:String = "entryScreenData";
		public static var KEY_SCENE_ID:String = "sceneID";
		public static var KEY_HUB_SCREEN_ID:String = "hubScreenID";
		public static var KEY_SCEEN_PRELOAD_ASSETS_MANAGER:String = "screenPreLoadAssetsManager";
		public static var KEY_CROCO_ENGINE:String = "crocoEngine";
		public static var KEY_SCENE_CAMERA:String = "sceneCamera";
		public static var KEY_KEY_BOARD_CONTROLLER:String = "keyboardController";
		
		
		//1.777~1.3333 gap
		public static var designWidth:int = 960;
		public static var designHeight:int = 640;

		public static var backgroundColor:uint = 0;//default
		
		public static var frameRate:int = 60;//default
		
		public static var starlingRootClass:Class = CrocoScreenNavigator;//default
		public static var starlingHandleLostContext:Boolean = false;
		public static var starlingMultitouchEnabled:Boolean = false;
		public static var starlingProfile:String = "baselineConstrained"; 
		
		public static var assetsTextureScaleFactor:Number = 1.0;
		public static var assetsTextureUseMipmaps:Boolean = false;
		
		public static var feathersThemeClass:Class = null;
		
		//
		/**
		 * cls: BootStrapScreen //the bootStrapSceen impl Class
		 * launchImage:"launchImage.png" //the image name of the resource, fileFormat support swf , png, jpg
		 * fadeOutTime:10 //the BootStrapScreen fadout time.
		 */		
		public static var bootStrapSceen:Object = {
				cls:BootStrapScreen,
				launchImage:"launchImage.png",
				fadeoutTime:2
			}
		
		//eg.
		/**
		 * [
		 * 	{
		 * 		name:ExtentionName,
		 * 		cls:ExtentionClass,
		 * 		clsParms:[] or null if need
		 * 	}
		 * 	...
		 * ]
		 */		
		//default
		public static var extentions:Array = [
												{
													name: AppConfig.KEY_APP_RELOAD_ASSETS_MANAGER,
													cls:CrocoAssetsManager
												}
											];

		/**
		 * [
		 *  //normal screens
		 * 	{
		 *  	name:ScreenName,
		 * 		cls:ScreenClass,
		 * 		events:{} @see ScreenNavigatorItem.events
		 * 		props:{} @see ScreenNavigatorItem.properties
		 * 		blackBoard: //blackBoard provid an data container to save data between screen. even if the screen instance is not exsit.
		 * 		{
		 * 			hubScreenID:"AssetsPreloadHubScreen"
		 * 			if this screen is the first screen, here my a property for entryScreenData
		 * 			entryScreenData:{sceneID:???}
		 * 		}
		 *  }
		 * 
		 * 	//hub screens
		 * 	{
		 * 		name:"AssetsPreloadHubScreen",
		 * 		cls:AssetsPreloadHubScreen
		 * 	}
		 * ....
		 * ]
		 * 
		 */	
		public static var screens:Array = [
											//normal screens
											{
												name:"DefaultScreen",
												cls:CrocoScreen,
												blackBoard: 
												{
													hubScreenID:"AssetsPreloadHubScreen"
												}
											}
											,
											//hub screens
											{
												name:"AssetsPreloadHubScreen",
												cls:AssetsPreloadHubScreen
											}
										];
		
		public static var crocoAssetsManagerDefaultAssetTypeAndExtentionsConfig:Function = function():void
		{
			var extention:String;
			
			//
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.TEXT_TYPE, TextAsset);
			for each(extention in CrocoAssetsManager.TEXT_EXTENSIONS)
			{
				CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.TEXT_TYPE, extention);
			}
			
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.XML_TYPE, XMLAsset);
			for each(extention in CrocoAssetsManager.XML_TYPE_EXTENTION)
			{
				CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.XML_TYPE, extention);
			}
			
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.JSON_TYPE, JSONAsset);
			for each(extention in CrocoAssetsManager.JSON_TYPE_EXTENTION)
			{
				CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.JSON_TYPE, extention);
			}
			
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.SOUND_TYPE, SoundAsset);
			for each(extention in CrocoAssetsManager.SOUND_TYPE_EXTENTION)
			{
				CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.SOUND_TYPE, extention);
			}
			
			//			for(extention in VIDEO_TYPE_EXTENTION)
			//			{
			//				registAssetTypeExtention(VIDEO_TYPE, extention);
			//			}
			
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.IMAGE_TYPE, ImageAsset);
			for each(extention in CrocoAssetsManager.IMAGE_TYPE_EXTENTION)
			{
				CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.IMAGE_TYPE, extention);
			}
			
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.EXCEL_DATA_REPOSITORY_TYPE, ExcelDataRepositoryAsset);
			CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.EXCEL_DATA_REPOSITORY_TYPE, CrocoAssetsManager.EXCEL_DATA_REPOSITORY_EXTENTION);
			
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.CORAL_DIR_PACK_RES_TYPE, CoralDirPackAsset);
			CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.CORAL_DIR_PACK_RES_TYPE, CrocoAssetsManager.CORAL_DIR_PACK_RES_EXTENTION);
			
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.ANIMATION_SET_RES_TYPE, AnimationSetAsset);
			CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.ANIMATION_SET_RES_TYPE, CrocoAssetsManager.ANIMATION_SET_RES_EXTENTION);
			
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.SPRIT_SHEET_RES_TYPE, SpriteSheetAsset);
			CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.SPRIT_SHEET_RES_TYPE, CrocoAssetsManager.SPRIT_SHEET_RES_EXTENTION);
			
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.PARTICLE_SET_RES_TYPE, ParticleSetAsset);
			CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.PARTICLE_SET_RES_TYPE, CrocoAssetsManager.PARTICLE_SET_RES_EXTENTION);
			
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.BITMAP_FONT_RES_TYPE, BitmapFontAsset);
			CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.BITMAP_FONT_RES_TYPE, CrocoAssetsManager.BITMAP_FONT_RES_EXTENTION);
			
			CrocoAssetsManager.registAssetTypeClass(CrocoAssetsManager.BINARY_TYPE, BinaryAsset);
			CrocoAssetsManager.registAssetTypeExtention(CrocoAssetsManager.BINARY_TYPE, CrocoAssetsManager.BINARY_EXTENTION);
		}
			
		//system Callback
		public static var onAppPreInitdCallback:Function = function(bootStrap:AppBootStrap):void
		{
			crocoAssetsManagerDefaultAssetTypeAndExtentionsConfig();
			
			Logger.info(bootStrap, "onAppPreInitd");
		}
		
		public static var onAppInitdCallback:Function = function(bootStrap:AppBootStrap):void
		{
			Logger.info(bootStrap, "onAppInitd.");
		}
			
		public static var appDeactivatedCallback:Function = function(bootStrap:AppBootStrap, event:*):void
		{
			Logger.info(bootStrap, "appDeactivated.");
		}
			
		public static var appActivatedCallback:Function = function(bootStrap:AppBootStrap, event:*):void
		{
			Logger.info(bootStrap, "appAactivated.");
		}
			
		public static var starlingContextLostCallback:Function = function(bootStrap:AppBootStrap, event:*):void
		{
			Logger.warn(bootStrap, "starling context lost!!");
		}
			
		public static var appBootStrapAssetsPreloadCompletedCallback:Function = function(bootStrap:AppBootStrap):void
		{
			Logger.info(bootStrap, "onAppAssetsPreloadComplete.");
		}
			
		public static var appBootStrapCompletedCallback:Function = function(bootStrap:AppBootStrap):void
		{
			Logger.info(bootStrap, "appBootStrapCompleted.");
		}
			
		public static var appBootStrapEntryScreenCallback:Function = function(bootStrap:AppBootStrap, 
																			  defaultEntryScreenName:String, entryScreenData:Object):Array
		{
			Logger.info(bootStrap, "appBootStrapEntryScreen.");
			
			return [defaultEntryScreenName, entryScreenData];
		}
			
		//----------------------------------------------------------------------

		public function AppConfig(bootStrap:AppBootStrap)
		{
			Logger.info(bootStrap, "appConfigInit.");
		}
	}
}