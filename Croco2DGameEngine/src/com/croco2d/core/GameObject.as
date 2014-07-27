package com.croco2d.core
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.components.TransformComponent;
	import com.croco2d.components.collision.ISpatialCollisionManager;
	import com.croco2d.components.collision.SpatialCollisionComponent;
	import com.croco2d.components.physics.PhysicsSpaceComponent;
	import com.croco2d.components.physics.RigidbodyComponent;
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
	
	public final class GameObject extends CrocoObjectEntity
	{
		public static const EVENT_ADD_GAME_OBJECT:String = "addGameObject";
		public static const EVENT_REMOVE_GAME_OBJECT:String = "removeGameObject";
		public static const EVENT_TOUCH:String = "touch";

		public static const PROP_RENDER:String = "render";
		public static const PROP_SPATIAL_COLLISION:String = "spatialCollisionComponent";
		public static const PROP_PHYSICS_SPACE:String = "physicsSpace";
		public static const PROP_RIGID_BODY:String = "rigidbody";
		
		public static const PROP_SCRIPT:String = "scriptComponent";

		public static function createEmpty():GameObject
		{
			return new GameObject();
		}
		
		public static function createFromJsonConfig(jsonConfig:Object):GameObject
		{
            return JsonObjectFactorUtil.createFromJsonConfig(jsonConfig);
        }
		
		//keep this not null
		public var transform:TransformComponent;
        public var __isCameraTransformMatrix:Boolean = false;

        public var render:RenderComponent;
        public var spatialCollisionManager:ISpatialCollisionManager;

		public var spatialCollision:SpatialCollisionComponent;
        public var physicsSpace:PhysicsSpaceComponent;
        public var rigidbody:RigidbodyComponent;

		public var cameraRender:RenderComponent;

		public var script:ScriptComponent;
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

		public function GameObject()
		{
			super();
			
			//we must have a TransformComponent.
			transform = new TransformComponent();
			transform.owner = this;
			
			//defualt is controll by global.
			debug = CrocoEngine.debug;
		}
		
		public final function addGameObejct(gameObject:GameObject):GameObject
		{
			return __gameObjectsGroup.addChild(gameObject) as GameObject;
		}
		
		public final function removeGameObject(gameObject:GameObject):GameObject
		{
			return __gameObjectsGroup.removeChild(gameObject) as GameObject;
		}
		
		protected function onAddGameObject(gameObject:GameObject):void
		{
			gameObject.parent = this;

			gameObject.init();
			gameObject.active();
			
			dispatchEvent(EVENT_ADD_GAME_OBJECT);
		}
		
		protected function onRemoveGameObject(gameObject:GameObject, needDispose:Boolean = false):void 
		{
			gameObject.deactive();
			
			dispatchEvent(EVENT_REMOVE_GAME_OBJECT, gameObject);
			
			if(needDispose) gameObject.dispose();
		}
		
		public final function removeAllGameObjects(needDispose:Boolean = false):void
		{
			__gameObjectsGroup.removeAllChildren(needDispose);
		}
		
		public final function markChildrenGameObjectsOrderSortDirty():void
		{
			__gameObjectsGroup.markChildrenOrderSortDirty();
		}
		
		public final function hasGameObject(gameObject:GameObject):Boolean
		{
			return __gameObjectsGroup.hasChild(gameObject);
		}
		
		public final function getChildrenGameObjectsCount():int
		{
			return __pluinComponentsGroup.length;
		}
		
		public final function findGameObjectByFilterFunc(filterFunc:Function = null):GameObject 
		{
			return __gameObjectsGroup.findChildByFilterFunc(filterFunc) as GameObject;
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
				case PROP_RENDER:
					render = component as RenderComponent;
					break;
				
				case PROP_SPATIAL_COLLISION:
					spatialCollision = component as SpatialCollisionComponent;
					break;
				
				case PROP_PHYSICS_SPACE:
					physicsSpace = component as PhysicsSpaceComponent;
					break;
				
				case PROP_RIGID_BODY:
					rigidbody = component as RigidbodyComponent;
					break;

				case PROP_SCRIPT:
					script = component as ScriptComponent;
					break;
			}
		}
		
		override protected function onPlugoutComponent(component:CrocoObject, needDispose:Boolean=false):void
		{
			switch(component.name)
			{
				case PROP_RENDER:
					render = null;
					break;
				
				case PROP_SPATIAL_COLLISION:
					spatialCollision = null;
					break;
				
				case PROP_RIGID_BODY:
					rigidbody = null;
					break;

				case PROP_SCRIPT:
					script = null;
					break;
			}

			super.onPlugoutComponent(component, needDispose);
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);

			__gameObjectsGroup.tick(deltaTime);
		}
		
		override public function onDebugDraw():void 
		{
			super.onDebugDraw();
			
			__gameObjectsGroup.onDebugDraw();
			
			CrocoEngine.debugGraphics.lineStyle(1, 0x00FF00);
			
			var lineLenth:Number = 20;
			
			CrocoEngine.debugGraphics.moveTo(transform.x, transform.y - lineLenth);
			CrocoEngine.debugGraphics.lineTo(transform.x, transform.y + lineLenth);
			CrocoEngine.debugGraphics.moveTo(transform.x - lineLenth, transform.y);
			CrocoEngine.debugGraphics.lineTo(transform.x + lineLenth, transform.y);
		}
		
		public final function draw(support:RenderSupport, parentAlpha:Number):void
		{
			parentAlpha *= alpha;

			const lastBlendMode:String = support.blendMode;
            support.blendMode = blendMode;

			//u will hard to break the parent matrix rule.
			support.pushMatrix();

            if(__isCameraTransformMatrix)
            {
                MathUtil.helperMatrix.copyFrom(transform.transformMatrix);
                MathUtil.helperMatrix.invert();
                support.prependMatrix(MathUtil.helperMatrix);
            }
            else
            {
                support.prependMatrix(transform.transformMatrix);
            }

			//u will hard to break the parent alpha rule.
			if(render && render.__alive)
			{
				render.draw(support, parentAlpha);
			}

            //if __isCameraTransformMatrix his children will not effect by his matrix.
            if(__isCameraTransformMatrix) support.popMatrix();
            //record the render world modelViewMatrix.
            transform.__lastModelViewMatrix.copyFrom(support.modelViewMatrix);

			//children
			var child:GameObject = __gameObjectsGroup.moveFirst() as GameObject;
			while(child)
			{
				if(child.__alive && child.visible)
				{
					child.draw(support, parentAlpha);
				}
				
				child = __gameObjectsGroup.moveNext() as GameObject;
			}

            if(!__isCameraTransformMatrix) support.popMatrix();

			support.blendMode = lastBlendMode;
		}
		
		public final function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(forTouch && (!visible || !touchable)) return null;

			var hitTestTarget:DisplayObject;
			
			var localX:Number = localPoint.x;
			var localY:Number = localPoint.y;
			
			//child
			var child:GameObject = __gameObjectsGroup.moveLast() as GameObject;
			while(child)
			{
				if(child.__alive)
				{
					MatrixUtil.transformCoords(child.transform.transformMatrix, localX, localY, 
						MathUtil.helperPoint);
					
					hitTestTarget = child.hitTest(MathUtil.helperPoint, forTouch);
					if(hitTestTarget) return hitTestTarget;
				}
				
				child = __gameObjectsGroup.movePre() as GameObject;
			}
			
			if(render && render.__alive)
			{
				hitTestTarget = render.hitTest(localPoint, forTouch);
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
		
		override protected function onInited():void
		{
			if(script)
			{
				script.onGameObjectInited();
			}
			
			super.onInited();
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			__gameObjectsGroup.active();
		}
		
		override protected function onDeactive():void
		{
			super.onDeactive();
			
			__gameObjectsGroup.deactive();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(transform)
			{
				transform.dispose();
				transform = null;
			}
			
			render = null;
			
			spatialCollision = null;
			physicsSpace = null;
			rigidbody = null;
			cameraRender = null;
			
			blendMode = null;

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