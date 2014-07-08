package com.croco2d.components.physics
{
	import nape.shape.Circle;
	import nape.shape.Shape;

	public class CircleColliderComponent extends ColliderComponent
	{
		public var __radius:Number = 0.0;
		public var __circleShape:Circle;
		
		public function get radius():Number
		{
			return __radius;
		}
		
		public function set radius(value:Number):void
		{
			if(__radius != value)
			{
				__radius = value;
				
				if(__circleShape)
				{
					__circleShape.radius = __radius;
				}
			}
		}
		
		public function CircleColliderComponent()
		{
			super();
		}
		
		override protected function createShape():Shape
		{
			__circleShape = new Circle(__radius);
			return __circleShape;
		}
	}
}