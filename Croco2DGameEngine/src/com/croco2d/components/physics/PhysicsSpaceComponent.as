package com.croco2d.components.physics
{
	import com.croco2d.AppConfig;
	import com.croco2d.CrocoEngine;
	import com.croco2d.core.CrocoObject;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.space.Broadphase;
	import nape.space.Space;
	import nape.util.Debug;
	import nape.util.ShapeDebug;
	
	import starling.core.Starling;

	public class PhysicsSpaceComponent extends CrocoObject
	{
		public var timeStep:Number = AppConfig.globalEvnConfig.physicsStepTime;
		
		/**
		 * velocityIterations for the velocity constraint solver.
		 */
		public var velocityIterations:int = 8;
		
		/**
		 *positionIterations for the position constraint solver.
		 */
		public var positionIterations:int = 8;
		
		public var broadphase:Broadphase = Broadphase.DYNAMIC_AABB_TREE;
		
		public var gravity:Vec2 = new Vec2(AppConfig.globalEvnConfig.gravityX, AppConfig.globalEvnConfig.gravityY);

		public var __physicsSpace:Space;
		public var __physicsDebug:Debug;
		
		public function PhysicsSpaceComponent()
		{
			super();
		}
		
		override protected function onInit():void
		{
			__physicsSpace = new Space(gravity, broadphase);
			
			__physicsSpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, CbType.ANY_BODY, 
				CbType.ANY_BODY, 
				onPhysicsSpaceInteractionBegin));
			
			__physicsSpace.listeners.add(new InteractionListener(CbEvent.END, InteractionType.ANY, CbType.ANY_BODY, 
				CbType.ANY_BODY, onPhysicsSpaceInteractionEnd));
			
			__physicsDebug = new ShapeDebug(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
			Starling.current.nativeOverlay.addChild(__physicsDebug.display);
			
			CrocoEngine.instance.addEventListener(CrocoEngine.EVENT_AFTER_DRAW, globalAfterDrawHandler);
		}
		
		protected function globalAfterDrawHandler(eventData:Object = null):void
		{
			if(debug)
			{
				__physicsDebug.clear();
				__physicsDebug.draw(__physicsSpace);
				__physicsDebug.flush();	
			}
		}
		
		protected function onPhysicsSpaceInteractionBegin(interactionCallback:InteractionCallback):void
		{
//			var a:PhysicsObject = interactionCallback.int1.userData.entity;
//			var b:PhysicsObject = interactionCallback.int2.userData.entity;
//			
//			if(a && a.__alive && a.physicsBeginContactCallEnabled) a.handleBeginContact(interactionCallback);
//			if(b && b.__alive && b.physicsBeginContactCallEnabled) b.handleBeginContact(interactionCallback);
		}
		
		protected function onPhysicsSpaceInteractionEnd(interactionCallback:InteractionCallback):void
		{
		}

		override public function tick(deltaTime:Number):void
		{
			__physicsSpace.step(timeStep, velocityIterations, positionIterations);
		}
		
		override public function dispose():void
		{
			super.dispose();

			if(gravity)
			{
				gravity.dispose();
				gravity = null;
			}
			
			CrocoEngine.instance.removeEventListener(CrocoEngine.EVENT_AFTER_DRAW, globalAfterDrawHandler);
			
			if(__physicsSpace)
			{
				__physicsSpace.clear();
				__physicsSpace = null;
			}
		}
	}
}