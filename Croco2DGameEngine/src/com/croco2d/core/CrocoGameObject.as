package com.croco2d.core
{
	import com.croco2d.components.TransformComponent;
	import com.croco2d.components.collision.SpatialCollisionComponent;
	import com.croco2d.components.render.RenderComponent;
	import com.croco2d.components.script.ScriptComponent;
	import com.fireflyLib.utils.JsonObjectFactorUtil;
	import com.fireflyLib.utils.MathUtil;
	
	import flash.geom.Point;
	
	import starling.core.RenderSupport;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.utils.MatrixUtil;
	
	use namespace croco_internal;
	
	public final class CrocoGameObject extends CrocoObjectEntity
	{
		public static const EVENT_ADD_GAME_OBJECT:String = "addGameObject";
		public static const EVENT_REMOVE_GAME_OBJECT:String = "removeGameObject";
		
		public static const PROP_RENDER_COMPONENT:String = "renderComponent";
		public static const PROP_SPATIAL_COLLISION_COMPONENT_COMPONENT:String = "spatialCollisionComponent";
		public static const PROP_SCRIPT_COMPONENT:String = "scriptComponent";
		
		public static function createEmpty():CrocoGameObject
		{
			return new CrocoGameObject();
		}
		
		public static function createFromJsonConfig(jsonConfig:Object):CrocoGameObject
		{
			return JsonObjectFactorUtil.createFromJsonConfig(jsonConfig);
		}

		//keep this not null
		public var transformComponent:TransformComponent;
		public var renderComponent:RenderComponent;
		public var spatialCollisionComponent:SpatialCollisionComponent;
		public var scriptComponent:ScriptComponent;
		
		//we can control the tree's visible.
		public var visible:Boolean = true;
		//we can control the tree's alpha.
		public var alpha:Number = 1.0;
		public var blendMode:String = BlendMode.AUTO;

		public var touchable:Boolean = true;

		public var initChildrenGameObjects:Array;

		public var __gameObjectsGroup:CrocoObjectGroup;
		public var __onAddGameObjectCallback:Function = onAddGameObject;
		public var __onRemoveGameObjectCallback:Function = onRemoveGameObject;
		
		public function CrocoGameObject()
		{
			super();
			
			//we must have a TransformComponent.
			transformComponent = new TransformComponent();
			transformComponent.owner = this;
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
			
			switch(component.name)
			{
				case PROP_RENDER_COMPONENT:
					renderComponent = component as RenderComponent;
					break;
				
				case PROP_SPATIAL_COLLISION_COMPONENT_COMPONENT:
					spatialCollisionComponent = component as SpatialCollisionComponent;
					break;

				case PROP_SCRIPT_COMPONENT:
					scriptComponent = component as ScriptComponent;
					break;
			}
		}
		
		override protected function onPlugoutComponent(component:CrocoObject, needDispose:Boolean=false):void
		{
			switch(component.name)
			{
				case PROP_RENDER_COMPONENT:
					renderComponent = null;
					break;
				
				case PROP_SPATIAL_COLLISION_COMPONENT_COMPONENT:
					spatialCollisionComponent = null;
					break;
				
				case PROP_SCRIPT_COMPONENT:
					scriptComponent = null;
					break;
			}
			
			super.onPlugoutComponent(component, needDispose);
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			__gameObjectsGroup.tick(deltaTime);
		}
		
		public final function draw(support:RenderSupport, parentAlpha:Number):void
		{
			parentAlpha *= alpha;
			
			const lastBlendMode:String = support.blendMode;
			
			//u will hard to break the parent matrix rule.
			support.pushMatrix();
			support.prependMatrix(transformComponent.transformMatrix);
			//record the render world modelViewMatrix.
			transformComponent.__lastModelViewMatrix.copyFrom(support.modelViewMatrix);

			support.blendMode = blendMode;

			//u will hard to break the parent alpha rule.
			if(renderComponent && renderComponent.__alive)
			{
				renderComponent.draw(support, parentAlpha);
			}
			
			//children
			var child:CrocoGameObject = __gameObjectsGroup.moveFirst() as CrocoGameObject;
			while(child)
			{
				if(child.__alive && child.visible)
				{
					child.draw(support, parentAlpha);
				}
				
				child = __gameObjectsGroup.moveNext() as CrocoGameObject;
			}
			
			support.popMatrix();
			support.blendMode = lastBlendMode;
		}
		
		public final function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(forTouch && (!visible || !touchable)) return null;

			var hitTestTarget:DisplayObject;
			
			var localX:Number = localPoint.x;
			var localY:Number = localPoint.y;
			
			//child
			var child:CrocoGameObject = __gameObjectsGroup.moveLast() as CrocoGameObject;
			while(child)
			{
				if(child.__alive)
				{
					MatrixUtil.transformCoords(child.transformComponent.transformMatrix, localX, localY, 
						MathUtil.helperFlashPoint);
					
					hitTestTarget = child.hitTest(MathUtil.helperFlashPoint, forTouch);
					if(hitTestTarget) return hitTestTarget;
				}
				
				child = __gameObjectsGroup.movePre() as CrocoGameObject;
			}
			
			if(renderComponent && renderComponent.__alive)
			{
				hitTestTarget = renderComponent.hitTest(localPoint, forTouch);
				if(hitTestTarget) return hitTestTarget;
			}
			
			return null;
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
		
		override public function dispose():void
		{
			super.dispose();
			
			if(transformComponent)
			{
				transformComponent.dispose();
				transformComponent = null;
			}
			
			renderComponent = null;
			
			initChildrenGameObjects = null;
			
			if(__gameObjectsGroup)
			{
				__gameObjectsGroup.dispose();
				__gameObjectsGroup = null;
			}

			__onAddGameObjectCallback = null;
			__onRemoveGameObjectCallback = null;
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