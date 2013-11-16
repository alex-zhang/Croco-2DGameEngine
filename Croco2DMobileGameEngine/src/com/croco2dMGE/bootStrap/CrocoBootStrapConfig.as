package com.croco2dMGE.bootStrap
{
	import com.croco2dMGE.graphics.screens.AssetsPreloadHubScreen;
	import com.croco2dMGE.graphics.screens.CrocoBootStrapScreen;
	import com.croco2dMGE.graphics.screens.CrocoScreen;
	import com.croco2dMGE.graphics.screens.CrocoScreenNavigator;
	import com.croco2dMGE.utils.CrocoAssetsManager;

	public class CrocoBootStrapConfig
	{
		//System Path Define
		public static var ASSETS_PRELOAD_DIR_PATH:String = "assets/app/preload/";
		public static var ASSETS_LAUNCH_IMAGE_DIR_PATH:String = "assets/app/";
		public static var ASSETS_SCREENS_DIR_PATH:String = "assets/app/screens/";
		
		//System Chars Key Define
		public static var KEY_APPP_RELOAD_ASSETS_MANAGER:String = "appPreloadAssetsManager";
		public static var KEY_JUMP2TARGET_SCEEN_ID:String = "jump2TargetSceenId";
		public static var KEY_HUB_SCREEN_ID:String = "hubScreenID";
		public static var KEY_SCEEN_PRELOAD_ASSETS_MANAGER:String = "sceenPreLoadAssetsManager";
		
		//1.777~1.3333
		public static var designWidth:int = 960;
		public static var designHeight:int = 640;

		public static var backgroundColor:uint = 0;//default
		
		public static var frameRate:int = 60;//default
		
		public static var starlingRootClass:Class = CrocoScreenNavigator;//default
		public static var starlingHandleLostContext:Boolean = false;
		public static var starlingMultitouchEnabled:Boolean = false;
		public static var starlingProfile:String = "baselineConstrained"; 
		
		public static var feathersThemeClass:Class = null;
		
		public static var bootStrapScreenClass:Class = CrocoBootStrapScreen;

		public static var launchImageName:String = "launchImage.png";
		
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
													name: CrocoBootStrapConfig.KEY_APPP_RELOAD_ASSETS_MANAGER,
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
		 * 			hub:"AssetsPreloadHubScreen"
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
		
		public function CrocoBootStrapConfig(bootStrap:CrocoBootStrap):void
		{
		}
	}
}