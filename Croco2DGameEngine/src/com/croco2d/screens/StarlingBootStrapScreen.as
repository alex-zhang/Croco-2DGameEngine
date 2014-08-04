package com.croco2d.screens
{
	import com.croco2d.AppBootStrap;
	import com.croco2d.AppConfig;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class StarlingBootStrapScreen extends Sprite implements IBootStrapScreen
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
		
		public function StarlingBootStrapScreen()
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
			
			this.stage.addEventListener(starling.events.Event.RESIZE, stageResizeHandler);
		}
		
		protected function onLaunchImageLoadStart():void
		{
			if(launchImage is Class) launchImage = new launchImage();
			
			var launchImageTexture:Texture;
			
			if(launchImage is DisplayObject)
			{
				mLaunchImage = launchImage as DisplayObject;
				onLaunchImageLoaded();
			}
			else if(launchImage is Texture)
			{
				launchImageTexture = Texture(launchImage); 
				mLaunchImage = new Image(launchImageTexture);
				onLaunchImageLoaded();
			}
			else if(launchImage is Bitmap)
			{
				launchImageTexture = Texture.fromBitmap(Bitmap(launchImage), false);
				mLaunchImage = new Image(launchImageTexture);
				onLaunchImageLoaded();
			}
			else if(launchImage is String)
			{
				var launchImageURL:String = AppConfig.findAppResourcePath(launchImage);
				var launchImageFile:File = File.applicationDirectory.resolvePath(launchImageURL);
				
				if(launchImageFile.exists)
				{
					mLaunchImageLoader = new Loader();
					mLaunchImageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, launchImageLoaderLoadCompletedHandler);
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
		
		private function launchImageLoaderLoadCompletedHandler(event:flash.events.Event):void
		{
			mLaunchImageLoader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, launchImageLoaderLoadCompletedHandler);
			
			var launchImageTexture:Texture = Texture.fromBitmap(Bitmap(mLaunchImageLoader.content));
			
			mLaunchImage = new Image(launchImageTexture);
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
			dispatchBootStrapCompleteEvent();
		}
		
		protected function dispatchBootStrapCompleteEvent():void
		{
			this.stage.removeEventListener(starling.events.Event.RESIZE, stageResizeHandler);
			
			mBootStrap.dispatchEvent(new flash.events.Event(AppBootStrap.EVENT_BOOT_STRAP_COMPLETE));
		}
		
		protected function stageResizeHandler(event:starling.events.Event):void
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
		
		override public function dispose():void
		{
			if(mLaunchImageLoader)
			{
				mLaunchImageLoader.unloadAndStop(false);
				
				mLaunchImageLoader = null;
			}
			
			if(mLaunchImage)
			{
				if(mLaunchImage is Image && Image(mLaunchImage).texture)
				{
					Image(mLaunchImage).texture.dispose();
				}
				removeChild(mLaunchImage);
				mLaunchImage.dispose();
				mLaunchImage = null;
			}
			
			super.dispose();
		}
	}
}