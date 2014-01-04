package com.croco2dMGE.utils.assets
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	
	import starling.events.Event;
	import starling.textures.Texture;

	public class ImageAsset extends BinaryAsset
	{
		public var texture:Texture;
		
		public function ImageAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override protected function onBinaryBasedAssetDeserialize():void
		{
			if(extention == "atf")
			{
				texture = Texture.fromAtfData(byteArray, assetsManager.scaleFactor, assetsManager.useMipMaps);
				
				byteArray.clear();
				byteArray = null;
			}
			else//jpge, jpg, png
			{
				var imageLoaderContext:LoaderContext = new LoaderContext();
				imageLoaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
				
				var imageLoader:Loader = new Loader();
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaderLoadCompleteHandler);
				imageLoader.loadBytes(byteArray, imageLoaderContext);
				var self:* = this;
				function imageLoaderLoadCompleteHandler():void
				{
					imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaderLoadCompleteHandler);
					texture = Texture.fromBitmap(imageLoader.content as Bitmap, assetsManager.useMipMaps, false, assetsManager.scaleFactor);
					
					$onAssetDeserializeComplete();
					
					byteArray.clear();
					byteArray = null;
				}
			}
		}
		
		override protected function onAssetDeserializeComplete():void
		{
			if(extention == "atf")
			{
				$onAssetDeserializeComplete();
			}
		}
		
		private function $onAssetDeserializeComplete():void
		{
			super.onAssetDeserializeComplete();
		}
	}
}