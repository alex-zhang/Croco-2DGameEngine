package com.croco2d.components.physics
{
	import com.croco2d.core.CrocoObject;
	
	import nape.dynamics.ArbiterList;
	import nape.geom.AABB;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;

	public class PhysicsBodyComponent extends CrocoObject
	{
		public var __physicsBody:Body;
		public var __bodyType:BodyType = BodyType.DYNAMIC;//default
		public var __physicsSpaceComponent:PhysicsSpaceComponent;
		
		//not set it to null.
		public var position:Vec2 = new Vec2();
		
		public var __allowMovement:Boolean = true;
		public var __allowRotation:Boolean = true;
		public var __angularVel:Number = 0.0; 
		
		public function get bodyType():BodyType
		{
			return __bodyType;
		}
		
		public function set bodyType(value:BodyType):void
		{
			if(__bodyType != value)
			{
				__bodyType = value;
				
				if(__physicsBody)
				{
					__physicsBody.type = __bodyType;
				}
			}
		}
		
		public function get physicsSpaceComponent():PhysicsSpaceComponent
		{
			return __physicsSpaceComponent;
		}
		
		public function set physicsSpaceComponent(value:PhysicsSpaceComponent):void
		{
			if(__physicsSpaceComponent != value)
			{
				__physicsSpaceComponent = value;
				
				if(__physicsBody)
				{
					__physicsBody.space = __physicsSpaceComponent.__physicsSpace;
				}
			}
		}
		
		public function get	allowMovement():Boolean
		{
			return __allowMovement;
		}
		
		public function set allowMovement(value:Boolean):void
		{
			if(__allowMovement != value)
			{
				__allowMovement = value;
				
				if(__physicsBody)
				{
					__physicsBody.allowMovement = __allowMovement;
				}
			}
		}
		
		public function get allowRotation():Boolean
		{
			return __allowRotation;
		}
		
		public function set allowRotation(value:Boolean):void
		{
			if(__allowRotation != value)
			{
				__allowRotation = value;
				
				if(__physicsBody)
				{
					__physicsBody.allowRotation = __allowRotation;
				}
			}
		}
		
		public function get angularVel():Number
		{
			return __angularVel;
		}
		
		public function set angularVel(value:Number):void
		{
			if(__angularVel != value)
			{
				__angularVel = value;
				
				if(__physicsBody)
				{
					__physicsBody.angularVel = __angularVel;
				}
			}
		}
		
		public function get arbiters():ArbiterList
		{
			return __physicsBody ? __physicsBody.arbiters : null;
		}
		
		public function get bounds():AABB
		{
			return __physicsBody ? __physicsBody.bounds : null;
		}

		public function PhysicsBodyComponent()
		{
			super();
		}
		
		override protected function onInit():void
		{
			__physicsBody = new Body(__bodyType, position);
			__physicsBody.allowMovement = __allowMovement;
			__physicsBody.allowRotation = __allowRotation;
			__physicsBody.angularVel = __angularVel;
			
			__physicsBody.space = __physicsSpaceComponent ? __physicsSpaceComponent.__physicsSpace : null;
		}
	}
}