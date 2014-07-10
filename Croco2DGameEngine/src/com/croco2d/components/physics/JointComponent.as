package com.croco2d.components.physics
{
	import com.croco2d.components.GameObjectComponent;

	public class JointComponent extends GameObjectComponent
	{
		public function JointComponent()
		{
			super();
			
//			name = CrocoGameObject.PROP_JOINT;
			tickable = false;
		}
	}
}