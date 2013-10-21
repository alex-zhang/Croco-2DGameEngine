package com.croco2dMGE.graphics
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.core.RenderSupport;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.VertexData;

	public class CrocoImage extends Quad
	{
		private var mImageWidth:Number = 0.0;
		private var mImageHeight:Number = 0.0;
		
		private var mTexture:Texture;
		private var mSmoothing:String;
		
		private var mVertexDataCache:VertexData;
		private var mVertexDataCacheInvalid:Boolean;
		
		public function CrocoImage(width:Number, height:Number)
		{
			super(width, height);

			mImageWidth = width;
			mImageHeight = height;
			
			mVertexData.setTexCoords(0, 0.0, 0.0);
			mVertexData.setTexCoords(1, 1.0, 0.0);
			mVertexData.setTexCoords(2, 0.0, 1.0);
			mVertexData.setTexCoords(3, 1.0, 1.0);
			
			mSmoothing = TextureSmoothing.BILINEAR;
			mVertexDataCache = new VertexData(4);
			mVertexDataCacheInvalid = true;
		}
		
		/** The texture that is displayed on the quad. */
		public function get texture():Texture { return mTexture; }
		public function set texture(value:Texture):void 
		{ 
			if (mTexture != value)
			{
				mTexture = value;
				
				if(mTexture)
				{
					mVertexData.setPremultipliedAlpha(mTexture.premultipliedAlpha);
					mVertexDataCache.setPremultipliedAlpha(mTexture.premultipliedAlpha, false);
					onVertexDataChanged();
				}
			}
		}
		
		/** The smoothing filter that is used for the texture. 
		 *   @default bilinear
		 *   @see starling.textures.TextureSmoothing */ 
		public function get smoothing():String { return mSmoothing; }
		public function set smoothing(value:String):void 
		{
			if (TextureSmoothing.isValid(value))
				mSmoothing = value;
			else
				throw new ArgumentError("Invalid smoothing mode: " + value);
		}
		
		/** @inheritDoc */
		protected override function onVertexDataChanged():void
		{
			mVertexDataCacheInvalid = true;
		}
		
		/** Sets the texture coordinates of a vertex. Coordinates are in the range [0, 1]. */
		public function setTexCoords(vertexID:int, coords:Point):void
		{
			mVertexData.setTexCoords(vertexID, coords.x, coords.y);
			onVertexDataChanged();
		}
		
		/** Sets the texture coordinates of a vertex. Coordinates are in the range [0, 1]. */
		public function setTexCoordsTo(vertexID:int, u:Number, v:Number):void
		{
			mVertexData.setTexCoords(vertexID, u, v);
			onVertexDataChanged();
		}
		
		/** Gets the texture coordinates of a vertex. Coordinates are in the range [0, 1]. 
		 *  If you pass a 'resultPoint', the result will be stored in this point instead of 
		 *  creating a new object.*/
		public function getTexCoords(vertexID:int, resultPoint:Point=null):Point
		{
			if (resultPoint == null) resultPoint = new Point();
			mVertexData.getTexCoords(vertexID, resultPoint);
			return resultPoint;
		}
		
		/** Copies the raw vertex data to a VertexData instance.
		 *  The texture coordinates are already in the format required for rendering. */ 
		public override function copyVertexDataTo(targetData:VertexData, targetVertexID:int=0):void
		{
			copyVertexDataTransformedTo(targetData, targetVertexID, null);
		}
		
		/** Transforms the vertex positions of the raw vertex data by a certain matrix
		 *  and copies the result to another VertexData instance.
		 *  The texture coordinates are already in the format required for rendering. */
		public override function copyVertexDataTransformedTo(targetData:VertexData,
															 targetVertexID:int=0,
															 matrix:Matrix=null):void
		{
			if (mVertexDataCacheInvalid)
			{
				mVertexDataCacheInvalid = false;
				mVertexData.copyTo(mVertexDataCache);
				mTexture.adjustVertexData(mVertexDataCache, 0, 4);
			}
			
			mVertexDataCache.copyTransformedTo(targetData, targetVertexID, matrix, 0, 4);
		}
		
		/** @inheritDoc */
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			if(mTexture)
			{
				support.batchQuad(this, parentAlpha, mTexture, mSmoothing);
			}
		}
	}
}