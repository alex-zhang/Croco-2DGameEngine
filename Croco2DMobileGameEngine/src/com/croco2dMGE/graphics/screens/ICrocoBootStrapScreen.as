package com.croco2dMGE.graphics.screens
{
	import com.croco2dMGE.bootStrap.CrocoBootStrap;

	public interface ICrocoBootStrapScreen
	{
		function set bootStrap(value:CrocoBootStrap):void;
		
		function launch(imagePath:String):void;
		function onAssetsPreloadProgress(progress:Number):void;
		function dispose():void;
	}
}