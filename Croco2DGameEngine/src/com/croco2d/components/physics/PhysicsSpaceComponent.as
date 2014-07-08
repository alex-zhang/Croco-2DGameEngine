package com.croco2d.components.physics
{
	import com.croco2d.AppConfig;
	import com.croco2d.core.CrocoObject;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.space.Broadphase;
	import nape.space.Space;

	public class PhysicsSpaceComponent extends CrocoObject
	{
		public var broadphase:Broadphase = Broadphase.DYNAMIC_AABB_TREE;
		
		/**
		 * velocityIterations for the velocity constraint solver.
		 */
		public var velocityIterations:int = 8;
		
		/**
		 *positionIterations for the position constraint solver.
		 */
		public var positionIterations:int = 8;
		
		public var __physicsSpace:Space;
		public var __gravity:Vec2 = new Vec2(AppConfig.globalEvnConfig.gravityX, AppConfig.globalEvnConfig.gravityY);
		
		public function PhysicsSpaceComponent()
		{
			super();
		}
		
		public function get gravity():Vec2
		{
			return __gravity;
		}
		
		public function set gravity(value:Vec2):void
		{
			__gravity = value;
			
			if(__physicsSpace)
			{
				__physicsSpace.gravity = value;
			}
		}
		
		override protected function onInit():void
		{
			__physicsSpace = new Space(__gravity, broadphase);
			
			__physicsSpace.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, CbType.ANY_BODY, 
				CbType.ANY_BODY, 
				onPhysicsSpaceInteractionBegin));
			
			__physicsSpace.listeners.add(new InteractionListener(CbEvent.END, InteractionType.ANY, CbType.ANY_BODY, 
				CbType.ANY_BODY, onPhysicsSpaceInteractionEnd));
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
			__physicsSpace.step(deltaTime, deltaTime, positionIterations);
		}
		
		override public function dispose():void
		{
			super.dispose();

			if(__gravity)
			{
				__gravity.dispose();
				__gravity = null;
			}
			
			if(__physicsSpace)
			{
				__physicsSpace.clear();
				__physicsSpace = null;
			}
		}
		
		
	}
}