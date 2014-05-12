package com.croco2d.assets
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	
	import starling.events.Event;
	import starling.textures.Texture;

	public class ImageAsset extends BinaryAsset
	{
		public var texture:Texture;
		
		public function ImageAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(texture)
			{
				texture.dispose();
				texture = null;
			}
		}
		
		override protected function onBinAssetDeserialize():void
		{
			if(extention == "atf")
			{
				texture = Texture.fromAtfData(byteArray, assetsManager.scaleFactor, assetsManager.useMipMaps);

				//don't clear the bytes for restore when lost context3d
				//byteArray.clear();
				//byteArray = null;

				onAssetLoadedCompeted();
			}
			else//jpge, jpg, png
			{
				var bitmapLoader:Loader = new Loader();
				bitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 
					function():void {
						bitmapLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
						texture = Texture.fromBitmap(bitmapLoader.content as Bitmap, assetsManager.useMipMaps, false, assetsManager.scaleFactor);
						
						//don't clear the bytes for restore when lost context3d
						//byteArray.clear();
						//byteArray = null;
						
						onAssetLoadedCompeted();
				});
				
				bitmapLoader.loadBytes(byteArray);
			}
		}
	}
}