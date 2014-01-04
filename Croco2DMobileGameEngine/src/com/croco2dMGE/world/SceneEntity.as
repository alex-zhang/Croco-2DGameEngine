package com.croco2dMGE.world
{
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.filters.FragmentFilter;
	
	public class SceneEntity extends SceneObject
	{
		public var touchAble:Boolean = false;
		public var display:DisplayObject;
		public var isValidDisplay:Boolean = false;
		
		public function SceneEntity()
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
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			isValidDisplay = checkIsNeedDrawdisplay();
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			super.draw(support, parentAlpha);
			
			if(isValidDisplay)
			{
				drawDisplay();

				presentDisplay(support, parentAlpha);
			}
		}
		
		protected function checkIsNeedDrawdisplay():Boolean
		{
			return display && display.hasVisibleArea && isOverlapCamera();
		}
		
		protected function drawDisplay():void
		{
			display.x = int(screenX);
			display.y = int(screenY);
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
	}
}