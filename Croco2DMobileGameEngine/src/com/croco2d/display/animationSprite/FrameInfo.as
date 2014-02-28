package com.croco2d.display.animationSprite
{
	import starling.textures.Texture;

	public class FrameInfo
	{
		public var frame:int;
		public var eventName:String;
		public var eventParams:Object;
		public var texture:Texture;

		public function dispose():void
		{
			texture = null;
			eventName = null;
			eventParams = null;
		}
	}
}