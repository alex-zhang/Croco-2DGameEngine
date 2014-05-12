package com.croco2d.assets
{
	import deng.fzip.FZipFile;
	
	import starling.textures.TextureAtlas;

	public class SpriteSheetAsset extends ZipPackAsset
	{
		//ImageAsset(*.atf, *.png, *.jpg) + spritesheet.xml
		public var textureAtlas:TextureAtlas;
		
		private var mImageAsset:ImageAsset;
		
		public function SpriteSheetAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override public function dispose():void
		{
			super.dispose();

			if(textureAtlas)
			{
				textureAtlas.dispose();
				textureAtlas = null;
			}
			
			if(mImageAsset)
			{
				mImageAsset.dispose();
				mImageAsset = null;
			}
		}
		
		override protected function onZipAssetDeserialize():void
		{
			var spritesheetXMLZipFile:FZipFile = zipPackFile.getFileByName("spritesheet.xml");
			var spritesheetXML:XML = new XML(spritesheetXMLZipFile.content);
			
			var imageZipFile:FZipFile;
			
			var zipFile:FZipFile;
			var n:int = zipPackFile.getFileCount();
			for(var i:int = 0; i < n; i++)
			{
				zipFile = zipPackFile.getFileAt(i);
				if(zipFile !== spritesheetXMLZipFile)
				{
					imageZipFile = zipFile;
					break;
				}
			}
			
			var imageZipFileFullName:String = imageZipFile.filename;
			var imageZipFileExtension:String = null;
			var indexOfDot:int = imageZipFileFullName.lastIndexOf(".");
			if(indexOfDot != -1)
			{
				imageZipFileExtension = imageZipFileFullName.substr(indexOfDot + 1);
			}
			
			//keey the image asset fot texture restore.
			mImageAsset = new ImageAsset(imageZipFileFullName, 
				CrocoAssetsManager.IMAGE_TYPE, 
				imageZipFileExtension, null);
			
			mImageAsset.loadBytes(imageZipFile.content, function():void {

				textureAtlas = new TextureAtlas(mImageAsset.texture, spritesheetXML);
				
				//for void texture double dispose. and keep the texture bytes for restore.
				mImageAsset.texture = null
				
				onAssetLoadedCompeted();
			});
		}
	}
}