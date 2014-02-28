package com.croco2d.display.map
{
	import com.croco2d.display.CrocoImage;
	
	import flash.geom.Point;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.QuadBatch;

	public class TileMap extends MapBasic
	{
		//uncompact and uncontinuous cell index mapping. it's use the colIndex:rowIndex as the index key.
		protected var mActivedMapCells:Array;//cellIndex:rowIndex->Cell
		protected var mCachedMapCells:Vector.<IMapCellRender>;
		
		protected var mBatchQuad:QuadBatch;

		public function TileMap(cellWidth:int, cellHeight:int,
									 maxColCount:int, maxRowCount:int,
									 minColStartIndex:int = 0, minRowStartIndex:int = 0)
		{
			super(cellWidth, cellHeight, maxColCount, maxRowCount, minColStartIndex, minRowStartIndex);
			
			mActivedMapCells = [];
			mCachedMapCells = new Vector.<IMapCellRender>();
			
			mapCellCls ||= TileMapCell;//default
			
			mBatchQuad = new QuadBatch();
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			return null;
		}
//		
//		override public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
//		{
//			return null;
//		}
		
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			mBatchQuad.reset();
			
			var cellImage:CrocoImage;
			for(var colIndex:int = validColStartIndex; colIndex < validColCount; colIndex++)
			{
				for(var rowIndex:int = validColStartIndex; rowIndex < validRowCount; rowIndex++)
				{
					cellImage = getCellFromActivedMapCellsMapping(colIndex, rowIndex) as CrocoImage;
					if(cellImage && cellImage.hasVisibleArea)
					{
						mBatchQuad.addQuad(cellImage, parentAlpha, cellImage.texture, cellImage.smoothing);
					}
				}
			}
			
			mBatchQuad.render(support, parentAlpha);
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
			cell.active();
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
			cell.deactive();
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