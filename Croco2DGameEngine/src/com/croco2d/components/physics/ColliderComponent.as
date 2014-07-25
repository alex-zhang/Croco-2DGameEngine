package com.croco2d.components.physics
{
	import com.croco2d.components.GameObjectComponent;
	import com.croco2d.core.GameObject;
	
	import nape.phys.Material;
	import nape.shape.Shape;

	public class ColliderComponent extends GameObjectComponent
	{
		public var __shape:Shape;
		public var __material:Material;

		public function ColliderComponent()
		{
			super();

			name = GameObject.PROP_COLLIDER;
			tickable = false;
		}
		
		public function get material():Material
		{
			return __material;
		}
		
		public function set material(value:Material):void
		{
			if(__material != value)
			{
				__material = value;
				
				if(__shape)
				{
					__shape.material = __material;
				}
			}
		}
		
		override protected function onInit():void
		{
			__shape = createShape();

			if(rigidbody)
			{
				__shape.body = rigidbody.__rigidbody;
			}
		}

        override protected function onActive():void
        {
            if(rigidbody)
            {
                __shape.body = rigidbody.__rigidbody;
            }
        }

        override protected function onDeactive():void
        {
            __shape.body = null;
        }

		protected function createShape():Shape
		{
			return null;
		}
		
		override public function dispose():void
		{
			super.dispose();

			__shape = null;
		}
	}
}