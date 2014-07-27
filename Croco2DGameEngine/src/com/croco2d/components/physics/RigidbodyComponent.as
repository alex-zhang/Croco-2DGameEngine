package com.croco2d.components.physics
{
	import com.croco2d.components.GameObjectComponent;
	import com.croco2d.components.TransformComponent;
	import com.croco2d.core.GameObject;
	
	import nape.callbacks.InteractionCallback;
	import nape.constraint.ConstraintList;
	import nape.dynamics.ArbiterList;
	import nape.geom.AABB;
	import nape.geom.Vec2;
	import nape.geom.Vec3;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.GravMassMode;
	import nape.phys.InertiaMode;
	import nape.phys.MassMode;
	import nape.shape.Shape;
	import nape.shape.ShapeList;

    public class RigidbodyComponent extends GameObjectComponent
	{
        public static const EVENT_BEGIN_CONTACT:String = "beginContact";
        public static const EVENT_END_CONTACT:String = "endContact";

		public var beginContactCallEnabled:Boolean = false;
		public var endContactCallEnabled:Boolean = false;

        public var __onBeginContactCallback:Function = onBeginContact;
        public var __onEndContactCallback:Function = onEndContact;
		
		public var __rigidbody:Body;
		public var __bodyType:BodyType = BodyType.DYNAMIC;//default
		public var __shape:Shape;
		public var __physicsSpaceComponent:PhysicsSpaceComponent;
		
		public var __allowMovement:Boolean = true;
		public var __allowRotation:Boolean = true;
		public var __angularVel:Number = 0.0;
		public var __disableCCD:Boolean = false;
		
		public var __position:Vec2;
		
		public var __transform:TransformComponent;
		
		public function RigidbodyComponent()
		{
			super();
			
			name = GameObject.PROP_RIGID_BODY;
		}
		
		public function get shape():Shape
		{
			return __shape;
		}
		
		public function set shape(value:Shape):void
		{
			if(__shape != value)
			{
				if(__shape)
				{
					__shape.body = null;
				}

				__shape = value;
				
				if(__shape)
				{
					__shape.body = __rigidbody;
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
				
				if(__rigidbody)
				{
					__rigidbody.space = __physicsSpaceComponent ? __physicsSpaceComponent.__physicsSpace : null;
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
				
				if(__rigidbody)
				{
					__rigidbody.allowMovement = __allowMovement;
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
				
				if(__rigidbody)
				{
					__rigidbody.allowRotation = __allowRotation;
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

                if(__rigidbody)
                {
                    __rigidbody.angularVel = __angularVel;
                }
            }
        }

        public function get arbiters():ArbiterList
        {
            return __rigidbody ? __rigidbody.arbiters : null;
        }

        public function get bounds():AABB
        {
            return __rigidbody ? __rigidbody.bounds : null;
        }

        public function get constraintInertia():Number
        {
            return __rigidbody ? __rigidbody.constraintInertia : 0;
        }

        public function get constraintMass():Number
        {
            return __rigidbody ? __rigidbody.constraintMass : 0;
        }

        public function get constraintVelocity():Vec3
        {
            return __rigidbody ? __rigidbody.constraintVelocity : null;
        }

        public function get constraints():ConstraintList
        {
            return __rigidbody ? __rigidbody.constraints : null;
        }

		public function get disableCCD():Boolean
		{
			return __disableCCD;
		}
		
		public function set disableCCD(value:Boolean):void
		{
			if(__disableCCD != value)
			{
				__disableCCD = value;

				if(__rigidbody) __rigidbody.disableCCD = __disableCCD;
			}
		}

        public function get force():Vec2
        {
            return __rigidbody ? __rigidbody.force : null;
        }

        public function set force(value:Vec2):void
        {
            __rigidbody.force = value;
        }

        public function get gravMass():Number
        {
            return __rigidbody ? __rigidbody.gravMass : 0;
        }

        public function set gravMass(value:Number):void
        {
            if(__rigidbody)
            {
                __rigidbody.gravMass = value;
            }
        }

        public function get gravMassMode():GravMassMode
        {
            return __rigidbody ? __rigidbody.gravMassMode : GravMassMode.DEFAULT;
        }

        public function set gravMassMode(value:GravMassMode):void
        {
            if(__rigidbody)
            {
                __rigidbody.gravMassMode = value;
            }
        }

        public function get gravMassScale():Number
        {
            return __rigidbody ? __rigidbody.gravMassScale : 1.0;//default no scale.
        }

        public function set gravMassScale(value:Number):void
        {
            if(__rigidbody)
            {
                __rigidbody.gravMassScale = value;
            }
        }

        public function get inertia():Number
        {
            return __rigidbody ? __rigidbody.inertia : 0;
        }

        public function set inertia(value:Number):void
        {
            if(__rigidbody)
            {
                __rigidbody.inertia = value;
            }
        }

        public function get inertiaMode():InertiaMode
        {
            return __rigidbody ? __rigidbody.inertiaMode : InertiaMode.DEFAULT;
        }

        public function set inertiaMode(value:InertiaMode):void
        {
            if(__rigidbody)
            {
                __rigidbody.inertiaMode = value;
            }
        }

        public function get isBullet():Boolean
        {
            return __rigidbody ? __rigidbody.isBullet : false;
        }

        public function set isBullet(value:Boolean):void
        {
            if(__rigidbody)
            {
                __rigidbody.isBullet = value;
            }
        }

        public function get isSleeping():Boolean
        {
            return __rigidbody ? __rigidbody.isSleeping : false;
        }

        public function get kinAngVel():Number
        {
            return __rigidbody ? __rigidbody.kinAngVel : 0;
        }

        public function set kinAngVel(value:Number):void
        {
            if(__rigidbody)
            {
                __rigidbody.kinAngVel = value;
            }
        }

        public function get kinematicVel():Vec2
        {
            return __rigidbody ? __rigidbody.kinematicVel : null;
        }

        public function set kinematicVel(value:Vec2):void
        {
            if(__rigidbody)
            {
                __rigidbody.kinematicVel = value;
            }
        }

        public function get localCOM():Vec2
        {
            return __rigidbody ? __rigidbody.localCOM : null;
        }

        public function get mass():Number
        {
            return __rigidbody ? __rigidbody.mass : null;
        }

        public function set mass(value:Number):void
        {
            if(__rigidbody)
            {
                __rigidbody.mass = value;
            }
        }

        public function get massMode():MassMode
        {
            return __rigidbody ? __rigidbody.massMode : MassMode.DEFAULT;
        }

        public function set massMode(value:MassMode):void
        {
            if(__rigidbody)
            {
                __rigidbody.massMode = value;
            }
        }

        public function get position():Vec2
        {
            return __rigidbody ? __rigidbody.position : __position;
        }

        public function set position(value:Vec2):void
        {
			__position = value;
			
            if(__rigidbody)
            {
                __rigidbody.position = value;
            }
        }

        public function get rotation():Number
        {
            return __rigidbody ? __rigidbody.rotation : 0;
        }

        public function set rotation(value:Number):void
        {
            if(__rigidbody)
            {
                __rigidbody.rotation = value;
            }
        }

        public function get shapes():ShapeList
        {
            return __rigidbody ? __rigidbody.shapes : null;
        }

        public function get surfaceVel ():Vec2
        {
            return __rigidbody ? __rigidbody.surfaceVel : null;
        }

        public function set surfaceVel (value:Vec2):void
        {
            if(__rigidbody)
            {
                __rigidbody.surfaceVel = value;
            }
        }

        public function get torque():Number
        {
            return __rigidbody ? __rigidbody.torque : 0;
        }

        public function set torque (value:Number):void
        {
            if(__rigidbody)
            {
                __rigidbody.torque = value;
            }
        }

        public function get bodyType():BodyType
        {
            return __bodyType;
        }

        public function set bodyType(value:BodyType):void
        {
            if(__bodyType != value)
            {
                __bodyType = value;

                if(__rigidbody)
                {
                    __rigidbody.type = __bodyType;
                }
            }
        }

        public function get velocity():Vec2
        {
            return __rigidbody ? __rigidbody.velocity : null;
        }

        public function set velocity(value:Vec2):void
        {
            if(__rigidbody)
            {
                __rigidbody.velocity = value;
            }
        }

        public function get worldCOM():Vec2
        {
            return __rigidbody ? __rigidbody.worldCOM : null;
        }


        public function align():void
        {
            if(__rigidbody)
            {
                __rigidbody.align();
            }
        }

        public function applyAngularImpulse(impulse:Number, sleepable:Boolean = false):RigidbodyComponent
        {
            if(__rigidbody)
            {
                __rigidbody.applyAngularImpulse(impulse, sleepable);
            }

            return this;
        }

        public function applyImpulse(impulse:Vec2, pos:Vec2 = null, sleepable:Boolean = false):RigidbodyComponent
        {
            if(__rigidbody)
            {
                __rigidbody.applyImpulse(impulse, pos, sleepable);
            }
			
			return this;
        }

        public function buoyancyImpulse(rigidbodyComponent:RigidbodyComponent = null):Vec3
        {
            if(__rigidbody)
            {
                if(!rigidbodyComponent) rigidbodyComponent = this;
                return __rigidbody.buoyancyImpulse(rigidbodyComponent.__rigidbody);
            }

            return null;
        }

        override protected function onInit():void
		{
			__transform = transform;
			
			__rigidbody = new Body(__bodyType, __position);
			if(__shape) __shape.body = __rigidbody;
			__rigidbody.allowMovement = __allowMovement;
			__rigidbody.allowRotation = __allowRotation;
			__rigidbody.angularVel = __angularVel;
//			__rigidbody.compound = __compound;
			__rigidbody.disableCCD = __disableCCD;
			__rigidbody.space = __physicsSpaceComponent ? __physicsSpaceComponent.__physicsSpace : null;
			__rigidbody.userData.owner = this;//keep the ref.
		}

        protected function onBeginContact(interactionCallback:InteractionCallback):void
        {
            gameObject.dispatchEvent(EVENT_BEGIN_CONTACT, interactionCallback);
        }

        protected function onEndContact(interactionCallback:InteractionCallback):void
        {
            gameObject.dispatchEvent(EVENT_END_CONTACT, interactionCallback);
        }
		
		override public function tick(deltaTime:Number):void
		{
            __rigidbody.debugDraw = debug;
			__transform.setPosition(__rigidbody.position.x, __rigidbody.position.y);
			__transform.rotation = __rigidbody.rotation;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__rigidbody)
			{
				__rigidbody.space = null;
				__rigidbody = null;
			}
		}
	}
}