package com.croco2d.core
{
	import com.croco2d.components.RenderComponent;
	
	internal final class CrocoGameObject extends CrocoObjectEntity
	{
		public static const EVENT_ADD_GAME_OBJECT:String = "addGameObject";
		public static const EVENT_REMOVE_GAME_OBJECT:String = "removeGameObject";
		
		public var initChildrenGameObjects:Array;

		public var x:Number = 0;
		public var y:Number = 0;
		
		public var scaleX:Number = 0;
		public var scaleY:Number = 0;
		
		public var rotation:Number = 0;
		
		public var width:Number = 0;
		
		public var height:Number = 0;
		
		public var renderComponent:RenderComponent;

		public var __gameObjectsGroup:CrocoObjectGroup;
		public var __onAddGameObjectCallback:Function = onAddGameObject;
		public var __onRemoveGameObjectCallback:Function = onRemoveGameObject;
		
		public function CrocoGameObject()
		{
			super();
		}
		
		public final function addGameObejct(gameObject:CrocoGameObject):CrocoGameObject
		{
			return __gameObjectsGroup.addChild(gameObject) as CrocoGameObject;
		}
		
		public final function removeGameObject(gameObject:CrocoGameObject):CrocoGameObject
		{
			return __gameObjectsGroup.removeChild(gameObject) as CrocoGameObject;
		}
		
		protected function onAddGameObject(gameObject:CrocoGameObject):void 
		{
			gameObject.parent = __gameObjectsGroup;
			gameObject.owner = this;

			gameObject.init();
			gameObject.active();
			
			emitEvent(EVENT_ADD_GAME_OBJECT);
		}
		
		protected function onRemoveGameObject(gameObject:CrocoGameObject, needDispose:Boolean = false):void 
		{
			gameObject.deactive();
			
			emitEvent(EVENT_REMOVE_GAME_OBJECT, gameObject);
			
			if(needDispose) gameObject.dispose();
		}
		
		public final function markChildrenGameObjectsOrderSortDirty():void
		{
			__gameObjectsGroup.markChildrenOrderSortDirty();
		}
		
		public final function hasGameObject(gameObject:CrocoGameObject):Boolean
		{
			return __gameObjectsGroup.hasChild(gameObject);
		}
		
		public final function getChildrenGameObjectsCount():int
		{
			return __pluinComponentsGroup.length;
		}
		
		public final function findGameObjectByFilterFunc(filterFunc:Function = null):CrocoGameObject 
		{
			return __gameObjectsGroup.findChildByFilterFunc(filterFunc) as CrocoGameObject;
		}
		
		public final function findGameObjectsByFilterFunc(results:Array = null, filterFunc:Function = null):Array 
		{
			return __gameObjectsGroup.findChildrenByFilterFunc(results, filterFunc);
		}
		
		public final function findAllChildrenGameObjects(results:Array = null):Array
		{
			return __gameObjectsGroup.findAllChildren(results);
		}
		
		public final function forEachChildGameObject(callback:Function):void
		{
			__gameObjectsGroup.forEach(callback);
		}
		
		public final function lastForEachChildGameObject(callback:Function):void
		{
			__gameObjectsGroup.lastForEach(callback);
		}

		override protected function onInit():void
		{
			super.onInit();
			
			__gameObjectsGroup = new CrocoObjectGroup();
			__gameObjectsGroup.name = "__gameObjectsGroup";
			__gameObjectsGroup.initChildren = initChildrenGameObjects;
			__gameObjectsGroup.__onAddChildCallback = onAddGameObject;
			__gameObjectsGroup.__onRemoveChildCallback = onRemoveGameObject;
			__gameObjectsGroup.init();
			
			initChildrenGameObjects = null;
		}
		
		override protected function onActive():void
		{
			__gameObjectsGroup.active();
		}
		
		override protected function onDeactive():void
		{
			__gameObjectsGroup.deactive();
		}
		
		override public function toString():String
		{
			var results:String = super.toString() + "\n" +
				"__gameObjectsGroup: " + __gameObjectsGroup + "\n";
			
			__gameObjectsGroup.forEach(
				function(item:CrocoObject):void
				{
					results += item + "\n";
				});
		
			return results;
		}
	}
}