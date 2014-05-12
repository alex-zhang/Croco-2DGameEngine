package com.croco2d.assets
{
	import deng.fzip.FZip;

	public class ZipPackAsset extends BinaryAsset
	{
		public var zipPackFile:FZip;
		
		public function ZipPackAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			zipPackFile = null;
		}
		
		//use onZipAssetDeserialize instead.
		override final protected function onBinAssetDeserialize():void
		{
			zipPackFile = new FZip();
			zipPackFile.loadBytes(byteArray);
			
			byteArray.clear();
			byteArray = null;
			
			onZipAssetDeserialize();
		}
		
		protected function onZipAssetDeserialize():void
		{
			onAssetLoadedCompeted();	
		}
	}
}