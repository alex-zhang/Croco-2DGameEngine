package com.croco2dMGE.screens
{
	import com.croco2dMGE.AppBootStrap;

	public interface IBootStrapScreen
	{
		function set bootStrap(value:AppBootStrap):void;
		
		function launch(config:Object = null):void;
		
		function onAssetsPreloadProgress(progress:Number):void;
		
		function dispose():void;
	}
}