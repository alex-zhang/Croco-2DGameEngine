package com.croco2d.components.physics
{
    import nape.constraint.AngleJoint;
    import nape.constraint.Constraint;
    import nape.phys.Body;

    public class AngleJointComponent extends JointComponent
    {
        public var __rigidbody1:RigidbodyComponent;
        public var __rigidbody2:RigidbodyComponent;

        public var __jointMin:Number = Number.NEGATIVE_INFINITY;
        public var __jointMax:Number = Number.POSITIVE_INFINITY;

        public var __ratio:Number = 1.0;

        public function AngleJointComponent()
        {
            super();
        }

        public function get rigidbody1():RigidbodyComponent
        {
            return __rigidbody1;
        }

        public function set rigidbody1(value:RigidbodyComponent):void
        {
            if(__rigidbody1 != value)
            {
                __rigidbody1 = value;

                if(__joint)
                {
                    AngleJoint(__joint).body1 = __rigidbody1 ? __rigidbody1.__rigidbody : null;
                }
            }
        }

        public function get rigidbody2():RigidbodyComponent
        {
            return __rigidbody1;
        }

        public function set rigidbody2(value:RigidbodyComponent):void
        {
            if(__rigidbody2 != value)
            {
                __rigidbody2 = value;

                if(__joint)
                {
                    AngleJoint(__joint).body2 = __rigidbody2 ? __rigidbody2.__rigidbody : null;
                }
            }
        }

        public function get jointMin():Number
        {
            return __jointMin;
        }

        public function set jointMin(value:Number):void
        {
            if(__jointMin != value)
            {
                __jointMin = value;

                if(__joint)
                {
                    AngleJoint(__joint).jointMin = __jointMax;
                }
            }
        }

        public function get jointMax():Number
        {
            return __jointMax;
        }

        public function set jointMax(value:Number):void
        {
            if(__jointMax != value)
            {
                __jointMax = value;

                if(__joint)
                {
                    AngleJoint(__joint).jointMax = __jointMax;
                }
            }
        }

        public function get ratio():Number
        {
            return __ratio;
        }

        public function set ratio(value:Number):void
        {
            if(__ratio != value)
            {
                __ratio = value;

                if(__joint)
                {
                    AngleJoint(__joint).ratio = __ratio;
                }
            }
        }

        override protected function createJoint():Constraint
        {
            __rigidbody1 = gameObject.rigidbody;

            __joint = new AngleJoint(__rigidbody1 ? __rigidbody1.__rigidbody : null,
                    __rigidbody2 ? __rigidbody2.__rigidbody : null,
                    __jointMin, __jointMax, __ratio);
        }

        override protected function onActive():void
        {
            __rigidbody1 = gameObject.rigidbody;

            AngleJoint(__joint).body1 = __rigidbody1 ? __rigidbody1.__rigidbody : null;
        }

        override protected function onDeactive():void
        {
            __rigidbody1 = null;
            AngleJoint(__joint).body1 = null;
        }
	}
}