package com.tmx
{
	import com.croco2dMGE.world.CrocoScene;
	import com.tmx.datas.TMXMapData;
	import com.tmx.layers.TMXBasicLayer;
	import com.tmx.layers.TMXEntitiesLayer;
	import com.tmx.layers.TMXImageLayer;
	import com.tmx.layers.TMXRectCollisionLayer;
	import com.tmx.layers.TMXTileLayer;

	public class TMXMap extends CrocoScene
	{
		public var mapData:TMXMapData;

		public function TMXMap()
		{
			super();
		}
		
		public function deserialize(xml:XML):void
		{
			mapData = new TMXMapData();
			mapData.deserialize(xml);
			
			var elementXMLs:XMLList = xml.elements();
			var elementXML:XML;
			var elementName:String;
			
			layers = [];
			
			var n:int = elementXMLs.length();
			for(var i:int = 0; i < n; i++)
			{
				elementXML = elementXMLs[i];
				elementName = elementXML.name().toString();
				
				switch(elementName)
				{
					case "objectgroup":
						deserializeForObjectgroupLayer(elementXML);
						break;
					
					case "imagelayer":
						deserializeForImageLayer(elementXML);
						break;
					
					case "layer":
						deserializeForLayer(elementXML);
						break;
				}
			}
		}
		
		protected function deserializeForImageLayer(xml:XML):void
		{
			var imageLayer:TMXImageLayer = new TMXImageLayer();
			imageLayer.mapData = mapData;
			imageLayer.deserialize(xml);
			layers.push(imageLayer);
		}
		
		protected function deserializeForLayer(xml:XML):void
		{
			var tileLayer:TMXTileLayer = new TMXTileLayer();
			tileLayer.mapData = mapData;
			tileLayer.deserialize(xml);
			layers.push(tileLayer);
		}
		
		protected function deserializeForObjectgroupLayer(xml:XML):void
		{
			var layerName:String = xml.@name.toString();
			
			var objectgroupLayer:TMXBasicLayer;
			if(layerName.indexOf("collisionLayer") == 0)//Default must be
			{
				objectgroupLayer = new TMXRectCollisionLayer();
			}
			else
			{
				objectgroupLayer = new TMXEntitiesLayer();
			}
			
			objectgroupLayer.mapData = mapData;
			objectgroupLayer.deserialize(xml);
			layers.push(objectgroupLayer);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mapData)
			{
				mapData.dispose();
				mapData = null;
			}
		}
	}
}