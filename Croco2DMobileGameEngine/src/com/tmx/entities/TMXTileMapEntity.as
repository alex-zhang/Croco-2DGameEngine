package com.tmx.entities
{
	import com.croco2dMGE.world.entities.TileMapEntity;
	import com.tmx.datas.TMXGridData;
	import com.tmx.graphics.TMXTileMap;

	public class TMXTileMapEntity extends TileMapEntity
	{
		public var gridData:TMXGridData;
		
		public function TMXTileMapEntity()
		{
			super();

			tileMapCls = TMXTileMap;
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			TMXTileMap(mTileMap).gridData = gridData;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			gridData = null;
		}
	}
}