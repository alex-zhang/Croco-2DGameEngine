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
		
		public function addSpatialCollisionComponent(value:SpatialCollisionComponent):SpatialCollisionComponent
		{
			return value;
		}
		
		public function removeSpatialCollisionComponent(value:SpatialCollisionComponent):SpatialCollisionComponent
		{
			return value;
		}
		
		public function hasSpatialCollisionComponent(value:SpatialCollisionComponent):Boolean
		{
			return value;
		}
		
		//return SpatialCollisionComponents.
		public function querySpatialCollisionComponentsIsOverlapPoint(scenePosX:Number, scenePosY:Number, 
															   results:Array = null,
															   filterFunc:Function = null,
															   isOneQuery:Boolean = false):Array
		{
			return null;
		}
		
		//return SpatialCollisionComponents.
		public function querySpatialCollisionComponentsIsOverlapRect(scenePosX:Number, scenePosY:Number, rectWidth:Number, rectHeight:Number,
																	 results:Array = null,
																	 filterFunc:Function = null,
																	 isOneQuery:Boolean = false):Array
		{
			return null;
		}
		
		//return SpatialCollisionComponents.
		public function querySpatialCollisionComponentsIsOverlapCircle(scenePosX:Number,  scenePosY:Number, circleRadius:Number,
																	   results:Array = null,
																	   filterFunc:Function = null, 
																	   isOneQuery:Boolean = false):Array
		{
			return null;
		}
		
		//return SpatialCollisionComponents.
		public function querySpatialCollisionComponentsIsOverlapCustom(scenePosX:Number, scenePosY:Number, customType:int = 0, params:Array = null,
																	   results:Array = null,
																	   filterFunc:Function = null, 
																	   isOneQuery:Boolean = false):Array
		{
			return null;
		}
	}
}