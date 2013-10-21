package com.croco2dMGE.utils
{
	import flash.geom.Point;
	
	/**
	 * Stores a 2D floating point coordinate.
	 * 
	 * @author	Adam Atomic
	 */
	public class CrocoPoint
	{
		/**
		 * @default 0
		 */
		public var x:Number;
		/**
		 * @default 0
		 */
		public var y:Number;
		
		/**
		 * Instantiate a new point object.
		 * 
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 */
		public function CrocoPoint(x:Number=0, y:Number=0)
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * Instantiate a new point object.
		 * 
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 */
		public function make(x:Number=0, y:Number=0):CrocoPoint
		{
			this.x = x;
			this.y = y;
			return this;
		}
		
		/**
		 * Helper function, just copies the values from the specified point.
		 * 
		 * @param	Point	Any <code>CrocoPoint</code>.
		 * 
		 * @return	A reference to itself.
		 */
		public function copyFrom(point:CrocoPoint):CrocoPoint
		{
			x = point.x;
			y = point.y;
			return this;
		}
		
		/**
		 * Helper function, just copies the values from this point to the specified point.
		 * 
		 * @param	Point	Any <code>CrocoPoint</code>.
		 * 
		 * @return	A reference to the altered point parameter.
		 */
		public function copyTo(point:CrocoPoint):CrocoPoint
		{
			point.x = x;
			point.y = y;
			return point;
		}
		
		/**
		 * Helper function, just copies the values from the specified Flash point.
		 * 
		 * @param	Point	Any <code>Point</code>.
		 * 
		 * @return	A reference to itself.
		 */
		public function copyFromFlash(flashPoint:Point):CrocoPoint
		{
			x = flashPoint.x;
			y = flashPoint.y;
			return this;
		}
		
		/**
		 * Helper function, just copies the values from this point to the specified Flash point.
		 * 
		 * @param	Point	Any <code>Point</code>.
		 * 
		 * @return	A reference to the altered point parameter.
		 */
		public function copyToFlash(flashPoint:Point):Point
		{
			flashPoint.x = x;
			flashPoint.y = y;
			return flashPoint;
		}
		
		public function clone():CrocoPoint
		{
			return new CrocoPoint(x, y);
		}
		
		public function toString():String
		{
			return "[x: " + x + ", y: " + y + "]";
		}
	}
}
