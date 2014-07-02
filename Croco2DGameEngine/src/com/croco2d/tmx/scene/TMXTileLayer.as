package com.croco2d.tmx.scene
{
	import com.croco2d.tmx.data.TMXTileGridData;

	public class TMXTileLayer// extends TMXBasicLayer
	{
		public var tmxGridData:TMXTileGridData;
//		public var tileMapEntity:CrocoGameObject;
		
		public function TMXTileLayer()
		{
			super();
		}
		
//		override public function deserialize(xml:XML):void
//		{
//			super.deserialize(xml);
//			
//			//gridData
//			tmxGridData = new TMXTileGridData();
//			tmxGridData.mapData = tmxMapData;
//			tmxGridData.deserialize(xml.data[0]);
//		}
//		
////		override protected function onInit():void
////		{
////			//tileMap
////			var tmxTileMap:TMXTileMap = new TMXTileMap(tmxGridData);
////			
////			//display component.
////			var displayComponent:DisplayComponent = new DisplayComponent();
////			displayComponent.displayObject = tmxTileMap;
////			
////			//entity
////			tileMapEntity = new CrocoGameObject();
////			tileMapEntity.initComponents = [displayComponent];
////			
////			initSceneEnetities = [tileMapEntity];
////			
////			super.onInit();
////		}
//
//		override public function dispose():void
//		{
//			super.dispose();
//			
//			if(tmxGridData)
//			{
//				tmxGridData.dispose();
//				tmxGridData = null;
//			}
//			
//			tileMapEntity = null;
//		}
	}
}