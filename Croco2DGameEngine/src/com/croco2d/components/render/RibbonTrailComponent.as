package com.croco2d.components.render
{
	import com.llamaDebugger.Logger;
	
	import flash.geom.Matrix;
	
	import starling.core.RenderSupport;
	import starling.extensions.RibbonSegment;
	import starling.extensions.RibbonTrail;
	import starling.textures.Texture;

	public class RibbonTrailComponent extends RenderComponent
	{
		public var initTrailSegmentsCount:int = 10;
		public var isAutoPlay:Boolean = true;
		public var isUseWorldSpace:Boolean = true;//default is true.
		
		public var __texture:Texture;
		public var __ribbonTrail:RibbonTrail;
		
		public function RibbonTrailComponent()
		{
			super();
		}
		
		public function get texture():Texture { return __texture; }
		public function set texture(value:Texture):void
		{
			if(__texture != value)
			{
				__texture = value;
				
				if(!__texture) throw new Error("RibbonTrailComponent texture is null!");
				
				if(__ribbonTrail)
				{
					__ribbonTrail.texture = __texture;
				}
			}
		}
		
		public function get followingEnable():Boolean { return __ribbonTrail ? __ribbonTrail.followingEnable : false; }
		public function set followingEnable(value:Boolean):void 
		{ 
			if(__ribbonTrail) 
			{
				__ribbonTrail.followingEnable = value;
			}
		}
		
		public function get isPlaying():Boolean { return __ribbonTrail ? __ribbonTrail.isPlaying : false; }
		public function set isPlaying(value:Boolean):void 
		{
			if(__ribbonTrail) 
			{
				__ribbonTrail.isPlaying = value;
			}
		}
		
		public function get movingRatio():Number { return __ribbonTrail ? __ribbonTrail.movingRatio : 0; }
		public function set movingRatio(value:Number):void 
		{ 
			if(__ribbonTrail) 
			{
				__ribbonTrail.movingRatio = value;
			}
		}
		
		public function get alphaRatio():Number { return __ribbonTrail ? __ribbonTrail.alphaRatio : 0; }
		public function set alphaRatio(value:Number):void 
		{
			if(__ribbonTrail) 
			{
				__ribbonTrail.alphaRatio = value;
			}
		}
		
		public function get repeat():Boolean { return __ribbonTrail ? __ribbonTrail.repeat : false; }
		public function set repeat(value:Boolean):void 
		{ 
			if(__ribbonTrail) 
			{
				__ribbonTrail.repeat = value;
			}
		}
		
		public function getRibbonSegment(index:int):RibbonSegment
		{
			if(__ribbonTrail) 
			{
				return getRibbonSegment(index);
			}
			
			return null;
		}
		
		/**
		 *  u can use this method to controll all the Segments or parts of.
		 * 	u also can pass null here to stop the effect.
		 * 	when the line's length is short than the current's, left Segments will performance tween effect.
		 *  or u also cann pass none-continues segments in the following-line, it's can makes lot's of effects. 
		 * 
		 * @param followingRibbonSegmentLine
		 * 
		 */		
		public function followTrailSegmentsLine(followingRibbonSegmentLine:Vector.<RibbonSegment>):void
		{
			if(__ribbonTrail) 
			{
				__ribbonTrail.followTrailSegmentsLine(followingRibbonSegmentLine);
			}
		}
		
		//because of segments have the invalid pos so syc here.
		public function resetAllTo(x0:Number, y0:Number, x1:Number, y1:Number,
								   alpha:Number = 1.0):void
		{
			if(__ribbonTrail) 
			{
				__ribbonTrail.resetAllTo(x0, y0, x1, y1, alpha);
			}
		}
		
		override protected function onInit():void
		{
			if(!__texture) 
			{
				Logger.warn("RibbonTrailComponent's texture is null, here will give a default texture!");
				__texture = Texture.fromColor(50, 50, 0xFF0000);
			}

			__ribbonTrail = new RibbonTrail(__texture, initTrailSegmentsCount);
			
			if(isAutoPlay)
			{
				this.isPlaying = true;
			}
		}
		
		override public function tick(deltaTime:Number):void
		{
			__ribbonTrail.advanceTime(deltaTime);
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(isUseWorldSpace)
			{
				const modelViewMatrix:Matrix = support.modelViewMatrix;
				
				const lastModelViewMatrixTX:Number = modelViewMatrix.tx;
				const lastModelViewMatrixTY:Number = modelViewMatrix.ty;
				
				modelViewMatrix.tx = 0;
				modelViewMatrix.ty = 0;
			}
			
			__ribbonTrail.render(support, parentAlpha);
			
			if(isUseWorldSpace)
			{
				modelViewMatrix.tx = lastModelViewMatrixTX;
				modelViewMatrix.ty = lastModelViewMatrixTY;
			}
		}
	}
}