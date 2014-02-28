package com.croco2d.assets
{
	import flash.system.System;

	public class XMLAsset extends BinaryAsset 
	{
		public var xml:XML;
		
		public function XMLAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(xml)
			{
				System.disposeXML(xml);
				xml = null;
			}
		}
		
		override protected function onBinaryBasedAssetDeserialize():void
		{
			xml = new XML(byteArray);
			
			byteArray.clear();
			byteArray = null;
		}
	}
}