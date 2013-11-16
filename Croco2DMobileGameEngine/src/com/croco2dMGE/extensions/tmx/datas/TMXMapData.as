package com.croco2dMGE.extensions.tmx.datas
{
	public class TMXMapData extends TMXBasicData
	{
		public var colNum:int = 0;
		public var rowNum:int = 0;
		
		public var cellsNum:int = 0;
		
		public var tileWidth:int = 0;
		public var tileHeight:int = 0;
		
		public var orientation:String;//must be orthogonal
		
		public var propertiesData:TMXPropertiesData;
		
		public var tilesetListData:TMXTilesetListData;
		
		public function TMXMapData()
		{
			super();
		}
		
		override public function deserialize(xml:XML):void
		{
			//base atr
			colNum = parseInt(xml.@width);
			rowNum = parseInt(xml.@height);
			cellsNum = colNum * rowNum;
			
			tileWidth = parseInt(xml.@tilewidth);
			tileHeight = parseInt(xml.@tileheight);
			orientation = xml.@orientation;
			
			//properties
			propertiesData = new TMXPropertiesData();
			propertiesData.deserialize(xml.properties[0]);
			
			//tileset
			tilesetListData = new TMXTilesetListData();
			tilesetListData.deserialize(xml);
		}
		
		override public function dispose():void
		{
			orientation = null;
			
			if(propertiesData)
			{
				propertiesData.dispose();
				propertiesData = null;
			}
			
			if(tilesetListData)
			{
				tilesetListData.dispose();
				tilesetListData = null;
			}
		}
	}
}