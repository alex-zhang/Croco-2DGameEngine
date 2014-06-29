package com.croco2d.screens
{
	import com.croco2d.AppConfig;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import com.croco2d.AppBootStrap;

	public class FlashBootStrapScreen extends Sprite implements IBootStrapScreen
	{
		public var launchImage:String;
		public var fadeoutTime:Number = 0;
		
		protected var mLaunchImageLoader:Loader;
		protected var mBootStrap:AppBootStrap;
		
		protected var mLaunchImageLoaded:Boolean = false;
		protected var mAssetsPreloaded:Boolean = false;
		
		protected var mFadeoutLastTime:int = 0;
		protected var mFadeoutCurTime:Number = 0;
		
		protected var mLaunchImage:DisplayObject;
		
		protected var mStage:Stage;
		
		public function FlashBootStrapScreen()
		{
			super();
		}
		
		public function set bootStrap(value:AppBootStrap):void
		{
			mBootStrap = value;
		}
		
		//step1.
		public function launch():void
		{
			mAssetsPreloaded = false;
			
			var launchImageURL:String = AppConfig.findAppResourcePath(launchImage);
			var launchImageFile:File = File.applicationDirectory.resolvePath(launchImageURL);
			
			if(launchImageFile.exists)
			{
				mLaunchImageLoader = new Loader();
				
				mLaunchImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, launchImageLoaderLoadCompletedHandler);
				mLaunchImageLoaded = false;
				mLaunchImageLoader.load(new URLRequest(launchImageURL));
			}
			else
			{
				mLaunchImageLoaded = true;
				
				fadeoutBootStrapScreen();
			}
			
			mStage = this.stage;
			mStage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function stageResizeHandler(event:Event):void
		{
			layout(stage.stageWidth, stage.stageHeight);
		}
		
		protected function layout(stageWidth:int, stageHeight):void
		{
			if(mLaunchImage)
			{
				mLaunchImage.x = (mStage.stageWidth - mLaunchImage.width) * 0.5;
				mLaunchImage.y = (mStage.stageHeight - mLaunchImage.height) * 0.5;
			}
		}
		
		private function launchImageLoaderLoadCompletedHandler(event:Event):void
		{
			mLaunchImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, launchImageLoaderLoadCompletedHandler);
			mLaunchImageLoaded = true;
			
			layout(stage.stageWidth, stage.stageHeight);
			
			onLaunchImageLoaded();
		}
		
		public function onAssetsPreloadProgress(progress:Number):void
		{
			if(progress == 1)
			{
				mAssetsPreloaded = true;
				
				onAssetsPreloaded();
			}
		}
		
		protected function onLaunchImageLoaded():void
		{
			mLaunchImage = mLaunchImageLoader.content;
			addChild(mLaunchImage);
			layout(stage.stageWidth, stage.stageHeight);
			
			if(mAssetsPreloaded)
			{
				fadeoutBootStrapScreen();
			}
		}
		
		protected function onAssetsPreloaded():void
		{
			if(mLaunchImageLoaded)
			{
				fadeoutBootStrapScreen();
			}
		}
		
		//step2.
		protected function fadeoutBootStrapScreen():void
		{
			if(fadeoutTime > 0)
			{
				mFadeoutCurTime = 0.0;
				mFadeoutLastTime = getTimer();
				
				this.addEventListener(Event.ENTER_FRAME, fadeoutEffectEnterframeHandler);
			}
			else
			{
				onFadeoutEffectCompleted();	
			}
		}
		
		protected function fadeoutEffectEnterframeHandler(event:Event):void
		{
			var curTime:int = getTimer();
			var deltaTimer:Number = (curTime - mFadeoutLastTime) * 0.001; 
			mFadeoutLastTime = curTime;
			
			mFadeoutCurTime += deltaTimer;
			if(mFadeoutCurTime >= fadeoutTime)
			{
				mFadeoutCurTime = 0.0;
				
				this.removeEventListener(Event.ENTER_FRAME, fadeoutEffectEnterframeHandler);
				
				onFadeoutEffectCompleted();
			}
			else
			{
				this.alpha = 1- mFadeoutCurTime / fadeoutTime;
			}
		}
		
		protected function onFadeoutEffectCompleted():void
		{
			this.stage.removeEventListener(Event.RESIZE, stageResizeHandler);
			
			dispatchBootStrapCompleteEvent();
		}
		
		protected function dispatchBootStrapCompleteEvent():void
		{
			mBootStrap.dispatchEvent(new Event(AppBootStrap.EVENT_BOOT_STRAP_COMPLETE));
		}

		public function dispose():void
		{
			if(mStage)
			{
				mStage.removeEventListener(Event.RESIZE, stageResizeHandler);
				mStage = null;
			}
			
			if(mLaunchImageLoader)
			{
				mLaunchImageLoader.unloadAndStop(false);
				mLaunchImageLoader = null;
			}
			
			if(mLaunchImage)
			{
				if(mLaunchImage is Bitmap && Bitmap(mLaunchImage).bitmapData)
				{
					Bitmap(mLaunchImage).bitmapData.dispose();
					Bitmap(mLaunchImage).bitmapData = null;
				}

				removeChild(mLaunchImage);
				mLaunchImage = null;
			}
		}
	}
}