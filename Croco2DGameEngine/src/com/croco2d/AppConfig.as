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
	
	import flash.filesystem.File;
	
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
		
		public static const KEY_RENDER_COMPONENT:String = "renderComponent";
		//----------------------------------------------------------------------
		
		//system Path Define
		//if u modify the path u'd better modify all.
		//----------------------------------------------------------------------
		public static var PATH_ROOT_DIR:String = ".";
		public static var PATH_ROOT_DIR_FILE:File = File.applicationDirectory;
		
		public static var findRootResourcePath:Function = function(rootRelativeURL:String):String 
		{
			return PATH_ROOT_DIR + "/" + rootRelativeURL;
		}

		public static var findRootResourceFile:Function = function(rootRelativeURL:String):File
		{
			return PATH_ROOT_DIR_FILE.resolvePath(rootRelativeURL);
		}
			
		//assets
		public static var PATH_ASSETS_DIR:String = PATH_ROOT_DIR + "/assets";
		public static var PATH_ASSETS_DIR_FILE:File = PATH_ROOT_DIR_FILE.resolvePath(PATH_ASSETS_DIR);
		
		public static var findAssetsResourcePath:Function = function(assetsRelativeURL:String):String 
		{
			return PATH_ASSETS_DIR + "/" + assetsRelativeURL;
		}
			
		public static var findAssetsResourceFile:Function = function(assetsRelativeURL:String):File 
		{
			return PATH_ASSETS_DIR_FILE.resolvePath(assetsRelativeURL);
		}
		
		//assets/app
		public static var PATH_APP_DIR:String = PATH_ASSETS_DIR + "/app";
		public static var FILE_APP_DIR:File = PATH_ROOT_DIR_FILE.resolvePath(PATH_APP_DIR);
		
		public static var findAppResourcePath:Function = function(appRelativeURL:String):String 
		{
			return PATH_APP_DIR + "/" + appRelativeURL;
		}
		
		public static var findAppResourceFile:Function = function(appRelativeURL:String):File 
		{
			return FILE_APP_DIR.resolvePath(appRelativeURL);
		}
		
		//assets/app/preload
		public static var PATH_PRELOAD_DIR:String = PATH_APP_DIR + "/preload";
		public static var FILE_PRELOAD_DIR:File = PATH_ROOT_DIR_FILE.resolvePath(PATH_PRELOAD_DIR);
		
		public static var findPreloadResourcePath:Function = function(preloadRelativeURL:String):String 
		{
			return PATH_PRELOAD_DIR + "/" + preloadRelativeURL;
		}
		
		public static var findPreloadResourceFile:Function = function(preloadRelativeURL:String):File 
		{
			return FILE_PRELOAD_DIR.resolvePath(preloadRelativeURL);
		}

		//assets/app/shared
		public static var PATH_SHARED_DIR:String = PATH_APP_DIR + "/shared";
		public static var FILE_SHARED_DIR:File = PATH_ROOT_DIR_FILE.resolvePath(PATH_SHARED_DIR);
		
		public static var findSharedResourcePath:Function = function(sharedRelativeURL:String):String 
		{
			return PATH_SHARED_DIR + "/" + sharedRelativeURL;
		}
		
		public static var findSharedResourceFile:Function = function(sharedRelativeURL:String):File 
		{
			return FILE_SHARED_DIR.resolvePath(sharedRelativeURL);
		}
		
		//assets/app/screens
		public static var PATH_SCREENS_DIR:String = PATH_APP_DIR + "/screens";
		public static var FILE_SCREENS_DIR:File = PATH_ROOT_DIR_FILE.resolvePath(PATH_SCREENS_DIR);
		
		public static var findScreensResourcePath:Function = function(screensRelativeURL:String):String 
		{
			return PATH_SCREENS_DIR + "/" + screensRelativeURL;
		}
		
		public static var findScreensResourceFile:Function = function(screensRelativeURL:String):File 
		{
			return FILE_SHARED_DIR.resolvePath(screensRelativeURL);
		}
			
		public static var findScreenResourcePath:Function = function(screenName:String, screenRelativeURL:String):String 
		{
			return findScreensResourcePath(screenName + "/" + screenRelativeURL);
		}
			
		public static var findScreenResourceFile:Function = function(screenName:String, screenRelativeURL:String):File 
		{
			var screenDirFile:File = findScreensResourceFile(screenName);
			return screenDirFile.resolvePath(screenRelativeURL);
		}
		
		//assets/app/scenes
		public static var PATH_SCENES_DIR:String = PATH_APP_DIR + "/scenes";
		public static var FILE_SCENES_DIR:File = PATH_ROOT_DIR_FILE.resolvePath(PATH_SCENES_DIR);
		
		public static var findScenesResourcePath:Function = function(scenesRelativeURL:String):String 
		{
			return PATH_SCENES_DIR + "/" + scenesRelativeURL;
		}
			
		public static var findScenesResourceFile:Function = function(scenesRelativeURL:String):File 
		{
			return FILE_SCENES_DIR.resolvePath(scenesRelativeURL);
		}
			
		public static var findSceneResourcePath:Function = function(sceneName:String, sceneRelativeURL:String):String 
		{
			return findScenesResourcePath(sceneName + "/" + sceneRelativeURL);
		}
		
		public static var findSceneResourceFile:Function = function(sceneName:String, sceneRelativeURL:String):File 
		{
			var sceneDirFile:File = findScenesResourceFile(sceneName);
			return sceneDirFile.resolvePath(sceneRelativeURL);
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