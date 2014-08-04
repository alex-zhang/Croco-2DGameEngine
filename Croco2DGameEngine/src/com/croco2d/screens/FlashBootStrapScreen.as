package com.croco2d.screens
{
	import com.croco2d.AppBootStrap;
	import com.croco2d.AppConfig;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import starling.animation.Tween;
	import starling.core.Starling;

	public class FlashBootStrapScreen extends Sprite implements IBootStrapScreen
	{
		public var launchImage:Object;//String, Class(bitmap), instance....
		public var fadeoutDelayTime:Number = 0;
		public var fadeoutTime:Number = 0;
		public var fadeoutProps:Object;
		
		protected var mLaunchImageLoader:Loader;
		protected var mBootStrap:AppBootStrap;
		
		protected var mLaunchImageLoaded:Boolean = false;
		protected var mAssetsPreloaded:Boolean = false;
		
		protected var mLaunchImage:DisplayObject;
		
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
			onLaunchImageLoadStart();
			
			this.stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		protected function onLaunchImageLoadStart():void
		{
			if(launchImage is Class) launchImage = new launchImage();
			
			if(launchImage is DisplayObject)
			{
				mLaunchImage = launchImage as DisplayObject;
				onLaunchImageLoaded();
			}
			else if(launchImage is String)
			{
				var launchImageURL:String = AppConfig.findAppResourcePath(launchImage);
				var launchImageFile:File = File.applicationDirectory.resolvePath(launchImageURL);
				
				if(launchImageFile.exists)
				{
					mLaunchImageLoader = new Loader();
					mLaunchImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, launchImageLoaderLoadCompletedHandler);
					mLaunchImageLoader.load(new URLRequest(launchImageURL));
				}
				else
				{
					onLaunchImageLoaded();
				}
			}
			else
			{
				onLaunchImageLoaded();
			}
		}
		
		protected function launchImageLoaderLoadCompletedHandler(event:Event):void
		{
			mLaunchImageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, launchImageLoaderLoadCompletedHandler);

			mLaunchImage = mLaunchImageLoader.content;
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
			mLaunchImageLoaded = true;
			
			if(mLaunchImage)
			{
				addChild(mLaunchImage);
				layout(stage.stageWidth, stage.stageHeight);
			}
			
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
			if(fadeoutDelayTime > 0)
			{
				Starling.juggler.delayCall(onFadeoutEffectStart, fadeoutDelayTime);
			}
			else
			{
				onFadeoutEffectStart();
			}
		}
		
		protected function onFadeoutEffectStart():void
		{
			if(fadeoutTime > 0 && fadeoutProps != null)
			{
				var tween:Tween = Starling.juggler.tween(this, fadeoutTime, fadeoutProps) as Tween;
				tween.onComplete = onFadeoutEffectCompleted;
			}
			else
			{
				onFadeoutEffectCompleted();	
			}
		}
		
		protected function onFadeoutEffectCompleted():void
		{
			onBootStrapComplete();
		}
		
		protected function onBootStrapComplete():void
		{
			stage.removeEventListener(Event.RESIZE, stageResizeHandler);
			
			mBootStrap.dispatchEvent(new Event(AppBootStrap.EVENT_BOOT_STRAP_COMPLETE));
		}
		
		protected function stageResizeHandler(event:Event):void
		{
			layout(stage.stageWidth, stage.stageHeight);
		}
		
		protected function layout(stageWidth:int, stageHeight):void
		{
			if(mLaunchImage)
			{
				mLaunchImage.x = (this.stage.stageWidth - mLaunchImage.width) * 0.5;
				mLaunchImage.y = (this.stage.stageHeight - mLaunchImage.height) * 0.5;
			}
		}

		public function dispose():void
		{
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