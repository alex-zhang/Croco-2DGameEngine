package com.croco2d.screens
{
	import com.croco2d.AppBootStrap;

	public interface IBootStrapScreen
	{
		function set bootStrap(value:AppBootStrap):void;
		
		function launch():void;
		
		function onAssetsPreloadProgress(progress:Number):void;
		
		function dispose():void;
	}
}