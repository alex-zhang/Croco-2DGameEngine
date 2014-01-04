package com.croco2dMGE.utils.tmx.world
{
	import com.croco2dMGE.CrocoEngine;
	import com.croco2dMGE.utils.CrocoRect;
	import com.croco2dMGE.utils.tmx.data.TMXMapData;
	import com.croco2dMGE.utils.tmx.data.TMXPropertySet;
	import com.croco2dMGE.world.CrocoScene;

	public class TMXMapScene extends CrocoScene
	{
		public var tmxMapData:TMXMapData;
		
		public function TMXMapScene()
		{
			super();
		}
		
		public function deserialize(xml:XML):void
		{
			tmxMapData = new TMXMapData();
			tmxMapData.tmxMapScene = this;
			tmxMapData.deserialize(xml);
			
			propertyBag = new TMXPropertySet();
			TMXPropertySet(propertyBag).deserialize(xml.properties[0]);
			
			var elementXMLs:XMLList = xml.elements();
			var elementXML:XML;
			var elementName:String;
			
			layers = [];
			
			//here will keep the lay index
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
						deserializeForTileLayer(elementXML);
						break;
				}
			}
		}
		
		protected function deserializeForImageLayer(xml:XML):void
		{
			var imageLayer:TMXImageLayer = new TMXImageLayer();
			imageLayer.tmxMapData = tmxMapData;
			imageLayer.deserialize(xml);
			
			layers.push(imageLayer);
		}
		
		protected function deserializeForTileLayer(xml:XML):void
		{
			var tileLayer:TMXTileLayer = new TMXTileLayer();
			tileLayer.tmxMapData = tmxMapData;
			tileLayer.deserialize(xml);
			
			layers.push(tileLayer);
		}
		
		protected function deserializeForObjectgroupLayer(xml:XML):void
		{
			var objectgroupLayer:TMXEntitiesLayer = new TMXEntitiesLayer();
			objectgroupLayer.tmxMapData = tmxMapData;
			objectgroupLayer.deserialize(xml);
			
			layers.push(objectgroupLayer);
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			onInitCamera();
		}
		
		protected function onInitCamera():void
		{
			CrocoEngine.camera.bounds = new CrocoRect(0, 0, tmxMapData.mapWidth, tmxMapData.mapHeight);
		}
	}
}