package com.croco2d.components.render
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.display.map.TileMap;
	
	import flash.geom.Rectangle;

	public class TileMapComponent extends DisplayObjectComponent
	{
		public var __tileMap:TileMap;
		
		public var mapCellCls:Class;
		public var cellWidth:int;
		public var cellHeight:int;
		public var maxColCount:int;
		public var maxRowCount:int;
		public var minColStartIndex:int;
		public var minRowStartIndex:int;

		public function TileMapComponent()
		{
			super();
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			__tileMap = new TileMap(cellWidth, cellHeight, 
				maxColCount, maxRowCount, 
				minColStartIndex, minRowStartIndex);
			
			__tileMap.mapCellCls = mapCellCls;
//			displayObject = __tileMap;
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			var cameraAABB:Rectangle = CrocoEngine.camera.aabb;
			
			__tileMap.setViewPort(cameraAABB.x, cameraAABB.y, 
				cameraAABB.width, cameraAABB.height);
			
//			__tileMap.setViewPort(441, 0 ,960, 600);
			
			__tileMap.tick(deltaTime);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			__tileMap = null;
		}
	}
}