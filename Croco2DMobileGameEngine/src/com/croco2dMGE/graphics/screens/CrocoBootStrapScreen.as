package com.croco2dMGE.graphics.screens
{
	import com.croco2dMGE.bootStrap.CrocoBootStrap;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;

	public class CrocoBootStrapScreen extends Sprite implements ICrocoBootStrapScreen
	{
		protected var mLaunchImageLoader:Loader;
		protected var mBootStrap:CrocoBootStrap;
		
		public function CrocoBootStrapScreen()
		{
			super();
		}
		
		public function set bootStrap(value:CrocoBootStrap):void
		{
			mBootStrap = value;
		}
		
		public function launch(imagePath:String):void
		{
			var launchImageFile:File = File.applicationDirectory.resolvePath(imagePath);
			if(launchImageFile.exists)
			{
				mLaunchImageLoader = new Loader();
				mLaunchImageLoader.load(new URLRequest(imagePath));
				this.addChild(mLaunchImageLoader);
			}
		}
		
		public function onAssetsPreloadProgress(progress:Number):void
		{
			if(progress == 1)
			{
				dispatchBootStrapCompleteEvent();
			}
		}
		
		protected function dispatchBootStrapCompleteEvent():void
		{
			mBootStrap.dispatchEvent(new Event(CrocoBootStrap.BOOT_STRAP_COMPLETE));
		}

		public function dispose():void
		{
			if(mLaunchImageLoader)
			{
				mLaunchImageLoader.unloadAndStop(false);
				
				try
				{
					mLaunchImageLoader.close();
				}
				catch(error:Error) {};
				
				this.removeChild(mLaunchImageLoader);
				mLaunchImageLoader = null;
			}
		}
	}
}