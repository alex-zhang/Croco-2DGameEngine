package com.croco2d
{
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.input.controllers.KeyboardController;
	import com.croco2d.screens.CrocoScreenNavigator;
	import com.croco2d.screens.FlashBootStrapScreen;
	import com.croco2d.screens.StarlingBootStrapScreen;
	import com.croco2d.tmx.scene.ornaments.OrtAnimationSetSpriteEntity;
	import com.croco2d.tmx.scene.ornaments.OrtAnimationSpriteEntity;
	import com.croco2d.tmx.scene.ornaments.OrtImageEntity;
	import com.croco2d.tmx.scene.ornaments.OrtLineUVAnimationEntity;
	import com.croco2d.tmx.scene.ornaments.OrtParticalSpriteEntity;
	import com.croco2d.tmx.scene.ornaments.OrtSurroundingSoundEntity;
	import com.llamaDebugger.Logger;
	
	import feathers.controls.ScreenNavigatorItem;

	//data format see ObjectFactoryUtil.newInstanceFromConfig
	public class AppConfig
	{
		//system Chars Key Define
		//----------------------------------------------------------------------
		//global.
		public static const KEY_APPBOOTSTRAP:String = "appBootstrap";
		public static const KEY_STARLING:String = "starling";
		public static const KEY_CROCO_ENGINE:String = "crocoEngine";
		
		public static const KEY_GLOBAL_ASSETS_MANAGER:String = "globalAssetsManager";
		
		public static const KEY_CAMERA:String = "camera";
		public static const KEY_INPUT_MANAGER:String = "inputManager";
		public static const KEY_SOUND_MANAGER:String = "soundManager";
		public static const KEY_KEY_BOARD_CONTROLLER:String = "keyboardController";
		
		public static const KEY_SCREEN_ID:String = "screenID";
		public static const KEY_HUB_SCREEN_ID:String = "hubScreenID";
		public static const KEY_OWNER_SCREEN_ID:String = "ownerScreenID";
		public static const KEY_SCREEN_ASSET_MANAGER:String = "screenAssetManager";
		//----------------------------------------------------------------------
		
		//system Path Define
		//if u modify the path u'd better modify all.
		//----------------------------------------------------------------------
		public static var PATH_ROOT_URL:String = ".";
		public static var PATH_ASSETS_URL:String = PATH_ROOT_URL + "/assets";
		public static var PATH_APP_URL:String = PATH_ASSETS_URL + "/app";
		
		public static var PATH_PRELOAD_URL:String = PATH_APP_URL + "/preload";
		public static var PATH_SHARED_URL:String = PATH_APP_URL + "/shared";
		public static var PATH_SCREENS_URL:String = PATH_APP_URL + "/screens";
		
		//System path finding helper method.
		//----------------------------------------------------------------------
		public static var findRootResourcePath:Function = function(relativeURL:String):String {
			return PATH_ROOT_URL + "/" + relativeURL;
		}
		
		public static var findAssetsResourcePath:Function = function(relativeURL:String):String {
			return PATH_ASSETS_URL + "/" + relativeURL;
		}
		
		public static var findAppResourcePath:Function = function(relativeURL:String):String {
			return PATH_APP_URL + "/" + relativeURL;
		}
		
		public static var findPreloadResourcePath:Function = function(relativeURL:String):String {
			return PATH_PRELOAD_URL + "/" + relativeURL;
		}
		
		public static var findSharedResourcePath:Function = function(relativeURL:String):String {
			return PATH_SHARED_URL + "/" + relativeURL;
		}
		
		public static var findScreenPath:Function = function(screenId:String):String {
			return PATH_SCREENS_URL + "/" + screenId;
		}
		
		public static var findScreenResourcePath:Function = function(screenId:String, relativeURL:String):String {
			return findScreenPath(screenId) + "/" + relativeURL;
		}
			
			//----------------------------------------------------------------------
		
		
		//system config  Define
		//----------------------------------------------------------------------
		
		//global evn config.
		public static var globalEvnConfig:Object = 
		{
			//1.3333~ 1.777 ratio.
			designWidth:960,
			designHeight:600,
			backgroundColor:0xFFFFFF,
			frameRate:60,
			textureScaleFactor:1.0,
			textureUseMipmaps:false,
			pauseEngineWhenDeActivated:true,
			pauseRenderingWhenDeActivated:true,
			startupLogger:true
		}
		
		//system callback config
		public static var systemCallbackConfig:Object = 
		{
			preInitCallbackConfig:
			{
				onAppPreInitedCallback:null,
				onGlobalPropertyBagInitedCallback:null,
				onStarlingInitedCallback:null,
				onAppPreInitCompletedCallback:null
			},
			
			initCallbackConfig:
			{
				onAppInitedCallback:null,
				onBootStrapScreenInitedCallback:null,
				onScreensInitedCallback:null,
				onFeathersInitedCallback:null,
				onCrocoEngineInitedCallback:null,
				onAppAssetsPreloadInitedCallback:null,
				onAppAssetsPreloadStartedCallback:null,
				onAppAssetsPreloadCompletedCallback:null,
				onAppInitCompletedCallback:null
			},
			
			systemEventCallbackConfig:
			{
				onAppBootStrapCompletedCallback:null,
				onStarlingContextLostCallback:null,//event
				onAppActivatedCallback:null,//event
				onAppDeActivatedCallback:null//event
			}
		}
		
		//----------------------------------------------------------------------
		/**
		 * each item reference will write in the GlobalPropertyBag
		 * 	
		 * key => Instance
		 * or
		 * key => Json Config.
		 * 
		 */		
		public static var globalPropertyBagConfig:Object = 
		{
		}
			
		//Starling framework config.
		public static var starlingConfig:Object = 
		{
			clsProps:
			{
				handleLostContext:false,
				multitouchEnabled:false
			},
			
			clsType:"(class)starling.core::Starling",
			
			ctorParams:
			[
				"(class)com.croco2d.screens::CrocoScreenNavigator",
				"(stage)",
				"(null)", 
				"(null)", 
				"auto", 
				"baselineConstrained"
			],
			
			props:
			{
				enableErrorChecking:false,
				showStats:false,
				antiAliasing:0,
				simulateMultitouch:false
			}
		}
		//----------------------------------------------------------------------
		
		
		//feathers UI FrameWork.
		//----------------------------------------------------------------------
		public static var feathersConfig:Object = 
		{
			//eg. "com.example.FeatherDefaultTheme"
			clsType:null
		}
		

		/**
		 * cls: BootStrapScreen //the bootStrapSceen impl Class
		 * launchImage:"launchImage.png" //the image name of the resource, fileFormat support swf , png, jpg
		 * fadeOutTime:10 //the BootStrapScreen fadout time.
		 */
		public static var bootStrapSceenConfig:Object = 
		{
			clsType:"(class)com.croco2d.screens::FlashBootStrapScreen",
			
			props:
			{
				launchImage:"launchImage.png",
				fadeoutTime:2
			}
		}
		
		//each pluginComponent 
		//data format see ObjectFactoryUtil.newInstanceFromConfig
		public static var crocoEngineConfig:Object = 
		{
			clsProps:
			{
				timeScale:1.0,
				debug:true,
				tickDeltaTime:1.0 / 60,
				maxTicksPerFrame:5
			},
			
			clsType:"(class)com.croco2d::CrocoEngine",
			
			props:
			{
				initComponents:
				[
					{
						clsType:"(class)com.croco2d.core::CrocoCamera"
					},
					{
						clsType:"(class)com.croco2d.input::InputManager",
						props:
						{
							initInputControllers:
							[
								{
									clsType:"(class)com.croco2d.input.controllers::KeyboardController"
								}
							]
						}
					},
					{
						clsType:"(class)com.croco2d.sound::SoundManager",
						props:
						{
							maxConcurrentSounds:10
						}
					},
					{
						clsType:"(class)com.croco2d.assets::CrocoAssetsManager",
						props:
						{
							name:AppConfig.KEY_GLOBAL_ASSETS_MANAGER
						}
					}
				]
			}
		}
		
		public static var screensConfig:Array = 
		[
			{
				clsType:"(class)feathers.controls::ScreenNavigatorItem",
				
				ctorParams:
				[
					"(class)com.croco2d.screens::CrocoScreen",
					"(null)",
					{
						screenID:"DefaultScreen",
						hubScreenID:"PreloadHubScreen"
					}
				]
			},
			
			//hub screens
			{
				clsType:"(class)feathers.controls::ScreenNavigatorItem",
				
				ctorParams:
				[
					"(class)com.croco2d.screens::PreloadHubScreen",
					"(null)",
					{
						screenID:"PreloadHubScreen"
					}
				]
			}
		];
		
		//constractor.
		//----------------------------------------------------------------------
		public function AppConfig()
		{
			Logger.info("appConfigInit.");
		}
		
		//Strong Reference Clsses.
		//----------------------------------------------------------------------
		ScreenNavigatorItem;
		CrocoScreenNavigator;
		FlashBootStrapScreen;
		StarlingBootStrapScreen;
		KeyboardController;
		CrocoAssetsManager;
		
		OrtAnimationSetSpriteEntity;
		OrtAnimationSpriteEntity;
		OrtImageEntity;
		OrtLineUVAnimationEntity;
		OrtParticalSpriteEntity;
		OrtSurroundingSoundEntity;
		//----------------------------------------------------------------------
	}
}