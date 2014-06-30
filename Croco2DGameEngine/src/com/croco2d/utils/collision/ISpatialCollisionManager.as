package com.croco2d.utils.collision
{
	import com.croco2d.scene.CrocoGameObject;

	public interface ISpatialCollisionManager
	{
		function addSceneEntity(sceneEntity:CrocoGameObject):CrocoGameObject;
		function removeSceneEntity(sceneEntity:CrocoGameObject):CrocoGameObject;
		function hasSceneEntity(sceneEntity:CrocoGameObject):Boolean;
		
		//return SceneEntities.
		function queryEntitiesIsOverlapPoint(scenePosX:Number, scenePosY:Number, 
											 results:Array = null,
											 filterFunc:Function = null,
											 isOneQuery:Boolean = false):Array;
		
		//return SceneEntities.
		function queryEntitiesIsOverlapRect(scenePosX:Number, scenePosY:Number, rectWidth:Number, rectHeight:Number,
									   results:Array = null,
									   filterFunc:Function = null,
									   isOneQuery:Boolean = false):Array;

		//return SceneEntities.
		function queryEntitiesIsOverlapCircle(scenePosX:Number,  scenePosY:Number, circleRadius:Number,
									  results:Array = null,
									  filterFunc:Function = null, 
									  isOneQuery:Boolean = false):Array;

		function queryEntitiesIsOverlapCustom(scenePosX:Number,  scenePosY:Number, customType:int = 0, params:Array = null,
											  results:Array = null,
											  filterFunc:Function = null, 
											  isOneQuery:Boolean = false):Array;
	}
}