package com.croco2d.components
{
	import com.croco2d.core.CrocoGameObject;
	import com.croco2d.core.CrocoObject;
	
	import flash.geom.Matrix;

	public class TransformComponent extends CrocoObject
	{
		public var __transformMatrix:Matrix = new Matrix();
		public var __transformMatrixDirty:Boolean = false; 

		public var __x:Number = 0.0;
		public var __y:Number = 0.0;

		public var __scaleX:Number = 1.0;
		public var __scaleY:Number = 1.0;

		public var __rotation:Number = 0.0;

		//record the cur ModelViewMatrix for later use.
		public var __lastModelViewMatrix:Matrix = new Matrix();

		public function TransformComponent()
		{
			super();
		}

		public function get transformMatrix():Matrix
		{
			if(__transformMatrixDirty)
			{
				if(__rotation == 0)
				{
					__transformMatrix.setTo(__scaleX, 0.0, 0.0, __scaleY, __x, __y);
				}
				else
				{
					const cos:Number = Math.cos(__rotation);
					const sin:Number = Math.sin(__rotation);
					
					__transformMatrix.setTo(__scaleX *  cos, __scaleX *  sin, __scaleY * -sin, __scaleY *  cos, __x, __y);					
				}
			}
				
			return __transformMatrix;
		}
		
		public function invalidateTransformMatrix():void
		{
			__transformMatrixDirty = true;
		}
		
		public function getWorldTransformMatrix(result:Matrix = null):Matrix
		{
			if(result) result.identity();
			else result = new Matrix();
			
			var gameObject:CrocoGameObject = owner as CrocoGameObject;
			while(gameObject)
			{
				result.concat(gameObject.transformComponent.transformMatrix);
				gameObject = gameObject.owner as CrocoGameObject;
			}

			return result;
		}
		
		public function reset():void
		{
			__x = 0;
			__y = 0;
			__scaleX = 1.0;
			__scaleY = 1.0;
			__rotation = 0;
			
			__transformMatrixDirty = true;
		}
	
		public function get x():Number
		{
			return __x;
		}
		
		public function set x(value:Number):void
		{
			if(__x != value)
			{
				__x = value;
				
				__transformMatrixDirty = true;
			}
		}
		
		public function get y():Number
		{
			return __y;
		}
		
		public function set y(value:Number):void
		{
			if(__y != value)
			{
				__y = value;
				
				__transformMatrixDirty = true;
			}
		}
		
		public function setPosition(x:Number, y:Number):void
		{
			if(__x != x || __y != y)
			{
				__x = x;
				__y = y;
				
				__transformMatrixDirty = true;
			}
		}
		
		public function translateX(deltaX:Number):void
		{
			if(deltaX == 0) return;
			
			__x += deltaX;
			
			__transformMatrixDirty = true;
		}
		
		public function translateY(deltaY:Number):void
		{
			if(deltaY == 0) return;
			
			__y += deltaY;
			
			__transformMatrixDirty = true;
		}
		
		public function translatePosition(deltaX:Number, deltaY:Number):void
		{
			if(deltaX != 0)
			{
				__x += deltaX;
				
				__transformMatrixDirty = true;
			}
			
			if(deltaY != 0)
			{
				__y += deltaY;
				
				__transformMatrixDirty = true;	
			}
		}
		
		public function get scaleX():Number
		{
			return __scaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			if(__scaleX != value)
			{
				__scaleX = value;
				
				__transformMatrixDirty = true;
			}
		}
		
		public function get scaleY():Number
		{
			return __scaleY;
		}
		
		public function set scaleY(value:Number):void
		{
			if(__scaleY != value)
			{
				__scaleY = value;
				
				__transformMatrixDirty = true;
			}
		}
		
		public function scale(value:Number):void
		{
			if(__scaleX != value)
			{
				__scaleX = value;
				
				__transformMatrixDirty = true;
			}

			if(__scaleY != value)
			{
				__scaleY = value;
				
				__transformMatrixDirty = true;
			}
		}

		public function get rotation():Number
		{
			return __rotation;
		}
		
		public function set rotation(value:Number):void
		{
			if(__rotation != value)
			{
				__rotation = value;
				
				__transformMatrixDirty = true;
			}
		}
	}
}