package com.croco2dMGE.bootStrap
{
	import feathers.controls.ScreenNavigator;

	public class CrocoBootStrapConfig
	{
		public static var designWidth:int = 960;
		public static var designHeight:int = 640;

		public static var backgroundColor:uint = 0;//default
		
		public static var frameRate:int = 60;//default
		
		public static var starlingRootClass:Class = ScreenNavigator;//default
		public static var starlingHandleLostContext:Boolean = false;
		public static var starlingMultitouchEnabled:Boolean = false;
		public static var starlingProfile:String = "baselineConstrained"; 
		
		public static var feathersThemeClass:Class = null;
		
		public static var preLoadAssetsPath:String = "assets/preload";
		
		public static var launchImagePath:String = "assets/launchImage.png"
		public static var launchImageClass:Class = CrocoLaunchImage;
		
		public static var screens:Array;//[[Name, ScreenClass, [constructorParameters...]], ...]
		public static var extentions:Array;//[["AssetManager", AssetManager, [constructorParameters...]]];//default
		
		public function CrocoBootStrapConfig(bootStrap:CrocoBootStrap):void
		{
		}
	}
}