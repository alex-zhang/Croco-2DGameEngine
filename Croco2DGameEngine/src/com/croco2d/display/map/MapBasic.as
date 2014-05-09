package com.croco2d.display.map
{
	import com.croco2d.utils.ViewportGridUtil;
	
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;

	public class MapBasic extends DisplayObject
	{
		public var mapCellCls:Class;//must an instance of MapCellBasic
		
		protected var mViewportCellGridUtil:ViewportGridUtil;
		
		public function MapBasic(cellWidth:int, cellHeight:int,
								 maxColCount:int, maxRowCount:int,
								 minColStartIndex:int = 0, minRowStartIndex:int = 0)
		{
			mViewportCellGridUtil = new ViewportGridUtil(cellWidth, cellHeight, 
				maxColCount, maxRowCount, 
				minColStartIndex, minRowStartIndex);
			
			mViewportCellGridUtil.activeValidCellFunction = onActiveValidCell;
			mViewportCellGridUtil.deactiveInvalidCellFunction = onDeactiveInvalidCell;
		}
		
		public function get cellWidth():int { return mViewportCellGridUtil.cellWidth };
		public function get cellHeight():int { return mViewportCellGridUtil.cellHeight };
		
		public function get minColStartIndex():int { return mViewportCellGridUtil.minColStartIndex };
		public function get minRowStartIndex():int { return mViewportCellGridUtil.minRowStartIndex };
		
		public function get maxColCount():int { return mViewportCellGridUtil.maxColCount };
		public function get maxRowCount():int { return mViewportCellGridUtil.maxRowCount };
		
		public function get validColStartIndex():int { return mViewportCellGridUtil.validColStartIndex };
		public function get validColCount():int { return mViewportCellGridUtil.validColCount };
		public function get validRowStartIndex():int { return mViewportCellGridUtil.validRowStartIndex };
		public function get validRowCount():int { return mViewportCellGridUtil.validRowCount };
		
		public function get viewPort():Rectangle { return mViewportCellGridUtil.viewPort; };
		public function setViewPort(viewPortX:Number, viewPortY:Number, 
									viewPortWidth:Number, viewPortHeight:Number):void
		{
			mViewportCellGridUtil.setViewPort(viewPortX, viewPortY, viewPortWidth, viewPortHeight);
		}
		
		public function tick(deltaTime:Number):void
		{
			mViewportCellGridUtil.updateRangeChange();
		}
		
		protected function onActiveValidCell(colIndex:int, rowIndex:int):void
		{
		}
		
		protected function onDeactiveInvalidCell(colIndex:int, rowIndex:int):void
		{
		}
	}
}