package com.croco2d.utils
{
	import flash.geom.Matrix;

	public class CrocoTransform
	{
		private var mMatrix:Matrix = new Matrix();
		
		private var mTransformDirty:Boolean = false; 
		
		private var mX:Number = 0.0;
		private var mY:Number = 0.0;
		
		private var mScaleX:Number = 1.0;
		private var mScaleY:Number = 1.0;
		
		private var mRotation:Number = 0.0;
		
		public function CrocoTransform()
		{
			super();
		}
		
		public function get matrix():Matrix
		{
			if(mTransformDirty)
			{
				if(mRotation == 0)
				{
					mMatrix.setTo(mScaleX, 0.0, 0.0, mScaleY, mX, mY);
				}
				else
				{
					const cos:Number = Math.cos(mRotation);
					const sin:Number = Math.sin(mRotation);
					
					mMatrix.setTo(mScaleX *  cos, mScaleX *  sin, mScaleY * -sin, mScaleY *  cos, mX, mY);					
				}
			}
				
			return mMatrix;
		}
	
		public function get x():Number
		{
			return mX;
		}
		
		public function set x(value:Number):void
		{
			if(mX != value)
			{
				mX = value;
				
				mTransformDirty = true;
			}
		}
		
		public function get y():Number
		{
			return mY;
		}
		
		public function set y(value:Number):void
		{
			if(mY != value)
			{
				mY = value;
				
				mTransformDirty = true;
			}
		}
		
		public function setPosition(x:Number, y:Number):void
		{
			if(mX != x || mY != y)
			{
				mX = x;
				mY = y;
			}
		}
		
		public function translateX(deltaX:Number):void
		{
			if(deltaX == 0) return;
			
			mX += deltaX;
			
			mTransformDirty = true;
		}
		
		public function translateY(deltaY:Number):void
		{
			if(deltaY == 0) return;
			
			mY += deltaY;
			
			mTransformDirty = true;
		}
		
		public function translatePosition(deltaX:Number, deltaY:Number):void
		{
			if(deltaX != 0)
			{
				mX += deltaX;
				
				mTransformDirty = true;
			}
			
			if(deltaY != 0)
			{
				mY += deltaY;
				
				mTransformDirty = true;	
			}
		}
		
		public function get scaleX():Number
		{
			return mScaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			if(mScaleX != value)
			{
				mScaleX = value;
				
				mTransformDirty = true;
			}
		}
		
		public function get scaleY():Number
		{
			return mScaleY;
		}
		
		public function set scaleY(value:Number):void
		{
			if(mScaleY != value)
			{
				mScaleY = value;
				
				mTransformDirty = true;
			}
		}
		
		public function scale(value:Number):void
		{
			if(mScaleX != value)
			{
				mScaleX = value;
				
				mTransformDirty = true;
			}

			if(mScaleY != value)
			{
				mScaleY = value;
				
				mTransformDirty = true;
			}
		}
		
		public function get rotation():Number
		{
			return mRotation;
		}
		
		public function set rotation(value:Number):void
		{
			if(mRotation != value)
			{
				mRotation = value;
				
				mTransformDirty = true;
			}
		}
	}
}