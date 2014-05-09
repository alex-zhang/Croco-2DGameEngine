package com.croco2d
{
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.input.controllers.KeyboardController;
	import com.croco2d.screens.CrocoScreen;
	import com.croco2d.screens.CrocoScreenNavigator;
	import com.croco2d.screens.FlashBootStrapScreen;
	import com.croco2d.screens.PreloadHubScreen;
	import com.croco2d.screens.SceneScreen;
	import com.croco2d.screens.StarlingBootStrapScreen;
	import com.croco2d.utils.tmx.scene.ornaments.OrtAnimationSetSpriteEntity;
	import com.croco2d.utils.tmx.scene.ornaments.OrtAnimationSpriteEntity;
	import com.croco2d.utils.tmx.scene.ornaments.OrtImageEntity;
	import com.croco2d.utils.tmx.scene.ornaments.OrtLineUVAnimationEntity;
	import com.croco2d.utils.tmx.scene.ornaments.OrtParticalSpriteEntity;
	import com.croco2d.utils.tmx.scene.ornaments.OrtSurroundingSoundEntity;
	import com.fireflyLib.debug.Logger;

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
		public static const KEY_ENTRY_SCREEN_DATA:String = "entryScreenData";
		public static const KEY_JUMP2TARGET_SCREEN_ID:String = "jump2TargetScreenId";
		public static const KEY_SCREEN_ID:String = "screenId";
		public static const KEY_SCENE_ID:String = "sceneId";
		public static const KEY_HUB_SCREEN_ID:String = "hubScreenId";
		public static const KEY_SCEEN_ASSETS_MANAGER:String = "screenAssetsManager";
		
		public static const KEY_CAMERA:String = "camera";
		public static const KEY_INPUT_MANAGER:String = "inputManager";
		public static const KEY_SOUND_MANAGER:String = "soundManager";
		public static const KEY_KEY_BOARD_CONTROLLER:String = "keyboardController";
		//----------------------------------------------------------------------
		
		//system Path Define
		//if u modify the path u'd better modify all.
		//----------------------------------------------------------------------
		public static var PATH_ROOT_URL:String = "";
		public static var PATH_ASSETS_URL:String = PATH_ROOT_URL + "assets/";
		public static var PATH_APP_URL:String = PATH_ASSETS_URL + "app/";
		
		public static var PATH_PRELOAD_URL:String = PATH_APP_URL + "preload/";
		public static var PATH_SHARED_URL:String = PATH_APP_URL + "shared/";
		public static var PATH_SCREENS_URL:String = PATH_APP_URL + "screens/";
		public static var PATH_SCENES_URL:String = PATH_APP_URL + "scenes/";
		
		//system config  Define
		//----------------------------------------------------------------------
		
		//global config.
		public static var globalParamsConfig:Object = 
		{
			//1.3333~ 1.777 ratio.
			designWidth:960,
			designHeight:600,
			backgroundColor:0,
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
				onGlobalObjectsInitedCallback:null,
				onStarlingInitedCallback:null,
				onAppPreInitCompletedCallback:null
			},
			
			initCallbackConfig:
			{
				onAppInitedCallback:null,
				onBootStrapScreenInitedCallback:null,
				onFeathersInitedCallback:null,
				onScreensInitedCallback:null,
				onCrocoEngineInitedCallback:null,
				onAppAssetsPreloadInitedCallback:null,
				onAppAssetsPreloadStartedCallback:null,
				onAppAssetsPreloadCompletedCallback:null,
				onAppInitCompletedCallback:null
			},
			
			systemEventCallbackConfig:
			{
				onAppBootStrapCompletedCallback:null,
				onAppBootStrapEntryScreenCallback:null,//entryScreenconfig.
				onStarlingContextLostCallback:null,//event
				onAppActivatedCallback:null,//event
				onAppDeActivatedCallback:null//event
			}
		}
		
		//----------------------------------------------------------------------
		/**
		 * each item reference will write in the GlobalPropertyBag
		 */		
		public static var globalObjectsConfig:Array = 
		[
		]
			
		//Starling framework config.
		public static var starlingConfig:Object = 
		{
			clsProperties:
			{
				handleLostContext:false,
				multitouchEnabled:false
			},
			
			clsType:"starling.core::Starling",
			
			constructorParams:
			[
				"(class)com.croco2d.screens::CrocoScreenNavigator",
				"(stage)",
				null, 
				null, 
				"auto", 
				"baselineConstrained"
			],
			
			properties:
			{
				enableErrorChecking:false,
				showStats:true,
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
			clsType:"com.croco2d.screens::FlashBootStrapScreen",
			
			properties:
			{
				launchImage:"launchImage.png",
				fadeoutTime:2
			}
		}
		
		//each pluginComponent 
		//data format see ObjectFactoryUtil.newInstanceFromConfig
		public static var crocoEngineConfig:Object = 
		{
			clsProperties:
			{
				timeScale:1.0,
				debug:true,
				tickDeltaTime:1.0 / 60,
				maxTicksPerFrame:5
			},
			
			clsType:"com.croco2d::CrocoEngine",
			
			properties:
			{
				initComponents:
				[
					{
						clsType:"com.croco2d.entities::CrocoCamera",
						properties:
						{
							name:AppConfig.KEY_CAMERA
						}
					},
					{
						clsType:"com.croco2d.input::InputManager",
						properties:
						{
							initInputControllers:
							[
								{
									clsType:"com.croco2d.input.controllers::KeyboardController",
									properties:
									{
										name:AppConfig.KEY_KEY_BOARD_CONTROLLER
									}
								}
							]
						}
					},
					{
						clsType:"com.croco2d.sound::SoundManager",
						
						properties:
						{
							maxConcurrentSounds:10
						}
					},
					{
						clsType:"com.croco2d.assets::CrocoAssetsManager",
						properties:
						{
							name:AppConfig.KEY_GLOBAL_ASSETS_MANAGER
						}
					}
				]
			}
		}
		
		/**
		 * [
		 * 
		 */	
		public static var screensConfig:Array = [
			//normal screens
			{
				screenId:"DefaultScreen",
				
				clsType:"feathers.controls::ScreenNavigatorItem",
				
				constructorParams:
				[
					"(class)com.croco2d.screens::CrocoScreen",
					
					{
					},
					
					{
						entryScreenData: 
						{
							hubScreenId:"PreloadHubScreen"
						}
					}
				]
			},
			
			//hub screens
			{
				screenId:"PreloadHubScreen",
				
				clsType:"feathers.controls::ScreenNavigatorItem",
				
				constructorParams:
				[
					"(class)com.croco2d.screens::PreloadHubScreen",
					
					{
					},
					
					{
						entryScreenData:
						{
						
						}
					}
				]
			}
		];
		
		//constractor.
		//----------------------------------------------------------------------
		public function AppConfig()
		{
			Logger.info(this, "appConfigInit.");
		}
		
		
		//System path finding helper method.
		//----------------------------------------------------------------------
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
		//----------------------------------------------------------------------
		
		//the context.	
		public static var appBootStrap:AppBootStrap; 
		
		//Strong Reference Clsses.
		//----------------------------------------------------------------------
		FlashBootStrapScreen;
		PreloadHubScreen;
		SceneScreen;
		CrocoScreen;
		StarlingBootStrapScreen;
		CrocoScreenNavigator;
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