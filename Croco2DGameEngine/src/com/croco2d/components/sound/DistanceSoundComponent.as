package com.croco2d.components.sound
{
	import com.croco2d.CrocoEngine;
	import com.fireflyLib.utils.MathUtil;
	
	import flash.media.Sound;

	public class DistanceSoundComponent extends SoundComponent
	{
		public var soundRange:Number = 100;
		
		public var sound:Sound;
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
				var camera:* = CrocoEngine.camera;
				
				var soundCenterX:Number// = ;CrocoGameObject(owner).x;
				var soundCenterY:Number// = CrocoGameObject(owner).x;
				
				var distance:Number = MathUtil.distance(soundCenterX, soundCenterY, camera.pivotX, camera.pivotY);
				var isInSoundRange:Boolean = distance <= soundRange;
				
				if(isInSoundRange)
				{
					playSound(sound, soundCategory);
					
					if(__soundHandle)
					{
						__soundHandle.volume = 1 - distance / soundRange;
						__soundHandle.pan = (soundCenterX - camera.pivotX) / soundRange;
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