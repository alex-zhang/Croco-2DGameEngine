package com.croco2d.utils.collision
{
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.CrocoObjectSet;
	import com.croco2d.core.croco_internal;
	import com.croco2d.scene.SceneEntity;
	import com.croco2d.utils.CrocoMathUtil;
	
	import flash.geom.Rectangle;
	
	use namespace croco_internal;

	public class SimpleSpatialCollisionManager extends CrocoObject implements ISpatialCollisionManager
	{
		public var __spatialSceneEntitiesSet:CrocoObjectSet;
		
		public function SimpleSpatialCollisionManager()
		{
			super();
		}
		
		public function addSceneEntity(sceneEntity:SceneEntity):SceneEntity
		{
			return __spatialSceneEntitiesSet.addChild(sceneEntity) as SceneEntity;
		}
		
		public function removeSceneEntity(sceneEntity:SceneEntity):SceneEntity
		{
			return __spatialSceneEntitiesSet.removeChild(sceneEntity) as SceneEntity;
		}
		
		public function hasSceneEntity(sceneEntity:SceneEntity):Boolean
		{
			return __spatialSceneEntitiesSet.hasChild(sceneEntity);
		}
		
		//return SceneEntities.
		public function queryEntitiesIsOverlapPoint(scenePosX:Number, scenePosY:Number, 
											 results:Array = null,
											 filterFunc:Function = null, 
											 isOneQuery:Boolean = false):Array
		{
			if(!results) results = [];
			
			var child:SceneEntity = __spatialSceneEntitiesSet.moveFirst() as SceneEntity;
			while(child)
			{
				if(child.__alive && child.__actived &&
					isSceneEntityOverlapPoint(child, scenePosX, scenePosY) && 
					(filterFunc == null || filterFunc(child)))
				{
					results.push(child);
					
					if(isOneQuery) return results;
				}
				
				child = __spatialSceneEntitiesSet.moveNext() as SceneEntity;
			}
			
			return results;
		}
		
		protected function isSceneEntityOverlapPoint(sceneEntity:SceneEntity, 
													 scenePosX:Number, scenePosY:Number):Boolean
		{
			if(sceneEntity.aabb)
			{
				const sceneEntityAABB:Rectangle = sceneEntity.aabb;
				
				return CrocoMathUtil.isOverlapPointAndRectangle(
					scenePosX, scenePosY - sceneEntity.y,
					sceneEntityAABB.x + sceneEntity.x, sceneEntityAABB.y + sceneEntity.y, sceneEntityAABB.width, sceneEntityAABB.height);
			}
			else
			{
				return CrocoMathUtil.isOverlapPointAndPoint(
					scenePosX, scenePosY,
					sceneEntity.x, sceneEntity.y);
			}
			
			return false;
		}
		
		//return SceneEntities.
		public function queryEntitiesIsOverlapRect(scenePosX:Number, scenePosY:Number, rectWidth:Number, rectHeight:Number,
											results:Array = null,
											filterFunc:Function = null,
											isOneQuery:Boolean = false):Array
		{
			if(!results) results = [];
			
			var child:SceneEntity = __spatialSceneEntitiesSet.moveFirst() as SceneEntity;
			while(child)
			{
				if(child.__alive && child.__actived &&
					isSceneEntityOverlapRect(child, scenePosX, scenePosY, rectWidth, rectHeight) &&
					(filterFunc == null || filterFunc(child)))
				{
					results.push(child);
					
					if(isOneQuery) return results;
				}
				
				child = __spatialSceneEntitiesSet.moveNext() as SceneEntity;
			}
			
			return results;
		}
		
		protected function isSceneEntityOverlapRect(sceneEntity:SceneEntity, 
													scenePosX:Number, scenePosY:Number, rectWidth:Number, rectHeight:Number):Boolean
		{
			if(sceneEntity.aabb)
			{
				const sceneEntityAABB:Rectangle = sceneEntity.aabb;
				
				return CrocoMathUtil.isOverlapRectangleAndRectangle(
					scenePosX, scenePosY, rectWidth, rectHeight,
					sceneEntityAABB.x + sceneEntity.x, sceneEntityAABB.y + sceneEntity.y, sceneEntityAABB.width, sceneEntityAABB.height);
			}
			else
			{
				return CrocoMathUtil.isOverlapPointAndRectangle(
					sceneEntity.x, sceneEntity.y,
					scenePosX, scenePosY, rectWidth, rectHeight);
			}
			
			return false;
		}
		
		//return SceneEntities.
		public function queryEntitiesIsOverlapCircle(scenePosX:Number, scenePosY:Number, circleRadius:Number,
											  results:Array = null,
											  filterFunc:Function = null, 
											  isOneQuery:Boolean = false):Array
		{
			if(!results) results = [];
			
			var child:SceneEntity = __spatialSceneEntitiesSet.moveFirst() as SceneEntity;
			while(child)
			{
				if(child.__alive && child.__actived &&
					isSceneEntityOverlapCircle(child, scenePosX, scenePosY, circleRadius) &&
					(filterFunc == null || filterFunc(child)))
				{
					results.push(child);
					
					if(isOneQuery) return results;
				}
				
				child = __spatialSceneEntitiesSet.moveNext() as SceneEntity;
			}
			
			return results;
		}
		
		protected function isSceneEntityOverlapCircle(sceneEntity:SceneEntity, 
													scenePosX:Number, scenePosY:Number, circleRadius:Number):Boolean
		{
			if(sceneEntity.aabb)
			{
				const sceneEntityAABB:Rectangle = sceneEntity.aabb;
				
				return CrocoMathUtil.isOverlapRectangleAndCircle(
					sceneEntityAABB.x + sceneEntity.x, sceneEntityAABB.y + sceneEntity.y, sceneEntityAABB.width, sceneEntityAABB.height,
					scenePosX, scenePosY, circleRadius);
			}
			else
			{
				return CrocoMathUtil.isOverlapPointAndCircle(
					sceneEntity.x, sceneEntity.y,
					scenePosX, scenePosY, circleRadius);
			}
		}
		
		public function queryEntitiesIsOverlapCustom(scenePosX:Number, scenePosY:Number, customType:int = 0, params:Array = null,
											  results:Array = null,
											  filterFunc:Function = null, 
											  isOneQuery:Boolean = false):Array
		{
			if(!results) results = [];
			
			var child:SceneEntity = __spatialSceneEntitiesSet.moveFirst() as SceneEntity;
			while(child)
			{
				if(child.__alive && child.__actived &&
					isSceneEntityOverlapCustom(child, scenePosX, scenePosY, customType, params) &&
					(filterFunc == null || filterFunc(child)))
				{
					results.push(child);
					
					if(isOneQuery) return results;
				}
				
				child = __spatialSceneEntitiesSet.moveNext() as SceneEntity;
			}
			
			return results;
		}
		
		public function isSceneEntityOverlapCustom(sceneEntity:SceneEntity, 
													  scenePosX:Number, scenePosY:Number, customType:int = 0, params:Array = null):Boolean
		{
			return false;
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			__spatialSceneEntitiesSet = new CrocoObjectSet();
			__spatialSceneEntitiesSet.name = "__spatialSceneEntitiesSet";
			__spatialSceneEntitiesSet.init();
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			__spatialSceneEntitiesSet.active();
		}
		
		override protected function onDeactive():void
		{
			super.onDeactive();
			
			__spatialSceneEntitiesSet.deactive();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__spatialSceneEntitiesSet)
			{
				__spatialSceneEntitiesSet.dispose();
				
				__spatialSceneEntitiesSet = null;
			}
		}
	}
}