package com.croco2d.utils.tmx.scene.ornaments
{
	

	public class OrtSurroundingSoundEntity// extends SceneObject
	{
//		private var mSoundResource:Sound;
//		private var mSoundHandle:ISoundHandle;
//		private var mSoundRange:Number = 0.0;
//		
//		private var mIsSoundPlaying:Boolean = false;
//		
//		public function OrtSurroundingSoundEntity()
//		{
//			super();
//			
//			visible = false;
//		}
//		
//		override protected function onInit():void
//		{
//			//==================================================================
//			//参数：
//			//1. assetPath : 场景相对路径
//			//	格式：path/a.mp3
//			//
//			//说明：声音半径即为声音宽度的一半，建议tmx中使用圆形
//			//==================================================================
//			
//			var assetPath:String = propertyBag.read("assetPath");
//			
//			//bg sound may be has a big range.
//			var halfWidth:Number = visibleTestRect.width >> 1;
//			mSoundRange = halfWidth;//default
//
//			//--
//			
//			var assetsManager:CrocoAssetsManager = scene.screen.screenPreLoadAssetsManager;
//			
//			var soundAsset:SoundAsset = assetsManager.getSoundAsset(
//				AppConfig.findTargetScenePathResource(scene.name, assetPath));
//
//			mSoundResource = soundAsset.sound;
//			
//			super.onInit();
//		}
//		
//		override public function tick(deltaTime:Number):void
//		{
//			super.tick(deltaTime);
//			
//			var camera:SceneCamera = CrocoEngine.camera;
//			
//			var cameraScreenCenterX:Number = camera.viewPortWidth >> 1;
//			var cameraScreenCenterY:Number = camera.viewPortHeight >> 1;
//			
//			var soundCenterX:Number = screenX + mSoundRange;
//			var soundCenterY:Number = screenY + mSoundRange;
//			
//			var distance:Number = MathUtil.distance(cameraScreenCenterX, cameraScreenCenterY, soundCenterX, soundCenterY);
//			var isInSoundRange:Boolean = distance <= mSoundRange;
//			
//			if(isInSoundRange)
//			{
//				playSound();
//
//				if(mSoundHandle)
//				{
//					mSoundHandle.volume = 1 - distance / mSoundRange;
//					mSoundHandle.pan = (soundCenterX - cameraScreenCenterX) / mSoundRange;
//				}
//			}
//			else
//			{
//				stopSound();
//			}
//		}
//		
//		override public function dispose():void
//		{
//			super.dispose();
//			
//			stopSound();
//		}
//		
//		private function playSound():void
//		{
//			if(mIsSoundPlaying) return;
//			
//			mIsSoundPlaying = true;
//			
//			if(!mSoundHandle)
//			{
//				mSoundHandle = CrocoEngine.soundManager.play(mSoundResource, SoundManager.MUSIC_MIXER_CATEGORY, 0, int.MAX_VALUE);
//
//				mSoundHandle.volume = 0;//default
//				
//				if(!mSoundHandle)//may be reach the max sound limit
//				{
//					mIsSoundPlaying = false;
//				}
//			}
//			else if(!mSoundHandle.isPlaying)
//			{
//				mSoundHandle.resume();
//			}
//		}
//		
//		private function stopSound():void
//		{
//			if(!mIsSoundPlaying) return;
//			
//			mIsSoundPlaying = false;
//			
//			if(mSoundHandle)
//			{
//				mSoundHandle.stop();
//				mSoundHandle = null;
//			}
//		}
	}
}