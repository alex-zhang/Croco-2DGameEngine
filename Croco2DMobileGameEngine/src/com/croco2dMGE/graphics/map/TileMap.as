package com.croco2dMGE.graphics.map
{
	import starling.display.DisplayObject;

	public class TileMap extends MapBasic
	{
		//uncompact and uncontinuous cell index mapping. it's use the colIndex:rowIndex as the index key.
		protected var mActivedMapCells:Array;//cellIndex:rowIndex->Cell
		protected var mCachedMapCells:Vector.<IMapCellRender>;

		public function TileMap(cellWidth:int, cellHeight:int,
									 maxColCount:int, maxRowCount:int,
									 minColStartIndex:int = 0, minRowStartIndex:int = 0)
		{
			super(cellWidth, cellHeight, maxColCount, maxRowCount, minColStartIndex, minRowStartIndex);
			
			mActivedMapCells = [];
			mCachedMapCells = new Vector.<IMapCellRender>();
			
			mapCellCls ||= TileMapCell;//default
		}
		
		override protected function onActiveValidCell(colIndex:int, rowIndex:int):void
		{
			var cell:IMapCellRender = mCachedMapCells.length > 0 ? 
				mCachedMapCells.pop() : 
				createCell(cellWidth, cellHeight);

			establishActivedCellsMapping(cell, colIndex, rowIndex);
			
			onValidCellActived(cell, colIndex, rowIndex);
			
//			trace("addValidCell:", colIndex, rowIndex);
//			trace(this.numChildren);
		}
		
		protected function onValidCellActived(cell:IMapCellRender, colIndex:int, rowIndex:int):void
		{
			cell.colIndex = colIndex;
			cell.rowIndex = rowIndex;
			cell.onActive();
			addChild(DisplayObject(cell));
		}
		
		override protected function onDeactiveInvalidCell(colIndex:int, rowIndex:int):void
		{
			var cell:IMapCellRender = getCellFromActivedMapCellsMapping(colIndex, rowIndex);
			unEstablishActivedCellsMapping(colIndex, rowIndex);
			mCachedMapCells.push(cell);
			
			onInvalidCellDeactived(cell, colIndex, rowIndex);
			
//			trace("removeInvalidCell:", colIndex, rowIndex);
//			trace(this.numChildren);
		}
		
		protected function onInvalidCellDeactived(cell:IMapCellRender, colIndex:int, rowIndex:int):void
		{
			cell.onDeActive();
			removeChild(DisplayObject(cell));
		}
		
		protected function createCell(cellWidth:int, cellHeight:int):IMapCellRender
		{
			var cell:IMapCellRender = new mapCellCls(cellWidth, cellHeight);
			cell.owner = this;
			return cell;
		}
		
		protected function getCellFromActivedMapCellsMapping(colIndex:int, rowIndex:int):IMapCellRender
		{
			return mActivedMapCells[colIndex + ":" + rowIndex];
		}
		
		protected function establishActivedCellsMapping(cell:IMapCellRender, colIndex:int, rowIndex:int):void
		{
			mActivedMapCells[colIndex + ":" + rowIndex] = cell;
		}
		
		protected function unEstablishActivedCellsMapping(colIndex:int, rowIndex:int):void
		{
			delete mActivedMapCells[colIndex + ":" + rowIndex];
		}
	}
}