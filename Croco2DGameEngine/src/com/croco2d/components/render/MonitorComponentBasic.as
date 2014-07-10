package com.croco2d.components.render
{
	import com.croco2d.core.GameObject;
	import com.fireflyLib.utils.MathUtil;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.textures.Texture;

	public class MonitorComponentBasic extends RenderComponent
	{
		public var antiAliasing:int = 0;
		public var backgroundColor:uint = 0;
		
		public var __renderSupport:RenderSupport;
		public var __renderBufferTexture:Texture;
		public var __renderImage:Image;

		public var __sourceRenderSupport:RenderSupport;
		public var __monitorDrawing:Boolean = false;
		
		public var __color:uint = 0xFFFFFF;//default;
		
		public var __backBufferWidth:int = 1;
		public var __backBufferHeight:int = 1;
		public var __backBufferSizeDirty:Boolean = true;
		
		public var watchTarget:GameObject;
		
		public function MonitorComponentBasic()
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
		
		public function get backBufferWidth():int
		{
			return __backBufferWidth;
		}

		public function get backBufferHeight():int
		{
			return __backBufferHeight;
		}
		
		public function setBackBufferSize(width:int, height:int):void
		{
			width = MathUtil.max(width, 1);
			height = MathUtil.max(height, 1);
			
			if(__backBufferWidth != width || __backBufferHeight != height)
			{
				__backBufferWidth = width;
				__backBufferHeight = height;
				
				__backBufferSizeDirty = true;
			}
		}
		
		override protected function onInit():void
		{
			__renderSupport = new RenderSupport();
		}
		
		protected function drawWatchTarget():void
		{
			__renderSupport.nextFrame();
			__renderSupport.setRenderTarget(__renderBufferTexture, antiAliasing);
			__renderSupport.clear(backgroundColor, antiAliasing);

			//draw part.
			if(watchTarget && watchTarget.__alive && watchTarget.visible)
			{
				__monitorDrawing = true;
				watchTarget.draw(__renderSupport, 1.0);
				__monitorDrawing = false;

				if(__sourceRenderSupport)
				{
					__sourceRenderSupport.raiseDrawCount(__renderSupport.drawCount);
				}
			}

			__renderSupport.finishQuadBatch();
			__renderSupport.setRenderTarget(null);
		}
		
		protected function updateBackBufferSize():void
		{
			configRenderBufferTexture();
			configRenderImage();
			configOrthographicProjection();
		}
		
		protected function configRenderBufferTexture():void
		{
			if(__renderBufferTexture)
			{
				__renderBufferTexture.dispose();
				__renderBufferTexture.root.onRestore = null;
				__renderBufferTexture = null;
			}
			
			//default size.
			__renderBufferTexture = Texture.empty(__backBufferWidth, __backBufferHeight, true, false, true);
			__renderBufferTexture.root.onRestore = __renderBufferTexture.root.clear;
		}
		
		protected function configRenderImage():void
		{
			if(__renderImage)
			{
				__renderImage.dispose();
				__renderImage = null;
			}
			
			__renderImage = new Image(__renderBufferTexture);
			if(__color != 0xffffff)
			{
				__renderImage.color = __color;
			}
			__renderImage.myData.owner = this;
		}
		
		protected function configOrthographicProjection():void
		{
			__renderSupport.setOrthographicProjection(0, 0, __backBufferWidth, __backBufferHeight);
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(__backBufferSizeDirty)
			{
				updateBackBufferSize();
				__backBufferSizeDirty = false;
			}
			
			//skip self draw.
			if(!__monitorDrawing)
			{
				__sourceRenderSupport = support;
				__renderImage.render(support, parentAlpha);
			}
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
		}
	}
}