package com.croco2d.components.physics
{
	import nape.shape.Polygon;
	import nape.shape.Shape;

	public class RectColliderComponent extends ColliderComponent
	{
		public var __rectShape:Polygon;
		
		public function RectColliderComponent()
		{
			super();
		}
		
		override protected function createShape():Shape
		{
			__rectShape = new Polygon(Polygon.rect(0, 0, 50, 50));
			return __rectShape;
		}
	}
}