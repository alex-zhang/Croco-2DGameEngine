package com.croco2d.components.render
{
	import com.croco2d.core.CrocoGameObject;
	import com.croco2d.core.CrocoObject;
	
	import flash.geom.Point;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;

	public class RenderComponent extends CrocoObject
	{
		public function RenderComponent()
		{
			super();
			
			//default.
			this.name = CrocoGameObject.PROP_RENDER_COMPONENT;
		}
		
		public function draw(support:RenderSupport, parentAlpha:Number):void
		{
		}
		
		public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			return null;
		}
	}
}