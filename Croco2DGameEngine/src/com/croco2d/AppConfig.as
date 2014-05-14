package com.croco2d
{
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.bootStrap.FlashBootStrapScreen;
	import com.croco2d.bootStrap.StarlingBootStrapScreen;
	import com.croco2d.input.controllers.KeyboardController;
	import com.croco2d.utils.tmx.scene.ornaments.OrtAnimationSetSpriteEntity;
	import com.croco2d.utils.tmx.scene.ornaments.OrtAnimationSpriteEntity;
	import com.croco2d.utils.tmx.scene.ornaments.OrtImageEntity;
	import com.croco2d.utils.tmx.scene.ornaments.OrtLineUVAnimationEntity;
	import com.croco2d.utils.tmx.scene.ornaments.OrtParticalSpriteEntity;
	import com.croco2d.utils.tmx.scene.ornaments.OrtSurroundingSoundEntity;
	import com.llamaDebugger.Logger;

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
		public static const KEY_SCENE_ASSETS_MANAGER:String = "sceneAssetsManager";
		
		public static const KEY_CAMERA:String = "camera";
		public static const KEY_INPUT_MANAGER:String = "inputManager";
		public static const KEY_SOUND_MANAGER:String = "soundManager";
		public static const KEY_KEY_BOARD_CONTROLLER:String = "keyboardController";
		//----------------------------------------------------------------------
		
		//system Path Define
		//if u modify the path u'd better modify all.
		//----------------------------------------------------------------------
		public static var PATH_ROOT_URL:String = "";
		public static var PATH_ASSETS_URL:String = PATH_ROOT_URL + "/assets";
		public static var PATH_APP_URL:String = PATH_ASSETS_URL + "/app";
		
		public static var PATH_PRELOAD_URL:String = PATH_APP_URL + "/preload";
		public static var PATH_SHARED_URL:String = PATH_APP_URL + "/shared";
		public static var PATH_SCENES_URL:String = PATH_APP_URL + "/scenes";
		
		//system config  Define
		//----------------------------------------------------------------------
		
		//global evn config.
		public static var globalEvnConfig:Object = 
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
				onGlobalPropertyBagInitCallback:null,
				onStarlingInitedCallback:null,
				onAppPreInitCompletedCallback:null
			},
			
			initCallbackConfig:
			{
				onAppInitedCallback:null,
				onBootStrapScreenInitedCallback:null,
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
				onAppBootStrapEntryScreenCallback:null,//entryScreenconfig.
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
				"(class)starling.display::Sprite",
				"(stage)",
				null, 
				null, 
				"auto", 
				"baselineConstrained"
			],
			
			props:
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
						clsType:"(class)com.croco2d.scene::CrocoCamera",
						props:
						{
							name:AppConfig.KEY_CAMERA
						}
					},
					{
						clsType:"(class)com.croco2d.input::InputManager",
						props:
						{
							initInputControllers:
							[
								{
									clsType:"(class)com.croco2d.input.controllers::KeyboardController",
									props:
									{
										name:AppConfig.KEY_KEY_BOARD_CONTROLLER
									}
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
		
		/**
		 * [
		 * 
		 */	
//		public static var screensConfig:Array = [
//			//normal screens
//			{
//				screenId:"DefaultScreen",
//				
//				clsType:"feathers.controls::ScreenNavigatorItem",
//				
//				ctorParams:
//				[
//					"(class)com.croco2d.screens::CrocoScreen",
//					
//					{
//					},
//					
//					{
//						entryScreenData: 
//						{
//							hubScreenId:"PreloadHubScreen"
//						}
//					}
//				]
//			},
//			
//			//hub screens
//			{
//				screenId:"PreloadHubScreen",
//				
//				clsType:"feathers.controls::ScreenNavigatorItem",
//				
//				ctorParams:
//				[
//					"(class)com.croco2d.screens::PreloadHubScreen",
//					
//					{
//					},
//					
//					{
//						entryScreenData:
//						{
//						
//						}
//					}
//				]
//			}
//		];
		
		//constractor.
		//----------------------------------------------------------------------
		public function AppConfig()
		{
			Logger.info("appConfigInit.");
		}
		
		
		//System path finding helper method.
		//----------------------------------------------------------------------
		public static var findRootPathResource:Function = function(relativeURL:String):String {
			return PATH_ROOT_URL + "/" + relativeURL;
		}
		
		public static var findAssetsPathResource:Function = function(relativeURL:String):String {
			return PATH_ASSETS_URL + "/" + relativeURL;
		}
		
		public static var findAppPathResource:Function = function(relativeURL:String):String {
			return PATH_APP_URL + "/" + relativeURL;
		}
		
		public static var findPreloadPathResource:Function = function(relativeURL:String):String {
			return PATH_PRELOAD_URL + "/" + relativeURL;
		}
		
		public static var findSharedPathResource:Function = function(relativeURL:String):String {
			return PATH_SHARED_URL + "/" + relativeURL;
		}
		
		public static var findScenesPathResource:Function = function(relativeURL:String):String {
			return PATH_SCENES_URL + "/" + relativeURL;
		}
		
		public static var findTargetScenePathResource:Function = function(sceneName:String, relativeURL:String):String {
			return AppConfig.findScenesPathResource(sceneName + "/" + relativeURL);
		}
		//----------------------------------------------------------------------
		
		//Strong Reference Clsses.
		//----------------------------------------------------------------------
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