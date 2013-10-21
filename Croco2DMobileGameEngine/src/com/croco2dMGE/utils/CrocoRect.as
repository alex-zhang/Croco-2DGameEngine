package com.croco2dMGE.utils
{
	import flash.geom.Rectangle;

	/**
	 * Stores a rectangle.
	 * 
	 * @author	Adam Atomic
	 */
	public class CrocoRect
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
		 * @default 0
		 */
		public var width:Number;
		/**
		 * @default 0
		 */
		public var height:Number;
		
		/**
		 * Instantiate a new rectangle.
		 * 
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 * @param	Width	Desired width of the rectangle.
		 * @param	Height	Desired height of the rectangle.
		 */
		public function CrocoRect(x:Number=0, y:Number=0, 
								  width:Number=0, height:Number=0)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		/**
		 * The X coordinate of the left side of the rectangle.  Read-only.
		 */
		public function get left():Number
		{
			return x;
		}
		
		/**
		 * The X coordinate of the right side of the rectangle.  Read-only.
		 */
		public function get right():Number
		{
			return x + width;
		}
		
		/**
		 * The Y coordinate of the top of the rectangle.  Read-only.
		 */
		public function get top():Number
		{
			return y;
		}
		
		/**
		 * The Y coordinate of the bottom of the rectangle.  Read-only.
		 */
		public function get bottom():Number
		{
			return y + height;
		}
		
		/**
		 * Instantiate a new rectangle.
		 * 
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 * @param	Width	Desired width of the rectangle.
		 * @param	Height	Desired height of the rectangle.
		 * 
		 * @return	A reference to itself.
		 */
		public function make(x:Number = 0, y:Number = 0, 
							 width:Number = 0, height:Number = 0):CrocoRect
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			return this;
		}

		/**
		 * Helper function, just copies the values from the specified rectangle.
		 * 
		 * @param	Rect	Any <code>CrocoRect</code>.
		 * 
		 * @return	A reference to itself.
		 */
		public function copyFrom(rect:CrocoRect):CrocoRect
		{
			x = rect.x;
			y = rect.y;
			width = rect.width;
			height = rect.height;
			return this;
		}
		
		/**
		 * Helper function, just copies the values from this rectangle to the specified rectangle.
		 * 
		 * @param	Point	Any <code>CrocoRect</code>.
		 * 
		 * @return	A reference to the altered rectangle parameter.
		 */
		public function copyTo(rect:CrocoRect):CrocoRect
		{
			rect.x = x;
			rect.y = y;
			rect.width = width;
			rect.height = height;
			
			return rect;
		}
		
		/**
		 * Helper function, just copies the values from the specified Flash rectangle.
		 * 
		 * @param	FlashRect	Any <code>Rectangle</code>.
		 * 
		 * @return	A reference to itself.
		 */
		public function copyFromFlash(flashRect:Rectangle):CrocoRect
		{
			x = flashRect.x;
			y = flashRect.y;
			width = flashRect.width;
			height = flashRect.height;
			
			return this;
		}
		
		/**
		 * Helper function, just copies the values from this rectangle to the specified Flash rectangle.
		 * 
		 * @param	Point	Any <code>Rectangle</code>.
		 * 
		 * @return	A reference to the altered rectangle parameter.
		 */
		public function copyToFlash(flashRect:Rectangle):Rectangle
		{
			flashRect.x = x;
			flashRect.y = y;
			flashRect.width = width;
			flashRect.height = height;
			
			return flashRect;
		}
		
		/**
		 * Checks to see if some <code>CrocoRect</code> object overlaps this <code>CrocoRect</code> object.
		 * 
		 * @param	Rect	The rectangle being tested.
		 * 
		 * @return	Whether or not the two rectangles overlap.
		 */
		public function overlaps(rect:CrocoRect):Boolean
		{
			return (rect.right > left) && 
				(rect.left < right) && 
				(rect.bottom > top) && 
				(rect.top < bottom);
		}
		
		public function clone():CrocoRect
		{
			return new CrocoRect(x, y, width, height);
		}
		
		public function toString():String
		{
			return "[x: " + x + ", y: " + y + 
				", width: " + width + ", height: " + height + "]";
		}
	}
}
