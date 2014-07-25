package com.croco2d.components.physics
{
    import nape.constraint.Constraint;
    import nape.constraint.MotorJoint;
    import nape.phys.Body;

    public class MotorJointComponent extends JointComponent
	{
        public var __linkedRigidbody:RigidbodyComponent;

        public var __rate:Number = 0.0;//default
        public var __ratio:Number = 1.0;//default

        public function MotorJointComponent()
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
                    MotorJoint(__joint).body2 = __linkedRigidbody ? __linkedRigidbody.__rigidbody : null;
                }
            }
        }

        public function get rate():Number
        {
            return __joint ? MotorJoint(__joint).rate : __rate;
        }

        public function set rate(value:Number):void
        {
            __rate = value;

            MotorJoint(__joint).rate = value;
        }

        public function get ratio():Number
        {
            return __joint ? MotorJoint(__joint).ratio : __ratio;
        }

        public function set ratio(value:Number):void
        {
            __ratio = value;

            MotorJoint(__joint).ratio = value;
        }

        override protected function createJoint():Constraint
        {
            var ownerNativeRigibody:Body = rigidbody ? rigidbody.__rigidbody : null;
            var linkedNativeRigibody:Body = __linkedRigidbody ? __linkedRigidbody.__rigidbody : null;

            __joint = new MotorJoint(ownerNativeRigibody, linkedNativeRigibody, __rate, __ratio);
        }
	}
}