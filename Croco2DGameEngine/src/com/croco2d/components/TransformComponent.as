package com.croco2d.components
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.core.GameObject;
	import com.fireflyLib.utils.MathUtil;
	import com.llamaDebugger.Logger;
	
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import starling.utils.MatrixUtil;

    public class TransformComponent extends GameObjectComponent
	{
		public var moveAble:Boolean = true;
		public var zoomAble:Boolean = true;
		public var rotateAble:Boolean = true;
        public var sizeAble:Boolean = true;

		public var __transformMatrix:Matrix = new Matrix();
		public var __transformMatrixDirty:Boolean = false; 

		public var __x:Number = 0.0;
		public var __y:Number = 0.0;
		
		public var __pivotX:Number = 0.0;
		public var __pivotY:Number = 0.0;

		public var __scaleX:Number = 1.0;
		public var __scaleY:Number = 1.0;

		public var __rotation:Number = 0.0;

        public var __width:Number = 0.0;
        public var __height:Number = 0.0;

		//record the cur ModelViewMatrix for later use.
		public var __lastModelViewMatrix:Matrix = new Matrix();

		public function TransformComponent()
		{
			super();
		}
		
		public function identityMatrix():void
		{
			__x = 0.0;
			__y = 0.0;
			__pivotX = 0.0;
			__pivotY = 0.0;
			__scaleX = 1.0;
			__scaleY = 1.0;
			__rotation = 0.0;
			
			__transformMatrix.identity();
			__transformMatrixDirty = false;
		}
		
		public function get x():Number
		{
			return __x;
		}
		
		public function set x(value:Number):void
		{
			setPosition(value, __y);
		}
		
		public function translateX(deltaX:Number):void
		{
			if(deltaX == 0) return;
			
			setPosition(__x + deltaX, __y);
		}
		
		public function get y():Number
		{
			return __y;
		}
		
		public function set y(value:Number):void
		{
			setPosition(__x, value);
		}
		
		public function translateY(deltaY:Number):void
		{
			if(deltaY == 0) return;
			
			setPosition(__x, __y + deltaY);
		}
		
		public function translatePosition(deltaX:Number, deltaY:Number):void
		{
			if(deltaX == 0 && deltaY == 0) return;
			
			setPosition(__x + deltaX, __y + deltaY);
		}
		
		public function setPosition(x:Number, y:Number):void
		{
			if(!moveAble)
			{
				Logger.warn("TransformComponent moveable false!");
				return;
			}
			
			if(__x != x || __y != y)
			{
				__x = x;
				__y = y;
				
				__transformMatrixDirty = true;
			}
		}
		
		public function get pivotX():Number
		{
			return __pivotX;
		}
		
		public function set pivotX(value:Number):void
		{
			setPivotPosition(value, __pivotY);
		}
		
		public function get pivotY():Number
		{
			return __pivotY;
		}

		public function set pivotY(value:Number):void
		{
			setPivotPosition(__pivotX, value);
		}
		
		public function translatePivotX(deltaPivotX:Number):void
		{
			if(deltaPivotX == 0) return;
			
			setPivotPosition(__pivotX + deltaPivotX, __pivotY);
		}
		
		public function translatePivotY(deltaPivotY:Number):void
		{
			if(deltaPivotY == 0) return;
			
			setPivotPosition(__pivotX, __pivotY + deltaPivotY);
		}
		
		public function translatePivotPosition(deltaPivotX:Number, deltaPivotY:Number):void
		{
			if(deltaPivotX == 0 && deltaPivotY == 0) return;

			setPosition(__pivotX + deltaPivotX, __pivotY + deltaPivotY);
		}
		
		public function setPivotPosition(pivotX:Number, pivotY:Number):void
		{
            //PivotPosition is inner Position, not limited by moveAble.

			if(__pivotX != pivotX || __pivotY != pivotY)
			{
				__pivotX = pivotX;
				__pivotY = pivotY;

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
			setScaleXY(value, value);
		}

		public function setScaleXY(scaleX:Number, scaleY:Number):void
		{
			if(!zoomAble)
			{
				Logger.warn("TransformComponent zoomAble false!");
				return;
			}
			
			if(__scaleX != scaleX || __scaleY != scaleY)
			{
				__scaleX = scaleX;
				__scaleY = scaleY;
				
				__transformMatrixDirty = true;
			}
		}
		
		public function get rotation():Number
		{
			return __rotation;
		}
		
		public function set rotation(value:Number):void
		{
			setRotation(value);
		}
		
		public function rotate(angle:Number):void
		{
			setRotation(__rotation + angle);
		}
		
		public function setRotation(value:Number):void
		{
			if(!rotateAble)
			{
				Logger.warn("TransformComponent rotateAble false!");
				return;
			}
			
			value = MathUtil.clampRadian(value);
			
			if(__rotation != value)
			{
				__rotation = value;
				
				__transformMatrixDirty = true;
			}
		}

		public function get transformMatrix():Matrix
		{
			if(__transformMatrixDirty)
			{
				if(__rotation == 0)//opt for rotation = 0;
				{
					__transformMatrix.setTo(__scaleX, 0.0, 0.0, __scaleY, 
						__x - __pivotX * __scaleX, __y - __pivotY * __scaleY);
				}
				else
				{
					const cos:Number = Math.cos(__rotation);
					const sin:Number = Math.sin(__rotation);
					const a:Number   = __scaleX *  cos;
					const b:Number   = __scaleX *  sin;
					const c:Number   = __scaleY * -sin;
					const d:Number   = __scaleY *  cos;
					const tx:Number  = __x - __pivotX * a - __pivotY * c;
					const ty:Number  = __y - __pivotX * b - __pivotY * d;

					__transformMatrix.setTo(a, b, c, d, tx, ty);
				}
				
				__transformMatrixDirty = false;
			}
				
			return __transformMatrix;
		}
		
		public final function invalidateTransformMatrix():void
		{
			__transformMatrixDirty = true;
		}
		
		public function getWorldMatrix(result:Matrix = null):Matrix
		{
			if(result) result.identity();
			else result = new Matrix();
			
			var go:GameObject = owner as GameObject;
			while(go)
			{
				result.concat(gameObject.transform.transformMatrix);
				go = go.owner as GameObject;
			}

			return result;
		}
		
		public function getCameraMatrix(result:Matrix = null):Matrix
        {
            if(result) result.identity();
            else result = new Matrix();

            result = getWorldMatrix(result);
			
//			MathUtil.helperMatrix.copyFrom(CrocoEngine.camera.transform.transformMatrix)

            MathUtil.helperMatrix.copyFrom(transform.transformMatrix);
            MathUtil.helperMatrix.invert();

			result.concat(MathUtil.helperMatrix);
			
			return result;
        }

        public function get width():Number
        {
            return __width;
        }


        public function set width(value:Number):void
        {
            setSize(value, __height);
        }

        public function get height():Number
        {
            return __height;
        }

        public function set height(value:Number):void
        {
            setSize(__width, value);
        }

        public function setSize(width:Number, height:Number):void
        {
            if(!sizeAble)
            {
                Logger.warn("TransformComponent sizeAble false!");
                return;
            }

            if(__width != width || __height != height)
            {
                __width = width;
                __height = height;
            }
        }

        public function getBounds(matrix:Matrix = null, result:Rectangle = null):Rectangle
        {
            if(!matrix) matrix = transformMatrix;
            if(!result) result = new Rectangle();

            MathUtil.helperRect.setTo(0, 0, __width, __height);
            return MathUtil.getBounds(MathUtil.helperRect, matrix, result);
        }
	}
}