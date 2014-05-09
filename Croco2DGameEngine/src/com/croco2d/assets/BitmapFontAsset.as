package com.croco2d.assets
{
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class BitmapFontAsset extends CoralDirPackAsset
	{
		public var bitmapFont:BitmapFont;
		
		public function BitmapFontAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override protected function onBinaryBasedAssetDeserialize():void
		{
			super.onBinaryBasedAssetDeserialize();
			
			var fontXMlBytes:ByteArray = coralPackDirFile.getFile("font.fnt").contentBytes;
			var fontAtfBytes:ByteArray = coralPackDirFile.getFile("font.atf").contentBytes;
			
			var fontXML:XML = new XML(fontXMlBytes);
			var fontTexture:Texture = Texture.fromAtfData(fontAtfBytes, 
				assetsManager.scaleFactor, 
				assetsManager.useMipMaps);
			
			bitmapFont = new BitmapFont(fontTexture, fontXML);
			
			TextField.registerBitmapFont(bitmapFont, bitmapFont.name);
			
			System.disposeXML(fontXML);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(bitmapFont)
			{
				TextField.unregisterBitmapFont(bitmapFont.name, true);
				bitmapFont.dispose();
				bitmapFont = null;
			}
		}
	}
}