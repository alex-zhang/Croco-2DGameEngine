package com.croco2dMGE.screens
{
	import com.croco2dMGE.AppBootStrap;
	import com.croco2dMGE.AppConfig;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	public class BootStrapScreen extends Sprite implements IBootStrapScreen
	{
		protected var mLaunchImageLoader:Loader;
		protected var mBootStrap:AppBootStrap;
		
		protected var mLaunchImageLoaded:Boolean = false;
		protected var mAssetsPreloaded:Boolean = false;
		
		protected var mFadeoutLastTime:int = 0;
		protected var mFadeoutCurTime:Number = 0;
		protected var mFadeoutTotalTime:Number = 0;
		
		protected var mConfig:Object;
		
		public function BootStrapScreen()
		{
			super();
		}
		
		public function set bootStrap(value:AppBootStrap):void
		{
			mBootStrap = value;
		}
		
		//step1.
		public function launch(config:Object = null):void
		{
			mConfig = config;
			
			mAssetsPreloaded = false;
			
			var launchImageURL:String = AppConfig.findAppPathResource(AppConfig.bootStrapSceen.launchImage);
				
			var launchImageFile:File = File.applicationDirectory.resolvePath(launchImageURL);
			
			if(launchImageFile.exists)
			{
				mLaunchImageLoader = new Loader();
				
				mLaunchImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, launchImageLoaderLoadCompletedHandler);
				
				mLaunchImageLoaded = false;
				
				mLaunchImageLoader.load(new URLRequest(launchImageURL));
				
				this.addChild(mLaunchImageLoader);
			}
			else
			{
				mLaunchImageLoaded = true;
			}
			
			layout(stage.stageWidth, stage.stageHeight);
			
			this.stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function stageResizeHandler(event:Event):void
		{
			layout(stage.stageWidth, stage.stageHeight);
		}
		
		protected function layout(stageWidth:int, stageHeight):void
		{
			if(mLaunchImageLoader && mLaunchImageLoaded)
			{
				mLaunchImageLoader.x = (stage.stageWidth - mLaunchImageLoader.width) * 0.5;
				mLaunchImageLoader.y = (stage.stageHeight - mLaunchImageLoader.height) * 0.5;
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
			if(mConfig && mConfig.fadeoutTime > 0)
			{
				mFadeoutCurTime = 0.0;
				mFadeoutTotalTime = mConfig.fadeoutTime;
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

			if(mFadeoutCurTime > mFadeoutTotalTime)
			{
				mFadeoutCurTime = 0.0;
				
				this.removeEventListener(Event.ENTER_FRAME, fadeoutEffectEnterframeHandler);
				
				onFadeoutEffectCompleted();
			}
			else
			{
				this.alpha = 1- mFadeoutCurTime / mFadeoutTotalTime;
			}
		}
		
		protected function onFadeoutEffectCompleted():void
		{
			this.stage.removeEventListener(Event.RESIZE, stageResizeHandler);
			
			dispatchBootStrapCompleteEvent();
		}
		
		protected function dispatchBootStrapCompleteEvent():void
		{
			mBootStrap.dispatchEvent(new Event(AppBootStrap.BOOT_STRAP_COMPLETE));
		}

		public function dispose():void
		{
			if(mLaunchImageLoader)
			{
				mLaunchImageLoader.unloadAndStop(false);
				
				this.removeChild(mLaunchImageLoader);
				
				mLaunchImageLoader = null;
			}
		}
	}
}