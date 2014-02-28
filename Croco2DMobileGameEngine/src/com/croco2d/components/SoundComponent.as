package com.croco2d.components
{
	import com.croco2d.core.CrocoObject;
	import com.croco2d.sound.ISoundHandle;

	public class SoundComponent extends CrocoObject
	{
		public var __soundHandle:ISoundHandle;
		
		public function SoundComponent()
		{
			super();
		}
		
		public function get soundHandle():ISoundHandle
		{
			return __soundHandle;
		}
		
		public function set soundHandle(value:ISoundHandle):void
		{
			__soundHandle = value;
		}
	}
}