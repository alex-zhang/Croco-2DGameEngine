package com.croco2d.assets
{
	import deng.fzip.FZipFile;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;

	public class BitmapFontAsset extends ZipPackAsset
	{
		//ImageAsset(*.atf, *.png, *.jpg) + font.fnt
		public var bitmapFont:BitmapFont;
		
		private var mImageAsset:ImageAsset;
		
		public function BitmapFontAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
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
			
			if(mImageAsset)
			{
				mImageAsset.dispose();
				mImageAsset = null;
			}
		}
		
		override protected function onZipAssetDeserialize():void
		{
			var fontXMLZipFile:FZipFile = zipPackFile.getFileByName("font.fnt");
			var fontXML:XML = new XML(fontXMLZipFile.content);
			
			var imageZipFile:FZipFile;
			
			var zipFile:FZipFile;
			var n:int = zipPackFile.getFileCount();
			for(var i:int = 0; i < n; i++)
			{
				zipFile = zipPackFile.getFileAt(i);
				if(zipFile !== fontXMLZipFile)
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

				bitmapFont = new BitmapFont(mImageAsset.texture, fontXML);
				
				//for void texture double dispose. and keep the texture bytes for restore.
				mImageAsset.texture = null
				
				onAssetLoadedCompeted();
			});
		}
	}
}