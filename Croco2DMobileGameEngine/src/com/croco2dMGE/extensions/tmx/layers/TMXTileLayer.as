package com.croco2dMGE.extensions.tmx.layers
{
	import com.croco2dMGE.extensions.tmx.datas.TMXGridData;
	import com.croco2dMGE.extensions.tmx.entities.TMXTileMapEntity;
	
	import starling.utils.AssetManager;

	public class TMXTileLayer extends TMXBasicLayer
	{
		public var gridData:TMXGridData;
		
		public var tileMapEntity:TMXTileMapEntity;
		
		public function TMXTileLayer()
		{
			super();
		}
		
		override public function deserialize(xml:XML):void
		{
			super.deserialize(xml);
			
			//gridData
			gridData = new TMXGridData();
			gridData.mapData = mapData;
			gridData.deserialize(xml.data[0]);
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			tileMapEntity = new TMXTileMapEntity();
			tileMapEntity.cellWidth = gridData.mapData.tileWidth;
			tileMapEntity.cellHeight = gridData.mapData.tileHeight;
			tileMapEntity.maxColCount = gridData.mapData.colNum;
			tileMapEntity.maxRowCount = gridData.mapData.rowNum;
			tileMapEntity.minColStartIndex = 0;
			tileMapEntity.minRowStartIndex = 0;
			tileMapEntity.gridData = gridData;
			addItem(tileMapEntity);
		}

		override public function dispose():void
		{
			super.dispose();
			
			if(gridData)
			{
				gridData.dispose();
				gridData = null;
			}

			tileMapEntity = null;
		}
	}
}