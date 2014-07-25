package com.croco2d.components.physics
{
    import nape.constraint.AngleJoint;
    import nape.constraint.Constraint;
    import nape.constraint.DistanceJoint;
    import nape.geom.Vec2;
    import nape.phys.Body;

    public class DistanceJointComponent extends JointComponent
	{
        public var __rigidbody1:RigidbodyComponent;
        public var __rigidbody2:RigidbodyComponent;

        public var __jointMin:Number = Number.NEGATIVE_INFINITY;
        public var __jointMax:Number = Number.POSITIVE_INFINITY;

        public var __anchor1:Vec2;
        public var __anchor2:Vec2;

        public function DistanceJointComponent()
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
                    DistanceJoint(__joint).body1 = __rigidbody1 ? __rigidbody1.__rigidbody : null;
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
                    DistanceJoint(__joint).body2 = __rigidbody2 ? __rigidbody2.__rigidbody : null;
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
                    DistanceJoint(__joint).jointMin = __jointMax;
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
                    DistanceJoint(__joint).jointMax = __jointMax;
                }
            }
        }

        public function get anchor1():Vec2
        {
            return __joint ? DistanceJoint(__joint).anchor1 : __anchor1;
        }

        public function set anchor1(value:Vec2):void
        {
            __anchor1 = value;

            if(__joint)
            {
                DistanceJoint(__joint).anchor1 = value;
            }
        }

        public function get anchor2():Vec2
        {
            return __joint ? DistanceJoint(__joint).anchor2 : __anchor2;
        }

        public function set anchor2(value:Vec2):void
        {
            __anchor2 = value;

            if(__joint)
            {
                DistanceJoint(__joint).anchor2 = value;
            }
        }

        override protected function createJoint():Constraint
        {
            __rigidbody1 = gameObject.rigidbody;

            __joint = new DistanceJoint(__rigidbody1 ? __rigidbody1.__rigidbody : null,
                    __rigidbody2 ? __rigidbody2.__rigidbody : null,
                    __anchor1, __anchor2, __jointMin, __jointMax);
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