package com.croco2d.assets
{
	public class TextAsset extends BinaryAsset
	{
		public var text:String;
		
		public function TextAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			text = null;
		}
		
		override protected function onBinAssetDeserialize():void
		{
			text = new String(byteArray);
			byteArray.clear();
			byteArray = null;
		}
	}
}