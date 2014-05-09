package com.croco2d.assets
{
	public class JSONAsset extends BinaryAsset
	{
		public var json:Object;
		
		public function JSONAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			json = null;
		}
		
		override protected function onBinaryBasedAssetDeserialize():void
		{
			var jsonStr:String = new String(byteArray);
			json = JSON.parse(jsonStr);
			
			byteArray.clear();
			byteArray = null;
		}
	}
}