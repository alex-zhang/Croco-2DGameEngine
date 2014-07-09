package com.croco2d.components.render
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.core.GameObject;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.textures.Texture;

	public class MonitorComponent extends RenderComponent
	{
		public var antiAliasing:int = 0;
		public var backgroundColor:uint = 0;
		
		public var __renderSupport:RenderSupport;
		public var __renderBufferTexture:Texture;
		public var __renderImage:Image;

		public var __sourceRenderSupport:RenderSupport;
		public var __monitorDrawing:Boolean = false;
		
		public var __color:uint = 0xFFFFFF;//default;
		
		public var watchTarget:GameObject;
		
		public function MonitorComponent()
		{
			super();
		}
		
		public function get color():uint
		{
			return __color;
		}
		
		public function set color(value:uint):void
		{
			if(__color != value)
			{
				__color = value;

				if(__renderImage)
				{
					__renderImage.color = __color;
				}
			}
		}
		
		override protected function onInit():void
		{
			__renderBufferTexture = Texture.empty(500, 500, true, false, true);
			__renderBufferTexture.root.onRestore = __renderBufferTexture.root.clear;
			
			__renderSupport = new RenderSupport();
			__renderSupport.setOrthographicProjection(0, 0, __renderBufferTexture.width, __renderBufferTexture.height);

			__renderImage = new Image(__renderBufferTexture);
			if(__color != 0xffffff)
			{
				__renderImage.color = __color;
			}
			
			CrocoEngine.instance.addEventListener(CrocoEngine.EVENT_AFTER_DRAW, globalAfterDrawHandler);
		}
		
		protected function globalAfterDrawHandler(eventData:Object = null):void
		{
			__renderSupport.nextFrame();
			__renderSupport.setRenderTarget(__renderBufferTexture, antiAliasing);
			
			__renderSupport.clear(backgroundColor, antiAliasing);
			
			__monitorDrawing = true;
			if(watchTarget && watchTarget.__alive && watchTarget.visible)
			{
				watchTarget.draw(__renderSupport, 1.0);
				__sourceRenderSupport.raiseDrawCount(__renderSupport.drawCount);
			}
			__monitorDrawing = false;
			
			__renderSupport.finishQuadBatch();
			__renderSupport.setRenderTarget(null);
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(__monitorDrawing) return;//skip self draw.
			
			__sourceRenderSupport = support;
			
			__renderImage.render(support, parentAlpha);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__renderSupport)
			{
				__renderSupport.dispose();
				__renderSupport = null;
			}
			
			__sourceRenderSupport = null;
			
			if(__renderBufferTexture)
			{
				__renderBufferTexture.dispose();
				__renderBufferTexture = null;
			}
			
			if(__renderImage)
			{
				__renderImage.dispose();
				__renderImage = null;
			}
			
			watchTarget = null;
			
			CrocoEngine.instance.removeEventListener(CrocoEngine.EVENT_AFTER_DRAW, globalAfterDrawHandler);
		}
	}
}