package com.croco2d.display.map
{
	import com.croco2d.display.CrocoImage;

	public class TileMapCell extends CrocoImage implements IMapCellRender
	{
		private var mCellWidth:int = 0;
		private var mCellHeight:int = 0;
		
		private var mColIndex:int = 0;
		private var mRowIndex:int = 0;
		
		private var mOwner:MapBasic;
		
		private var mActived:Boolean = false;
		
		public function TileMapCell(cellWidth:int, cellHeight:int)
		{
			super();
			
			mCellWidth = cellWidth;
			mCellHeight = cellHeight;
			
			this.width = mCellWidth;
			this.height = mCellHeight;
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
		
		public final function active():void
		{
			if(!mActived)
			{
				onActive();				
				mActived = true;
			}
		}
		
		protected function onActive():void
		{
			this.x = mCellWidth * mColIndex;
			this.y = mCellHeight * mRowIndex;
		}
		
		public final function deactive():void 
		{
			if(mActived)
			{
				onDeactive();
				mActived = false;
			}
		}
		
		protected function onDeactive():void
		{
			this.texture = null;
		}
		
		public final function get actived():Boolean
		{
			return mActived;
		}
	}
}