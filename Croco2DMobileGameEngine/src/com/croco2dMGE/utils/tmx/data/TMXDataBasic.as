package com.croco2dMGE.utils.tmx.data
{
	public class TMXDataBasic
	{
		public var xmlTagName:String;
		public var mapData:TMXMapData;
		
		public function deserialize(xml:XML):void 
		{
			xmlTagName = xml.name();
		}
		
		public function dispose():void 
		{
			xmlTagName = null;
			mapData = null;
		}
	}
}