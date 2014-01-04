package com.croco2dMGE.utils.assets
{
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class SpriteSheetAsset extends CoralDirPackAsset
	{
		//spritesheet.atf,spritesheet.xml
		public var textureAtlas:TextureAtlas;
		
		public function SpriteSheetAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override protected function onBinaryBasedAssetDeserialize():void
		{
			super.onBinaryBasedAssetDeserialize();
			
			var spritesheetAtfBytes:ByteArray = coralPackDirFile.getFile("spritesheet.atf").contentBytes;
			var spritesheetXMLBytes:ByteArray = coralPackDirFile.getFile("spritesheet.xml").contentBytes
			
			var spritesheetXML:XML = new XML(spritesheetXMLBytes);
			textureAtlas = new TextureAtlas(
				Texture.fromAtfData(spritesheetAtfBytes, assetsManager.scaleFactor, assetsManager.useMipMaps), 
				new XML(spritesheetXMLBytes));
			System.disposeXML(spritesheetXML);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(textureAtlas)
			{
				textureAtlas.dispose();
				textureAtlas = null;
			}
		}
	}
}