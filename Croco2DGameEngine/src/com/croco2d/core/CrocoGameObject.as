package com.croco2d.core
{
	import com.croco2d.components.RenderComponent;
	import com.croco2d.utils.CrocoTransform;
	
	import starling.core.RenderSupport;
	
	use namespace croco_internal;
	
	internal final class CrocoGameObject extends CrocoObjectEntity
	{
		public static const EVENT_ADD_GAME_OBJECT:String = "addGameObject";
		public static const EVENT_REMOVE_GAME_OBJECT:String = "removeGameObject";

		//keep this not null
		public const transform:CrocoTransform = new CrocoTransform();
		
		public var renderComponent:RenderComponent;
		
		public var initChildrenGameObjects:Array;

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
		
		
		override protected function onPluginComponent(component:CrocoObject):void 
		{
			super.onPluginComponent(component);
			
			if(component is RenderComponent)
			{
				renderComponent = component as RenderComponent;
			}
		}
		
		override protected function onPlugoutComponent(component:CrocoObject, needDispose:Boolean=false):void
		{
			if(component === renderComponent)
			{
				renderComponent = null;
			}
			
			super.onPlugoutComponent(component, needDispose);
		}
		
		public final function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(renderComponent)
			{
				renderComponent.draw(support, parentAlpha);
			}
			
			var child:CrocoGameObject = __gameObjectsGroup.moveFirst() as CrocoGameObject;
			while(child)
			{
				if(child.__alive)
				{
					child.draw(support, parentAlpha);
				}
				
				child = __gameObjectsGroup.moveNext() as CrocoGameObject;
			}
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