package com.croco2d.components.collision
{
	public interface ISpatialCollisionManager
	{
		function addSpatialCollisionComponent(value:SpatialCollisionComponent):SpatialCollisionComponent;
		function removeSpatialCollisionComponent(value:SpatialCollisionComponent):SpatialCollisionComponent;
		function hasSpatialCollisionComponent(value:SpatialCollisionComponent):Boolean;
		
		//return SpatialCollisionComponents.
		function querySpatialCollisionComponentsIsOverlapPoint(scenePosX:Number, scenePosY:Number, 
											 results:Array = null,
											 filterFunc:Function = null,
											 isOneQuery:Boolean = false):Array;
		
		//return SpatialCollisionComponents.
		function querySpatialCollisionComponentsIsOverlapRect(scenePosX:Number, scenePosY:Number, rectWidth:Number, rectHeight:Number,
									   results:Array = null,
									   filterFunc:Function = null,
									   isOneQuery:Boolean = false):Array;

		//return SpatialCollisionComponents.
		function querySpatialCollisionComponentsIsOverlapCircle(scenePosX:Number,  scenePosY:Number, circleRadius:Number,
									  results:Array = null,
									  filterFunc:Function = null, 
									  isOneQuery:Boolean = false):Array;

		//return SpatialCollisionComponents.
		function querySpatialCollisionComponentsIsOverlapCustom(scenePosX:Number, scenePosY:Number, customType:int = 0, params:Array = null,
											  results:Array = null,
											  filterFunc:Function = null, 
											  isOneQuery:Boolean = false):Array;
	}
}