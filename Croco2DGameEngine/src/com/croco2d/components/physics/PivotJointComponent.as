package com.croco2d.components.physics
{
    import nape.constraint.Constraint;
    import nape.constraint.PivotJoint;
    import nape.geom.Vec2;
    import nape.phys.Body;

    public class PivotJointComponent extends JointComponent
	{
        public var __linkedRigidbody:RigidbodyComponent;

        public var __anchor:Vec2;
        public var __linkedAnchor:Vec2;

		public function PivotJointComponent()
		{
			super();
		}

        public function get linkedRigidbody():RigidbodyComponent
        {
            return __linkedRigidbody;
        }

        public function set linkedRigidbody(value:RigidbodyComponent):void
        {
            if(__linkedRigidbody != value)
            {
                __linkedRigidbody = value;

                if(__joint)
                {
                    PivotJoint(__joint).body2 = __linkedRigidbody ? __linkedRigidbody.__rigidbody : null;
                }
            }
        }

        public function get anchor():Vec2
        {
            return __joint ? PivotJoint(__joint).anchor1 : __anchor;
        }

        public function set anchor(value:Vec2):void
        {
            __anchor = value;

            if(__joint)
            {
                PivotJoint(__joint).anchor1 = value;
            }
        }

        public function get linkedAnchor():Vec2
        {
            return __joint ? PivotJoint(__joint).anchor2 : __linkedAnchor;
        }

        public function set linkedAnchor(value:Vec2):void
        {
            __linkedAnchor = value;

            if(__joint)
            {
                PivotJoint(__joint).anchor2 = value;
            }
        }

        override protected function createJoint():Constraint
        {
            var ownerNativeRigibody:Body = rigidbody ? rigidbody.__rigidbody : null;
            var linkedNativeRigibody:Body = __linkedRigidbody ? __linkedRigidbody.__rigidbody : null;

            __joint = new PivotJoint(ownerNativeRigibody, linkedNativeRigibody, __anchor, __linkedAnchor);
        }
	}
}