package com.croco2d.components.physics
{
	import com.croco2d.core.CrocoGameObject;
	import com.croco2d.core.CrocoObject;
	
	import nape.phys.Material;
	import nape.shape.Shape;

	public class ColliderComponent extends CrocoObject
	{
		//refer
		public var __rigidbodyComponent:RigidbodyComponent;
		
		public var __shape:Shape;
		public var __material:Material;

		public function ColliderComponent()
		{
			super();
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
			__rigidbodyComponent = CrocoGameObject(owner).rigidbody;
			
			__shape = createShape();

			if(__rigidbodyComponent)
			{
				__shape.body = __rigidbodyComponent.__rigidbody;
			}
		}
		
		protected function createShape():Shape
		{
			return null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			__rigidbodyComponent = null;
			__shape = null;
		}
	}
}