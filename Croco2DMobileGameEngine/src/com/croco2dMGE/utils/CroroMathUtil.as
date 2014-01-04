package com.croco2dMGE.utils
{
	import com.fireflyLib.utils.MathUtil;
	
	public final class CroroMathUtil
	{
		/**
		 * Should always represent (0,0) - useful for different things, for avoiding unnecessary <code>new</code> calls.
		 */
		public static const ZERO_CROCO_POINT:CrocoPoint = new CrocoPoint();
		
		
		//Abount angle
		//======================================================================
		public static function caculateRadianByTwoPoint(startX:Number, startY:Number, endX:Number, endY:Number):Number
		{
			return Math.atan2(endY - startY, endX - startX);
		}
		
		/**
		 * Take a radian measure and make sure it is between -pi..pi. 
		 */
		public static function clampRadian(r:Number):Number 
		{ 
			r = r % MathUtil.TWO_PI;
			if (r > Math.PI)  r -= MathUtil.TWO_PI; 
			else if (r < -Math.PI) r += MathUtil.TWO_PI; 
			
			return r; 
		} 
		
		/**
		 * Take a degree measure and make sure it is between -180..180.
		 */
		public static function clampDegrees(r:Number):Number
		{
			r = r % 360;
			if (r > 180) r -= 360;
			else if (r < -180) r += 360;
			
			return r;
		}
		
		public static function mirrorRadinByYAxe(r:Number):Number
		{
			r = clampRadian(r);
			
			//-pi-pi
			if(r < 0)
			{
				return -Math.PI - r;
			}
			else
			{
				return Math.PI - r;
			}
		}
		
		/**
		 * Return the shortest distance to get from from to to, in radians.
		 */
		public static function getRadianShortDelta(from:Number, to:Number):Number
		{
			// Unwrap both from and to.
			from = clampRadian(from);
			to = clampRadian(to);
			
			// Calc delta.
			var delta:Number = to - from;
			
			// Make sure delta is shortest path around circle.
			delta = clampRadian(delta);
			
			// Done
			return delta;
		}
		
		/**
		 * Return the shortest distance to get from from to to, in degrees.
		 */
		public static function getDegreesShortDelta(from:Number, to:Number):Number
		{
			// Unwrap both from and to.
			from = clampRadian(from);
			to = clampRadian(to);
			
			// Calc delta.
			var delta:Number = to - from;
			
			// Make sure delta is shortest path around circle.
			
			delta = clampRadian(delta);
			
			// Done
			return delta;
		}
		
		/**
		 * Generates a random number based on the seed provided.
		 * 
		 * @param	Seed	A number between 0 and 1, used to generate a predictable random number (very optional).
		 * 
		 * @return	A <code>Number</code> between 0 and 1.
		 */
		public static function srand(Seed:Number):Number
		{
			return ((69621 * int(Seed * 0x7FFFFFFF)) % 0x7FFFFFFF) / 0x7FFFFFFF;
		}
		
		//About Geom
		//======================================================================
		public static function lerpByTwoPoints(p0x:Number, p0y:Number,
													p1x:Number, p1y:Number, ratio:Number, 
													result:CrocoPoint = null):CrocoPoint
		{
			result ||= new CrocoPoint();
			
			result.x = MathUtil.lerp(p0x, p1x, ratio);
			result.y = MathUtil.lerp(p0y, p1y, ratio);
			
			return result;
		}
		
		//path item .x, .y
		public static function caculateLengthOfPoints(points:Array):Number
		{
			var result:Number = 0;
			
			var currentPoint:Object = null;
			var lastPoint:Object = null;

			for(var i:uint = 1, n:uint = points ? points.length : 0; i < n; i++)
			{
				currentPoint = points[i];
				lastPoint = points[i - 1];
				
				result += MathUtil.distance(currentPoint.x, currentPoint.y, lastPoint.x, lastPoint.y);
			}
			
			return result;
		}
		
		//计算椭圆上的点
		public static function caculatePointOnEllipse(circleCenterX:Number, circleCenterY:Number, 
													  radian:Number, radiusX:Number, radiusY:Number,  
													  result:CrocoPoint = null):CrocoPoint
		{
			result ||= new CrocoPoint();
			result.x = circleCenterX + Math.cos(radian) * radiusX;
			result.y = circleCenterY + Math.sin(radian) * radiusY;
			return result;
		}
		
		//求圆上一点点坐标
		public static function caculatePointOnCircle(circleCenterX:Number, circleCenterY:Number, 
													 radian:Number, radius:Number,
													 result:CrocoPoint = null):CrocoPoint
		{
			result ||= new CrocoPoint();
			result.x = circleCenterX + Math.cos(radian) * radius;
			result.y = circleCenterY + Math.sin(radian) * radius;
			return result;
		}
		
		public static function caculateTargetAxePointInSourceAxePoint(targetAxePointX:Number, targetAxePointY:Number,
																	  targetAxeXDirectionRadianInSourceAxe:Number,
																	  targetAxeOriginPointX:Number, targetAxeOriginPointY:Number,
																	  result:CrocoPoint = null):CrocoPoint
		{
			result ||= new CrocoPoint();
			
			var sinValue:Number = Math.sin(targetAxeXDirectionRadianInSourceAxe);
			var cosVlaue:Number = Math.cos(targetAxeXDirectionRadianInSourceAxe);

			result.x = cosVlaue * targetAxePointX - sinValue * targetAxePointY + targetAxeOriginPointX;
			result.y = cosVlaue * targetAxePointY + sinValue * targetAxePointX + targetAxeOriginPointY;
			
			return result;
		}
		
		//已知点p，求该点与p0,p1线垂直的线的焦点坐标
		public static function caculatePerpendicularIntersectionPoint(px:Number, py:Number, 
														  lineP0x:Number, lineP0y:Number, 
														  lineP1x:Number, lineP1y:Number, 
														  result:CrocoPoint = null):CrocoPoint
		{
			result ||= new CrocoPoint();
			
			if(lineP0x == lineP1x)
			{
				result.make(lineP0x, py);
				return result;
			}
			
			var linek:Number = (lineP1y - lineP0y) / (lineP1x - lineP0x);
			var perpendicularLinek:Number = 1 / linek;
			
			return CroroMathUtil.caculateIntersectionPoint(px, py, perpendicularLinek, lineP0x, lineP0y, linek);
		}
		
		public static function caculateIntersectionPoint(line0Px:Number, line0Py:Number, line0K:Number, 
														 line1Px:Number, line1Py:Number, line1K:Number, 
														 result:CrocoPoint = null):CrocoPoint
		{
			if(line0K == line1K) return null;
			
			//			y=a0x+b0,y=a1x+b1
			var b0:Number;
			var b1:Number;
			var x:Number;
			var y:Number;
			
			if(line0K == Infinity)
			{
				x = line0Px;
				b1 = line1Py - line1Px * line1K;
				y = line1K * x + b1;
			}
			else if(line1K == Infinity)
			{
				x = line1Px;
				b0 = line0Py - line0Px * line0K;
				y = line0K * x + b0;
			}
			else
			{
				b0 = line0Py - line0Px * line0K;
				b1 = line1Py - line1Px * line1K;
				
				x = (b1 - b0) / (line1K - line0K);
				y = line0K * (b1 - b0) / (line1K - line0K) + b0;
			}
			
			result ||= new CrocoPoint();
			result.make(x, y);
			
			return result;
		}
		
		public static function isOverlapPointAndPoint(point0X:Number, point0Y:Number, 
													  point1X:Number, point1Y:Number):Boolean
		{
			return point0X == point1X && point0Y == point1Y;
		}
		
		public static function isOverlapPointAndRectangle(pointX:Number, pointY:Number, 
														  rectX:Number, rectY:Number, 
														  rectWidth:Number, rectHeight:Number):Boolean
		{
			if(pointX < rectX) return false;
			else if(pointX > rectX + rectWidth) return false;
			
			if(pointY < rectY) return false;
			else if(pointY > rectY + rectHeight) return false;
			
			return true;
		}
		
		public static function isOverlapPointAndCircle(pointX:Number, pointY:Number, 
													   circleCenterX:Number, 
													   circleCenterY:Number, 
													   circleRadius:Number):Boolean
		{
			var distance:Number = MathUtil.distance(pointX, pointY, circleCenterX, circleCenterY);
			
			if(distance > circleRadius) return false; 
			
			return true;
		}
		
		public static function isOverlapRectangleAndRectangle(rect0X:Number, rect0Y:Number, 
															  rect0Width:Number, rect0Height:Number, 
															  rect1X:Number, rect1Y:Number, 
															  rect1Width:Number, rect1Height:Number):Boolean
		{
			if(rect0X + rect0Width < rect1X) return false;
			else if(rect0X > rect1X + rect1Width) return false;
			
			if(rect0Y + rect0Height < rect1Y) return false;
			else if(rect0Y > rect1Y + rect1Height) return false;
			
			return true;
		}
		
		public static function isOverlapRectangleAndCircle(circleCenterX:Number, 
														   circleCenterY:Number, 
														   circleRadius:Number, 
														   rectX:Number, rectY:Number, 
														   rectWidth:Number, rectHeight:Number):Boolean
		{
			if(circleCenterX + circleRadius < rectX) return false;
			else if(circleCenterX - circleRadius  > rectX + rectWidth) return false;
			
			if(circleCenterY + circleRadius < rectY) return false;
			else if(circleCenterY - circleRadius > rectY + rectHeight) return false;
			
			return true;
		}
		
		public static function isOverlapCircleAndCircle(circleCenter0X:Number, 
														circleCenter0Y:Number, 
														circle0Radius:Number, 
														circle1CenterX:Number, 
														circle1CenterY:Number, 
														circle1Radius:Number):Boolean
		{
			var cicleMiddleDistance:Number = MathUtil.distance(circleCenter0X, circleCenter0Y, circle1CenterX, circle1CenterY);
			var cicleMiddleMinDistance:Number = circle0Radius + circle1Radius;
			
			if(cicleMiddleMinDistance > cicleMiddleDistance) return false;
			
			return true;
		}
		
		/** Returns the next power of two that is equal to or bigger than the specified number. */
		public static function getNextPowerOfTwo(number:int):int
		{
			if (number > 0 && (number & (number - 1)) == 0) // see: http://goo.gl/D9kPj
				return number;
			else
			{
				var result:int = 1;
				while (result < number) result <<= 1;
				return result;
			}
		}
	}
}