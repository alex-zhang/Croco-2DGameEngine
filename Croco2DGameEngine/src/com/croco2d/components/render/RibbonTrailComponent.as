package com.croco2d.components.render
{
	import com.llamaDebugger.Logger;
	
	import starling.core.RenderSupport;
	import starling.extensions.RibbonTrail;
	import starling.textures.Texture;

	public class RibbonTrailComponent extends RenderComponent
	{
		public var texture:Texture;
		
		public var __ribbonTrail:RibbonTrail;
		
		public function RibbonTrailComponent()
		{
			super();
		}
		
		override protected function onInit():void
		{
			if(!texture)
			{
				Logger.error("RibbonTrailComponent texture is null!");
				return;
			}

			__ribbonTrail = new RibbonTrail(texture);
		}
		
		override public function tick(deltaTime:Number):void
		{
			__ribbonTrail.advanceTime(deltaTime);
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			__ribbonTrail.render(support, parentAlpha);
		}
	}
}