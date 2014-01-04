package com.croco2dMGE.graphics
{
	import com.croco2dMGE.core.CrocoBasic;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.filters.FragmentFilter;

	public class GraphicObject extends CrocoBasic
	{
		public var display:DisplayObject;
		
		public var x:Number = 0.0;
		public var y:Number = 0.0;
		public var scaleX:Number = 1.0;
		public var scaleY:Number = 1.0;
		public var rotation:Number = 0.0;
		public var alpha:Number = 1.0;
		
		public var layerZIndex:int = 0;
		public var zFighting:Number = 0.0;
		
		public function GraphicObject()
		{
			super();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(display)
			{
				display.dispose();
				display = null;
			}
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			super.draw(support, parentAlpha);
			
		}
		
		//u can override here to iml your custom present
		protected function presentDisplay(support:RenderSupport, parentAlpha:Number):void
		{
			var blendMode:String = support.blendMode;
			
			var filter:FragmentFilter = display.filter;
			
			support.pushMatrix();
			support.transformMatrix(display);
			support.blendMode = display.blendMode;
			
			if (filter) filter.render(display, support, parentAlpha);
			else        display.render(support, parentAlpha);
			
			support.blendMode = blendMode;
			support.popMatrix();
		}
		
		protected function drawDisplay():void
		{
			display.x = x;
			display.y = y;
			display.alpha = alpha;
			display.scaleX = scaleX;
			display.scaleY = scaleY;
		}
		
		override public function onDeactive():void
		{
			super.onDeactive();
			
			zFighting = 0;
		}
	}
}