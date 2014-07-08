package com.croco2d.components.physics
{
	import nape.shape.Polygon;
	import nape.shape.Shape;

	public class PolygonColliderComponent extends ColliderComponent
	{
		public var __polygonShape:Polygon;
		
		public function PolygonColliderComponent()
		{
			super();
		}
		
		override protected function createShape():Shape
		{
			__polygonShape = new Polygon(Polygon.rect(0, 0, 0, 0));
			return __polygonShape;
		}
	}
}