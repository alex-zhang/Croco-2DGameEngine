package com.croco2d.utils
{
	import com.fireflyLib.utils.MathUtil;
	
	import flash.geom.Rectangle;

	public class ViewportGridUtil
	{
		public var validColStartIndex:int = 0;
		public var validColCount:int = 0;
		public var validRowStartIndex:int = 0;
		public var validRowCount:int = 0;
		
		public var adjustValidCellRangeFunction:Function;
		public var deactiveInvalidCellFunction:Function;
		public var activeValidCellFunction:Function;
		
		private var mCellWidth:int = 0;
		private var mCellHeight:int = 0;
		
		private var mValidMinColStartIndex:int = 0;
		private var mValidMaxColCount:int = 0;
		private var mValidMinRowStartIndex:int = 0;
		private var mValidMaxRowCount:int = 0;
		
		//the run time
		private var mLastValidColStartIndex:int = 0;
		private var mLastValidColCount:int = 0;
		private var mLastValidRowStartIndex:int = 0;
		private var mLastValidRowCount:int = 0;
		
		private var mOverlapColStartIndex:int = 0;
		private var mOverlapColCount:int = 0;
		private var mOverlapRowStartIndex:int = 0;
		private var mOverlapRowCount:int = 0;
		
		private var mViewPortX:Number, mViewPortY:Number, mViewPortWidth:Number, mViewPortHeight:Number;
		
		public function ViewportGridUtil(cellWidth:int, cellHeight:int,
											 maxColCount:int, maxRowCount:int,
											 minColStartIndex:int = 0, minRowStartIndex:int = 0)
		{
			super();
			
			mCellWidth = cellWidth;
			mCellHeight = cellHeight;
			
			mValidMinColStartIndex = minColStartIndex;
			mValidMaxColCount = maxColCount;
			
			mValidMinRowStartIndex = minRowStartIndex;
			mValidMaxRowCount = maxRowCount;
		}
		
		public function get cellWidth():int 
		{ 
			return mCellWidth; 
		}
		
		public function get cellHeight():int 
		{ 
			return mCellHeight;
		}
		
		public function get minColStartIndex():int 
		{ 
			return mValidMinColStartIndex;
		}
		
		public function get maxColCount():int 
		{ 
			return mValidMaxColCount;
		}
		
		public function get minRowStartIndex():int 
		{ 
			return mValidMinRowStartIndex; 
		}
		
		public function get maxRowCount():int 
		{ 
			return mValidMaxRowCount;
		}

		public function get viewPort():Rectangle 
		{ 
			return new Rectangle(mViewPortX, mViewPortY, mViewPortWidth, mViewPortHeight);
		}
		
		public function setViewPort(viewPortX:Number, viewPortY:Number, 
								viewPortWidth:Number, viewPortHeight:Number):void
		{
			mViewPortX = viewPortX;
			mViewPortY = viewPortY;
			mViewPortWidth = viewPortWidth;
			mViewPortHeight = viewPortHeight;
		}

		public function updateRangeChange():void
		{
			saveCurrentValidCellsRange();
			
			updateValidCellsRangeByViewPort(mViewPortX, mViewPortY, mViewPortWidth, mViewPortHeight);
			
			if(adjustValidCellRangeFunction != null)
			{
				adjustValidCellRangeFunction();
			}
			
			clampValidCellRange();
			
			if(checkCellsIsChanged())
			{
				updateCellsOverlap();
				updateInValideAndValidCells();
			}
		}
		
		private function saveCurrentValidCellsRange():void
		{
			mLastValidColStartIndex = validColStartIndex;
			mLastValidColCount = validColCount;
			
			mLastValidRowStartIndex = validRowStartIndex;
			mLastValidRowCount = validRowCount;
		}
		
		private function updateValidCellsRangeByViewPort(viewPortX:Number, viewPortY:Number, 
														 viewPortWidth:Number, viewPortHeight:Number):void
		{
			validColStartIndex = Math.floor(viewPortX / mCellWidth);
			
			var mValidColEndIndex:int = Math.floor((viewPortX + viewPortWidth) / mCellWidth);
			validColCount = mValidColEndIndex - validColStartIndex + 1;
			
			validRowStartIndex = Math.floor(viewPortY / mCellHeight);
			
			var mValidRowEndIndex:int = Math.floor((viewPortY + viewPortHeight) / mCellHeight);
			validRowCount = mValidRowEndIndex - validRowStartIndex + 1;
		}
		
		private function clampValidCellRange():void
		{
			validColStartIndex = MathUtil.max(validColStartIndex, mValidMinColStartIndex);
			validColCount = MathUtil.min(validColCount, mValidMaxColCount - validColStartIndex);
			
			validRowStartIndex = MathUtil.max(validRowStartIndex, mValidMinRowStartIndex);
			validRowCount = MathUtil.min(validRowCount, mValidMaxRowCount - validRowStartIndex);
		}
		
		private function checkCellsIsChanged():Boolean
		{
			return mLastValidColStartIndex != validColStartIndex || 
				mLastValidColCount != validColCount || 
				mLastValidRowStartIndex != validRowStartIndex || 
				mLastValidRowCount != validRowCount;
		}
		
		private function updateCellsOverlap():void
		{
			//clear last
			mOverlapColCount = 0;
			mOverlapRowCount = 0;

			if(mLastValidColCount > 0 && validColCount > 0)
			{
				if(mLastValidColStartIndex >= validColStartIndex &&
					mLastValidColStartIndex < (validColStartIndex + validColCount))
				{
					mOverlapColStartIndex = mLastValidColStartIndex;
					mOverlapColCount = MathUtil.min(validColStartIndex + validColCount - mLastValidColStartIndex, mLastValidColCount);
				}
				else if((mLastValidColStartIndex + mLastValidColCount) > validColStartIndex && 
					(mLastValidColStartIndex + mLastValidColCount) <= (validColStartIndex + validColCount))
				{
					mOverlapColStartIndex = validColStartIndex;
					mOverlapColCount = MathUtil.min(mLastValidColStartIndex + mLastValidColCount - validColStartIndex, mLastValidColCount);
				}
			}
			
			if(mLastValidRowCount > 0 && validRowCount > 0)
			{
				if(mLastValidRowStartIndex >= validRowStartIndex &&
					mLastValidRowStartIndex < (validRowStartIndex + validRowCount))
				{
					mOverlapRowStartIndex = mLastValidRowStartIndex;
					mOverlapRowCount = MathUtil.min(validRowStartIndex + validRowCount- mLastValidRowStartIndex, mLastValidRowCount);
				}
				else if((mLastValidRowStartIndex + mLastValidRowCount) > validRowStartIndex && 
					(mLastValidRowStartIndex + mLastValidRowCount) <= (validRowStartIndex + validRowCount))
				{
					mOverlapRowStartIndex = validRowStartIndex;
					mOverlapRowCount = MathUtil.min(mLastValidRowStartIndex + mLastValidRowCount - validRowStartIndex, mLastValidRowCount);
				}
			}
		}
		
		private function updateInValideAndValidCells():void
		{
			//remove the out of valid
			updateInValidOrValidCells(true, mLastValidColStartIndex, mLastValidColCount, mLastValidRowStartIndex, mLastValidRowCount,
				mOverlapColStartIndex, mOverlapColCount, mOverlapRowStartIndex, mOverlapRowCount);
			
			//add the in valid
			updateInValidOrValidCells(false, validColStartIndex, validColCount, validRowStartIndex, validRowCount,
				mOverlapColStartIndex, mOverlapColCount, mOverlapRowStartIndex, mOverlapRowCount);
		}
		
		private function updateInValidOrValidCells(isInValideCells:Boolean, 
													 colStartIndex:int, colCount:int, 
													 rowStartIndex:int, rowCount:int,
													 overlapStartColIndex:int, overlapColCount:int, 
													 overlapRowStartIndex:int, overlapRowCount:int):void
		{
			var overlapRowEndIndex:int = overlapRowStartIndex + overlapRowCount;
			var overlapColEndIndex:int = overlapStartColIndex + overlapColCount;
			
			var rowEndIndex:int = rowStartIndex + rowCount;
			var colEndIndex:int = colStartIndex + colCount;
			
			//			trace(isInValideCells, colStartIndex, 
			//				colCount, rowStartIndex, rowCount, 
			//				overlapStartColIndex, overlapColCount, overlapRowStartIndex, overlapRowCount);
			
			for(var rowIndex:int = rowStartIndex; rowIndex < rowEndIndex; rowIndex++)
			{
				for(var colIndex:int = colStartIndex; colIndex < colEndIndex; colIndex++)
				{
					//skip the overlap cells.
					if(colIndex >= overlapStartColIndex && colIndex < overlapColEndIndex && 
						rowIndex >= overlapRowStartIndex && rowIndex < overlapRowEndIndex) continue;
					
					//logic here
					if(isInValideCells)
					{
						deactiveInvalidCell(colIndex, rowIndex);
					}
					else
					{
						activeValidCell(colIndex, rowIndex);
					}
				}
			}
		}
		
		private function deactiveInvalidCell(colIndex:int, rowIndex:int):void
		{
			if(deactiveInvalidCellFunction != null) deactiveInvalidCellFunction(colIndex, rowIndex);
		}
		
		private function activeValidCell(colIndex:int, rowIndex:int):void
		{
			if(activeValidCellFunction != null) activeValidCellFunction(colIndex, rowIndex);
		}
	}
}