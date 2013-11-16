package com.croco2dMGE.graphics.sprite
{
	import starling.textures.Texture;

	public class FrameInfo
	{
		public var frame:int;
		public var eventName:String;
		public var texture:Texture;
		
		public function FrameInfo()
		{
		}
		
		public function dispose():void
		{
			texture = null;
			eventName = null;
		}
	}
}