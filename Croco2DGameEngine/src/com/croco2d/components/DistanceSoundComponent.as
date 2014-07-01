package com.croco2d.components
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.scene.CrocoGameObject;
	import com.fireflyLib.utils.MathUtil;
	
	import flash.media.Sound;
	import com.croco2d.core.CrocoGameObject;

	public class DistanceSoundComponent extends SoundComponent
	{
		public var sound:Sound;
		public var soundRange:Number = 100;
		public var soundCategory:String;
		
		public function DistanceSoundComponent()
		{
			super();
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);

			if(sound && soundRange > 0)
			{
				var camera:CrocoCamera = CrocoEngine.camera;
				
				var soundCenterX:Number = CrocoGameObject(owner).x;
				var soundCenterY:Number = CrocoGameObject(owner).x;
				
				var distance:Number = MathUtil.distance(soundCenterX, soundCenterY, camera.pivotX, camera.pivotY);
				var isInSoundRange:Boolean = distance <= soundRange;
				
				if(isInSoundRange)
				{
					playSound(sound, soundCategory);
					
					if(mSoundHandle)
					{
						mSoundHandle.volume = 1 - distance / soundRange;
						mSoundHandle.pan = (soundCenterX - camera.pivotX) / soundRange;
					}
				}
				else
				{
					stopSound();
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			sound = null;
			soundRange = NaN;
			soundCategory = null;
		}
	}
}