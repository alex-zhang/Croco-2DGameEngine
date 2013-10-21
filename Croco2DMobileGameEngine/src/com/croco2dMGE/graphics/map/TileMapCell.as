package com.croco2dMGE.graphics.map
{
	import com.croco2dMGE.graphics.CrocoImage;

	public class TileMapCell extends CrocoImage implements IMapCellRender
	{
		private var mCellWidth:int = 0;
		private var mCellHeight:int = 0;
		
		private var mColIndex:int = 0;
		private var mRowIndex:int = 0;
		
		private var mOwner:MapBasic;
		
		public function TileMapCell(cellWidth:int, cellHeight:int)
		{
			super(cellWidth, cellHeight);
			
			mCellWidth = cellWidth;
			mCellHeight = cellHeight;
		}
		
		public function get colIndex():int { return mColIndex; };
		public function set colIndex(value:int):void 
		{
			mColIndex = value;
		}
		
		public function get rowIndex():int { return mRowIndex; };
		public function set rowIndex(value:int):void 
		{
			mRowIndex = value;
		}
		
		public function get cellWidth():int { return mCellWidth; };
		public function get cellHeight():int { return mCellHeight; };
		
		public function get owner():MapBasic { return mOwner; };
		public function set owner(value:MapBasic):void { mOwner = value; }
		
		public function onActive():void
		{
			this.x = mCellWidth * mColIndex;
			this.y = mCellHeight * mRowIndex;
		}
		
		public function onDeActive():void 
		{
			this.texture = null;
		}
	}
}