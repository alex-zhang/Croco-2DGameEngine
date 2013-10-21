package com.croco2dMGE
{
	import flash.geom.Rectangle;
	
	import feathers.controls.ScreenNavigator;

	public class CrocoBootStrapConfig
	{
		public static var screenViewPort:Rectangle;
		
		public static var backgroundColor:uint;
		
		
		public static var frameRate:int = 60;//default
		
		public static var launchImage:String;
		
		public static var starlingRootClass:Class = ScreenNavigator;//default
		public static var starlingHandleLostContext:Boolean = false;
		public static var starlingMultitouchEnabled:Boolean = false;
		public static var starlingProfile:String = "baselineConstrained"; 
		
		public static var assetsScaleFactor:Number = 1.0;
		public static var assetsUseMipMaps:Boolean = false;
		public static var assetsPreLoad:Boolean = true;
		
		public static var themeClass:Class;
		
		
		public static var screens:Array;//[[Name, ScreenClass, [constructorParameters...]], ...]
		public static var extentions:Array;//[["AssetManager", AssetManager, [constructorParameters...]]];//default
		
		public function CrocoBootStrapConfig(context:Object):void
		{
		}
	}
}