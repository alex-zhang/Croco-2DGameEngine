package com.croco2d.components.physics
{
	import com.croco2d.core.GameObject;
	import com.croco2d.core.CrocoObject;

	public class JointComponent extends CrocoObject
	{
		public function JointComponent()
		{
			super();
			
//			name = CrocoGameObject.PROP_JOINT;
			tickable = false;
		}
	}
}