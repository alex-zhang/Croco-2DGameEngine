package com.croco2d.components
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.core.CrocoObject;
	import com.croco2d.sound.ISoundHandle;
	
	import flash.media.Sound;

	public class SoundComponent extends CrocoObject
	{
		public var __soundHandle:ISoundHandle;
		
		public function SoundComponent()
		{
			super();
		}
		
		public function playSound(sound:Sound, category:String):void
		{
			stopSound();
			
			if(sound)
			{
				__soundHandle = CrocoEngine.soundManager.play(sound, category);
			}
		}
		
		public function stopSound():void
		{
			if(__soundHandle)
			{
				__soundHandle.stop();
				__soundHandle = null;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			stopSound();
		}
	}
}