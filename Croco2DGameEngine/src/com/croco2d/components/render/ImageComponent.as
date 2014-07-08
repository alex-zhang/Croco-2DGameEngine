package com.croco2d.components.render
{
	import com.croco2d.display.CrocoImage;
	
	import starling.display.DisplayObject;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	public class ImageComponent extends DisplayObjectComponent
	{
		public var __crocoImage:CrocoImage;
		public var __texture:Texture;
		public var __smoothing:String = TextureSmoothing.NONE;
		public var __color:uint = 0xFFFFFF;//default;
		
		public function ImageComponent()
		{
			super();
		}
		
		public function get texture():Texture { return __texture; }
		public function set texture(value:Texture):void
		{
			if(__texture != value)
			{
				__texture = value;
				
				if(__crocoImage)
				{
					__crocoImage.texture = __texture;
				}
			}
		}
		
		public function get smoothing():String { return __smoothing; }
		public function set smoothing(value:String):void 
		{
			if(__smoothing != value)
			{
				__smoothing = value;
				
				if(__crocoImage)
				{
					__crocoImage.smoothing = __smoothing;
				}
			}
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
				
				if(__crocoImage)
				{
					__crocoImage.color = __color;
				}
			}
		}
		
		override protected function onInit():void
		{
			__crocoImage = new CrocoImage();
			__crocoImage.texture = __texture;
			__crocoImage.smoothing = __smoothing;
			if(__color != 0xffffff)
			{
				__crocoImage.color = __color;
			}
			
			super.dispalyObject = __crocoImage;
		}
		
		override public function set dispalyObject(value:DisplayObject):void
		{
			throw new Error("u can't set the value.");
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			__crocoImage = null;
		}
	}
}