package com.croco2dMGE.bootStrap
{
	public interface ICrocoLaunchImage
	{
		function launch(imagePath:String):void;
		function onAssetsPreloadProgress(progress:Number):void;
		function dispose():void;
	}
}