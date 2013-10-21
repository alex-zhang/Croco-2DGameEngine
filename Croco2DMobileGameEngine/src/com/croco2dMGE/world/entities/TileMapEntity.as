package com.croco2dMGE.world.entities
{
	import com.croco2dMGE.graphics.map.TileMap;
	import com.croco2dMGE.utils.CrocoRect;
	import com.croco2dMGE.world.SceneEntity;

	public class TileMapEntity extends SceneEntity
	{
		public var tileMapCls:Class;
		
		public var cellWidth:int = 0;
		public var cellHeight:int = 0;
		public var maxColCount:int = 0;
		public var maxRowCount:int = 0;
		public var minColStartIndex:int = 0;
		public var minRowStartIndex:int = 0;
		
		protected var mTileMap:TileMap;
		
		public function TileMapEntity()
		{
			super();
		}
		
		override protected function onInit():void
		{
			tileMapCls ||= TileMap;
			mTileMap = new tileMapCls(cellWidth, cellHeight, maxColCount, maxRowCount, minColStartIndex, minRowStartIndex);
			displayObject = mTileMap;
			
			visibleTestRect = new CrocoRect(minColStartIndex * cellWidth, minRowStartIndex * cellHeight, 
				cellWidth * (maxColCount - minColStartIndex + 1), cellHeight * (maxRowCount - minRowStartIndex + 1));
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			mTileMap.setViewPort(mCamera.scrollX * scrollFactorX, 
				mCamera.scrollY * scrollFactorY, 
				mCamera.width, mCamera.height);
			
			mTileMap.tick(deltaTime);
		}
	}
}