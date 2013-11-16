package com.croco2dMGE.extensions.tmx.graphics
{
	import com.croco2dMGE.graphics.map.TileMap;
	import com.croco2dMGE.extensions.tmx.datas.TMXGridData;

	public class TMXTileMap extends TileMap
	{
		public var gridData:TMXGridData;
		
		public function TMXTileMap(cellWidth:int, cellHeight:int,
								   maxColCount:int, maxRowCount:int,
								   minColStartIndex:int = 0, minRowStartIndex:int = 0)
		{
			super(cellWidth, cellHeight, maxColCount, maxRowCount, minColStartIndex, minRowStartIndex);
			
			mapCellCls = TMXTileMapCell;
		}
		
		override protected function onActiveValidCell(colIndex:int, rowIndex:int):void
		{
			if(gridData.getCellValue(colIndex, rowIndex) != 0)
			{
				super.onActiveValidCell(colIndex, rowIndex);
			}
		}
		
		override protected function onDeactiveInvalidCell(colIndex:int, rowIndex:int):void
		{
			if(gridData.getCellValue(colIndex, rowIndex) != 0)
			{
				super.onDeactiveInvalidCell(colIndex, rowIndex);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			gridData = null;
		}
	}
}