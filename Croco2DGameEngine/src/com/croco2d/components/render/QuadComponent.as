package com.croco2d.components.render
{
	import starling.display.DisplayObject;
	import starling.display.Quad;

	public class QuadComponent extends DisplayObjectComponent
	{
		public var __quad:Quad;
		public var __color:uint = 0xFFFFFF;//default;
		
		public function QuadComponent()
		{
			super();
		}
		
		public function get color():uint
		{
			return __color;
		}
		
		public function set color(value:uint):void
		{
			if(__color != value)
			{
				__color = value;
				
				if(__quad)
				{
					__quad.color = __color;
				}
			}
		}
		
		//dead end.
		override public function set dispalyObject(value:DisplayObject):void
		{
			throw new Error("u can't set the value.");
		}
		
		override protected function onInit():void
		{
			__quad = new Quad(100, 100, __color);
			
			super.dispalyObject = __quad;
		}
	}
}