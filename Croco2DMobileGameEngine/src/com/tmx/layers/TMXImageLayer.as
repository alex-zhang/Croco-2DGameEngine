package com.tmx.layers
{
	import com.tmx.datas.TMXImageData;
	import com.tmx.entities.TMXImageLayerEntity;

	public class TMXImageLayer extends TMXBasicLayer
	{
		public var imageData:TMXImageData;
		
		public var imageLayerBackgroundEntity:TMXImageLayerEntity;
		
		public function TMXImageLayer()
		{
			super();
		}
		
		override public function deserialize(xml:XML):void
		{
			super.deserialize(xml);
			
			//image
			imageData = new TMXImageData();
			imageData.deserialize(xml.image[0]);
			imageData.path = propertiesData.get("path");//default
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			//entity
			imageLayerBackgroundEntity = new TMXImageLayerEntity();
			imageLayerBackgroundEntity.imageData = imageData;
			addItem(imageLayerBackgroundEntity);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(imageData)
			{
				imageData.dispose();
				imageData = null;
			}
			
			imageLayerBackgroundEntity = null;
		}
	}
}