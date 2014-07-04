package com.croco2d.components.collision
{
	import com.croco2d.utils.aoi.LampTowerGrid;

	public class LampTowerGridSpatialCollisionManager extends LampTowerGrid implements ISpatialCollisionManager
	{
		public function LampTowerGridSpatialCollisionManager(cellWidth:int, cellHeight:int,
															 maxColCount:int, maxRowCount:int)
		{
			super(cellWidth, cellHeight, maxColCount, maxRowCount);
		}
		
		//return SceneEntities.
		public function queryEntitiesIsOverlapPoint(scenePosX:Number, scenePosY:Number, 
											 results:Array = null,
											 filterFunc:Function = null,
											 isOneQuery:Boolean = false):Array
		{
			return null;
		}
		
		//return SceneEntities.
		public function queryEntitiesIsOverlapRect(scenePosX:Number, scenePosY:Number, rectWidth:Number, rectHeight:Number,
											results:Array = null,
											filterFunc:Function = null,
											isOneQuery:Boolean = false):Array
		{
			return null;
		}
		
		//return SceneEntities.
		public function queryEntitiesIsOverlapCircle(scenePosX:Number,  scenePosY:Number, circleRadius:Number,
											  results:Array = null,
											  filterFunc:Function = null, 
											  isOneQuery:Boolean = false):Array
		{
			return null;
		}
		
		public function queryEntitiesIsOverlapCustom(scenePosX:Number,  scenePosY:Number, customType:int = 0, params:Array = null,
											  results:Array = null,
											  filterFunc:Function = null, 
											  isOneQuery:Boolean = false):Array
		{
			return null;
		}
	}
}