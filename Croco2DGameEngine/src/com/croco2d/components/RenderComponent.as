package com.croco2d.components
{
	import com.croco2d.core.CrocoObject;
	
	import flash.geom.Matrix;
	
	import starling.core.RenderSupport;

	public class RenderComponent extends CrocoObject
	{
		public var worldToLocalMatrix:Matrix;
		public var localToWorldMatrix:Matrix;
		
		public var visible:Boolean = true;
		
		public var alpha:Number = 1.0;
		
		public var touchable:Boolean;
		public var blendMode:String;

		public function RenderComponent()
		{
			super();
		}
		
		public function draw(support:RenderSupport, parentAlpha:Number):void
		{
		}
	}
}