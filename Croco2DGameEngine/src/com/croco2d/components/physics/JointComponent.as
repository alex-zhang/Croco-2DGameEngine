package com.croco2d.components.physics
{
    import com.croco2d.components.GameObjectComponent;
    import com.croco2d.core.GameObject;

    import nape.callbacks.CbTypeList;

    import nape.constraint.Constraint;
    import nape.geom.Vec3;

    public class JointComponent extends GameObjectComponent
    {
        public var __joint:Constraint;

        public function JointComponent()
        {
            super();

            name = GameObject.PROP_JOINT;
        }

        public function get jointActive():Boolean
        {
            return __joint ? __joint.active : true;//default true
        }

        public function set jointActive(value:Boolean):void
        {
            if(__joint)
            {
                __joint.active = value;
            }
        }

        public function get breakUnderError():Boolean
        {
            return __joint ? __joint.breakUnderError : false;//default false
        }

        public function set breakUnderError(value:Boolean):void
        {
            if(__joint)
            {
                __joint.breakUnderError = value;
            }
        }

        public function get cbTypes():CbTypeList
        {
            if(__joint)
            {
                return __joint.cbTypes;
            }
        }

        public function get damping():Number
        {
            return __joint ? __joint.damping : 1;//default 1
        }

        public function set damping(value:Number):void
        {
            if(__joint)
            {
                __joint.damping = value;
            }
        }

        public function get frequency():Number
        {
            return __joint ? __joint.frequency : 10;//default 10
        }

        public function set frequency(value:Number):void
        {
            if(__joint)
            {
                __joint.frequency = value;
            }
        }

        public function get	ignore():Boolean
        {
            return __joint ? __joint.ignore : false;//default false
        }

        public function set ignore(value:Boolean):void
        {
            if(__joint)
            {
                __joint.ignore = value;
            }
        }

        public function get	isSleeping():Boolean
        {
            return __joint ? __joint.isSleeping : false;
        }

        public function get	maxError ():Number
        {
            return __joint ? __joint.maxError : Number.POSITIVE_INFINITY;//default is POSITIVE_INFINITY
        }

        public function get	maxForce():Number
        {
            return __joint ? __joint.maxForce : Number.POSITIVE_INFINITY;//default is POSITIVE_INFINITY
        }

        public function get	removeOnBreak():Boolean
        {
            return __joint ? __joint.removeOnBreak : true;//default is true
        }

        public function get	stiff():Boolean
        {
            return __joint ? __joint.stiff : true;//default is true
        }

        public function set stiff(value:Boolean):void
        {
            if(__joint)
            {
                __joint.stiff = value;
            }
        }

        public function bodyImpulse(rigidbody:RigidbodyComponent):Vec3
        {
            if(__joint)
            {
                return __joint.bodyImpulse(rigidbody.__rigidbody)
            }

            return null;
        }

        override protected function onInit():void
        {
            __joint = createJoint();
        }

        protected function createJoint():Constraint
        {
            return null;
        }

        override public function tick(deltaTime:Number):void
        {
            __joint.debugDraw = debug;
        }
    }
}