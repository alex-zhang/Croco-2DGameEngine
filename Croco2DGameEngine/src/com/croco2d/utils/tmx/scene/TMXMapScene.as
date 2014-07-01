package com.croco2d.utils.tmx.scene
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.components.CrocoScene;
	import com.croco2d.utils.tmx.data.TMXMapData;
	import com.croco2d.utils.tmx.data.TMXPropertySet;
	import com.fireflyLib.utils.PropertyBag;
	
	import flash.geom.Rectangle;

	public class TMXMapScene extends CrocoScene
	{
		public var tmxMapData:TMXMapData;
		
		public function TMXMapScene()
		{
			super();
		}
		
		override public function get propertyBag():PropertyBag
		{
			if(!__propertyBag) __propertyBag = new TMXPropertySet();
			
			return __propertyBag;
		}
		
		public function deserialize(xml:XML):void
		{
			tmxMapData = new TMXMapData();
			tmxMapData.deserialize(xml);
			
			TMXPropertySet(propertyBag).deserialize(xml.properties[0]);
			
			var elementXMLs:XMLList = xml.elements();
			var elementXML:XML;
			var elementName:String;
			
			initSceneLayers = [];
			
			var sceneLayer:TMXBasicLayer;
			
			//here will keep the lay index
			var n:int = elementXMLs.length();
			for(var i:int = 0; i < n; i++)
			{
				sceneLayer = null;
				
				elementXML = elementXMLs[i];
				elementName = elementXML.name().toString();
				
				switch(elementName)
				{
					case "objectgroup":
						sceneLayer = deserializeForObjectgroupLayer(elementXML);
						break;
					
					case "imagelayer":
						sceneLayer = deserializeForImageLayer(elementXML)
						break;
					
					case "layer":
						sceneLayer = deserializeForTileLayer(elementXML);
						break;
				}
				
				if(sceneLayer)
				{
					sceneLayer.tmxMapData = tmxMapData; 
					initSceneLayers.push(sceneLayer);
				}
			}
		}
		
		protected function deserializeForImageLayer(xml:XML):TMXImageLayer
		{
			var imageLayer:TMXImageLayer = new TMXImageLayer();
			imageLayer.deserialize(xml);
			
			return imageLayer;
		}
		
		protected function deserializeForTileLayer(xml:XML):TMXTileLayer
		{
			var tileLayer:TMXTileLayer = new TMXTileLayer();
			tileLayer.deserialize(xml);
			
			return tileLayer;
		}
		
		protected function deserializeForObjectgroupLayer(xml:XML):TMXEntitiesLayer
		{
			var objectgroupLayer:TMXEntitiesLayer = new TMXEntitiesLayer();
			objectgroupLayer.deserialize(xml);
			
			return objectgroupLayer;
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			onInitCamera();
		}
		
		protected function onInitCamera():void
		{
			CrocoEngine.camera.setBounds(new Rectangle(0, 0, tmxMapData.mapWidth, tmxMapData.mapHeight));
		}
	}
}