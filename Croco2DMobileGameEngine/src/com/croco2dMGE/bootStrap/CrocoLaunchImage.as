package com.croco2dMGE.bootStrap
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class CrocoLaunchImage extends Sprite implements ICrocoLaunchImage
	{
		protected var launchImageLoader:Loader;
		
		public function CrocoLaunchImage()
		{
			super();
		}
		
		public function launch(imagePath:String):void
		{
			var launchImageFile:File = File.applicationDirectory.resolvePath(imagePath);
			if(launchImageFile.exists)
			{
//				var bytes:ByteArray = new ByteArray();
//				var stream:FileStream = new FileStream();
//				stream.open(launchImageFile, FileMode.READ);
//				stream.readBytes(bytes, 0, stream.bytesAvailable);
//				stream.close();
				
				launchImageLoader = new Loader();
				launchImageLoader.load(new URLRequest(imagePath));
//				launchImageLoader.loadBytes(bytes);
				this.addChild(launchImageLoader);
			}
		}
		
		public function onAssetsPreloadProgress(progress:Number):void
		{
		}
		
		public function dispose():void
		{
			if(launchImageLoader)
			{
				if(launchImageLoader.content is Bitmap)
				{
					Bitmap(launchImageLoader.content).bitmapData.dispose();
				}
				
				try
				{
					launchImageLoader.close();
				}
				catch(error:Error) {};
				
				this.removeChild(launchImageLoader);
				launchImageLoader = null;
			}
		}
	}
}