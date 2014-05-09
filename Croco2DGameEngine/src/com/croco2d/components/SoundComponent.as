package com.croco2d.components
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.core.CrocoObject;
	import com.croco2d.sound.ISoundHandle;
	
	import flash.media.Sound;

	public class SoundComponent extends CrocoObject
	{
		protected var mSoundHandle:ISoundHandle;
		
		public function SoundComponent()
		{
			super();
		}
		
		public function playSound(sound:Sound, category:String):void
		{
			stopSound();
			
			if(sound)
			{
				mSoundHandle = CrocoEngine.soundManager.play(sound, category);
			}
		}
		
		public function stopSound():void
		{
			if(mSoundHandle)
			{
				mSoundHandle.stop();
				mSoundHandle = null;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			stopSound();
		}
	}
}