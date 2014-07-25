package com.croco2d.components.physics
{
    import nape.constraint.Constraint;
    import nape.constraint.WeldJoint;
    import nape.geom.Vec2;
    import nape.phys.Body;

    public class WeldJointComponent extends JointComponent
	{
        public var __linkedRigidbody:RigidbodyComponent;

        public var __anchor:Vec2;
        public var __linkedAnchor:Vec2;

        public var __phase:Number = 0.0;//default.

		public function WeldJointComponent()
		{
			super();
		}

        public function get anchor():Vec2
        {
            return __joint ? WeldJoint(__joint).anchor1 : __anchor;
        }

        public function set anchor(value:Vec2):void
        {
            __anchor = value;

            if(__joint)
            {
                WeldJoint(__joint).anchor1 = value;
            }
        }

        public function get linkedAnchor():Vec2
        {
            return __joint ? WeldJoint(__joint).anchor2 : __linkedAnchor;
        }

        public function set linkedAnchor(value:Vec2):void
        {
            __linkedAnchor = value;

            if(__joint)
            {
                WeldJoint(__joint).anchor2 = value;
            }
        }

        public function get phase():Number
        {
            return __joint ? WeldJoint(__joint).phase : __phase;
        }

        public function set phase(value:Number):void
        {
            __phase = value;

            if(__joint)
            {
                WeldJoint(__joint).phase = value;
            }
        }

        override protected function createJoint():Constraint
        {
            var ownerNativeRigidbody:Body = rigidbody ? rigidbody.__rigidbody : null;
            var linkedNativeRigidbody:Body = __linkedRigidbody ? __linkedRigidbody.__rigidbody : null;

            __joint = new WeldJoint(ownerNativeRigidbody, linkedNativeRigidbody, __anchor, __linkedAnchor, __phase);
        }
	}
}