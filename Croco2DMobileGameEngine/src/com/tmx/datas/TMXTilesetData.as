package com.tmx.datas
{
	public class TMXTilesetData extends TMXBasicData
	{
		public var firstgid:int = 0;
		public var lastgid:int = 0;
		
		public var name:String;
		
		public var tileWidth:int = 0;
		public var tileHeight:int = 0;
		
		public var imageData:TMXImageData;//justDiplay
		public var propertiesData:TMXPropertiesData;
		
		public var colCount:int = 0;
		public var rowCount:int = 0;
		public var tileCount:int = 0;
		
		public var tileUvalue:Number = 1.0;
		public var tileVvalue:Number = 1.0;
		
		override public function deserialize(xml:XML):void
		{
			//base atr
			firstgid = parseInt(xml.@firstgid);
			name = xml.@name;
			tileWidth = parseInt(xml.@tilewidth);
			tileHeight = parseInt(xml.@tileheight);

			//properties
			propertiesData = new TMXPropertiesData();
			propertiesData.deserialize(xml.properties[0]);
			
			//image
			imageData = new TMXImageData();
			imageData.deserialize(xml.image[0]);
			imageData.path = propertiesData.get("path");//Default setting
			
			colCount = int(imageData.width / tileWidth);
			rowCount = int(imageData.height / tileHeight);
			tileCount = colCount * rowCount;
			
			lastgid = firstgid + tileCount - 1;
			
			tileUvalue = 1 / colCount;
			tileVvalue = 1 / rowCount;
		}
		
		override public function dispose():void
		{
			name = null;
			
			if(imageData)
			{
				imageData.dispose();
				imageData = null;
			}
			
			if(propertiesData)
			{
				propertiesData.dispose();
				propertiesData = null;
			}
		}
	}
}