package com.croco2d.components.physics
{
    import nape.constraint.PulleyJoint;

    public class PulleyJointComponent extends JointComponent
	{
        public var __linkedRigidbody:RigidbodyComponent;
        public var __linkedRigidbody1:RigidbodyComponent;
        public var __linkedRigidbody2:RigidbodyComponent;

		public function PulleyJointComponent()
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
                    PulleyJoint(__joint).body2 = __linkedRigidbody ? __linkedRigidbody.__rigidbody : null;
                }
            }
        }

        public function get linkedRigidbody1():RigidbodyComponent
        {
            return __linkedRigidbody;
        }

        public function set linkedRigidbody1(value:RigidbodyComponent):void
        {
            if(__linkedRigidbody1 != value)
            {
                __linkedRigidbody1 = value;

                if(__joint)
                {
                    PulleyJoint(__joint).body3 = __linkedRigidbody1 ? __linkedRigidbody1.__rigidbody : null;
                }
            }
        }

        public function get linkedRigidbody2():RigidbodyComponent
        {
            return __linkedRigidbody2;
        }

        public function set linkedRigidbody2(value:RigidbodyComponent):void
        {
            if(__linkedRigidbody2 != value)
            {
                __linkedRigidbody2 = value;

                if(__joint)
                {
                    PulleyJoint(__joint).body4 = __linkedRigidbody2 ? __linkedRigidbody2.__rigidbody : null;
                }
            }
        }
	}
}