package com.croco2d.entities
{
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.CrocoObjectEntity;
	import com.croco2d.core.CrocoObjectGroup;
	import com.croco2d.core.CrocoObjectSet;
	
	import flash.geom.Point;
	
	import starling.core.RenderSupport;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	
	public class SceneLayer extends CrocoObjectEntity
	{
		public static const EVENT_ADD_SCENE_ENTITY:String = "addSceneEntity";
		public static const EVENT_REMOVE_SCENE_ENTITY:String = "removeSceneEntity";
		
		//----------------------------------------------------------------------
		
		public var initSceneEnetities:Array;

		public var alpha:Number = 1.0;
		public var blendMode:String = BlendMode.AUTO;
		public var touchAble:Boolean = true;
		public var needRealTimeDepthSort:Boolean = false;
		public var depthSortFunction:Function = CrocoObjectSet.defaultDepthSortFunction;
		
		public var __sceneEntitiesGroup:CrocoObjectGroup;
		public var __onAddChildSceneEntityCallback:Function = onAddSceneEntity;
		public var __onRemoveChildSceneEntityCallback:Function = onRemoveSceneEntity;
		
		public function SceneLayer()
		{
			super();

			//draw able.
			visible = true;
		}
		
		public final function get scene():CrocoScene
		{
			return owner as CrocoScene;
		}
		
		//collision
		public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(forTouch && (!touchAble || !visible || alpha == 0)) return null;
			
			var displayObject:DisplayObject;

			var sceneEntity:SceneEntity = __sceneEntitiesGroup.moveLast() as SceneEntity;
			while(sceneEntity)
			{
				if(sceneEntity.__alive)
				{
					displayObject = sceneEntity.hitTest(localPoint, forTouch);
					
					if(displayObject) return displayObject;
				}

				sceneEntity = __sceneEntitiesGroup.movePre() as SceneEntity;
			}
			
			return null;
		}

		public function addSceneEntity(sceneEntity:SceneEntity):SceneEntity
		{
			return __sceneEntitiesGroup.addChild(sceneEntity) as SceneEntity;
		}
		
		protected function onAddSceneEntity(sceneEntity:SceneEntity):void
		{
			sceneEntity.parent = __sceneEntitiesGroup;
			sceneEntity.owner = this;
			sceneEntity.init();
			sceneEntity.active();
			
			if(!needRealTimeDepthSort) __sceneEntitiesGroup.markChildrenOrderSortDirty();
			
			if(eventEnable && eventEmitter.hasEventListener(EVENT_ADD_SCENE_ENTITY))
			{
				eventEmitter.dispatchEvent(EVENT_ADD_SCENE_ENTITY, sceneEntity);
			}
		}
		
		public function removeSceneEntity(sceneEntity:SceneEntity, needDispose:Boolean = false):SceneEntity
		{
			return __sceneEntitiesGroup.removeChild(sceneEntity, needDispose) as SceneEntity;
		}
		
		protected function onRemoveSceneEntity(sceneEntity:SceneEntity, needDispose:Boolean = false):void
		{
			sceneEntity.deactive();

			if(eventEnable && eventEmitter.hasEventListener(EVENT_REMOVE_SCENE_ENTITY))
			{
				eventEmitter.dispatchEvent(EVENT_REMOVE_SCENE_ENTITY, sceneEntity);
			}

			if(needDispose)
			{
				sceneEntity.dispose();
			}
		}
		
		public function markSceneEntitiesOrderSortDirty():void
		{
			__sceneEntitiesGroup.markChildrenOrderSortDirty();
		}
		
		public function getSceneEntitiesCount():int
		{
			return __sceneEntitiesGroup.length;
		}
		
		public function hasSceneEntity(sceneEntity:SceneEntity):Boolean
		{
			return __sceneEntitiesGroup.hasChild(sceneEntity);
		}
		
		public function findSceneEntityByField(field:String, value:*, filterFunc:Function = null):SceneEntity
		{
			return __sceneEntitiesGroup.findChildByField(field, value, filterFunc) as SceneEntity;
		}
		
		public function findSceneEntitiesByField(field:String, value:*, results:Array = null, filterFunc:Function = null):Array
		{
			return __sceneEntitiesGroup.findChildrenByField(field, value, results, filterFunc);
		}
		
		public function findSceneEntityByTypeCls(typeCls:Class, filterFunc:Function = null):SceneEntity
		{
			return __sceneEntitiesGroup.findChildByTypeCls(typeCls, filterFunc) as SceneEntity;
		}
		
		public function findSceneEntitiesByTypeCls(typeCls, results:Array = null):Array
		{
			return __sceneEntitiesGroup.findChildrenByTypeCls(typeCls, results);
		}
		
		public function findSceneEntityByFilterFunc(filterFunc:Function):CrocoObject 
		{
			return __sceneEntitiesGroup.findChildByFilterFunc(filterFunc);
		}
		
		public function findSceneEntitiesByFilterFunc(results:Array = null, filterFunc:Function = null):Array 
		{
			return __sceneEntitiesGroup.findChildrenByFilterFunc(results, filterFunc);
		}
		
		public function findAllSceneEntities(results:Array = null):Array
		{
			return __sceneEntitiesGroup.findAllChildren(results);
		}
		
		public function forEachSceneEntity(callback:Function):void
		{
			__sceneEntitiesGroup.forEach(callback);
		}
		
		public function forEach2SceneEntity(callback:Function):void
		{
			__sceneEntitiesGroup.forEach2(callback);
		}
		
		override protected function onInit():void
		{
			__sceneEntitiesGroup = new CrocoObjectGroup();
			__sceneEntitiesGroup.name = "__sceneEntitiesGroup";
			__sceneEntitiesGroup.__onAddChildCallback = __onAddChildSceneEntityCallback;
			__sceneEntitiesGroup.__onRemoveChildCallback = __onRemoveChildSceneEntityCallback;
			__sceneEntitiesGroup.initChildren = initSceneEnetities;
			__sceneEntitiesGroup.sortFunction = depthSortFunction;
			__sceneEntitiesGroup.init();
			initSceneEnetities = null;
			
			super.onInit();
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			__sceneEntitiesGroup.active();
		}
		
		override protected function onDeactive():void
		{
			super.onDeactive();
			
			__sceneEntitiesGroup.deactive();
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);

			__sceneEntitiesGroup.tick(deltaTime);
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			var curAlpha:Number = parentAlpha * alpha;
			
			if(needRealTimeDepthSort)
			{
				markSceneEntitiesOrderSortDirty();
			}
			
			var lastBlendMode:String = support.blendMode;
			
			support.blendMode = this.blendMode;

			__sceneEntitiesGroup.draw(support, curAlpha);
			
			super.draw(support, curAlpha);
			
			support.blendMode = lastBlendMode;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			initSceneEnetities = null;

			alpha = NaN;
			
			depthSortFunction = null;
			
			if(__sceneEntitiesGroup)
			{
				__sceneEntitiesGroup.dispose();
				__sceneEntitiesGroup = null;
			}
			
			__onAddChildSceneEntityCallback = null;
			__onRemoveChildSceneEntityCallback = null;
		}
		
		override public function toString():String
		{
			var results:String = super.toString() + "\n" +
				"alpha: " + alpha + "\n" +
				"touchAble: " + touchAble + "\n" +
				"needRealTimeDepthSort: " + needRealTimeDepthSort;
			
			return results;
		}
	}
}