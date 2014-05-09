package com.croco2d.components
{
	import com.croco2d.core.CrocoObject;
	import com.fireflyLib.utils.MathUtil;

	public class PathMovingComponent extends CrocoObject
	{
		/**
		 * Path behavior controls: move from the start of the path to the end then stop.
		 */
		public static const PATH_FORWARD:uint			= 0x000000;
		/**
		 * Path behavior controls: move from the end of the path to the start then stop.
		 */
		public static const PATH_BACKWARD:uint			= 0x000001;
		/**
		 * Path behavior controls: move from the start of the path to the end then directly back to the start, and start over.
		 */
		public static const PATH_LOOP_FORWARD:uint		= 0x000010;
		/**
		 * Path behavior controls: move from the end of the path to the start then directly back to the end, and start over.
		 */
		public static const PATH_LOOP_BACKWARD:uint		= 0x000100;
		/**
		 * Path behavior controls: move from the start of the path to the end then turn around and go back to the start, over and over.
		 */
		public static const PATH_YOYO:uint				= 0x001000;
		/**
		 * Path behavior controls: ignores any vertical component to the path data, only follows side to side.
		 */
		public static const PATH_HORIZONTAL_ONLY:uint	= 0x010000;
		/**
		 * Path behavior controls: ignores any horizontal component to the path data, only follows up and down.
		 */
		public static const PATH_VERTICAL_ONLY:uint		= 0x100000;
		
		public var x:Number;
		public var y:Number;
		public var angle:Number = 0;
		
		protected var mPaths:Array;/*Any Type of has x, y props*/
		protected var mPathMovingSpeed:Number = 0;
		/**
		 * Internal tracker for path behavior flags (like looping, horizontal only, etc).
		 */
		protected var mPathMovingMode:uint = 0;
		
		/**
		 * Internal helper, tracks which node of the path this object is moving toward.
		 */
		protected var mPathIndex:int = 0;
		/**
		 * Internal helper for node navigation, specifically yo-yo and backwards movement.
		 */
		protected var mPathInc:int;
		
		public function PathMovingComponent()
		{
			super();
		}
		
		public function get pathMovingMode():uint
		{
			return mPathMovingMode;
		}
		
		public function get movingPaths():Array
		{
			return mPaths ? mPaths.concat() : null;
		}
		
		public function followPath(paths:Array, 
								   curPosX:Number, curPosY:Number, curRotation:Number,
								  speed:Number = 100,
								  pathMode:uint = 0):void
		{
			mPaths = paths;
			mPathMovingMode = pathMode;
			
			//get starting node
			if((mPathMovingMode == PATH_BACKWARD) || (mPathMovingMode == PATH_LOOP_BACKWARD))
			{
				mPathIndex = mPaths.length - 1;
				mPathInc = -1;
			}
			else
			{
				mPathIndex = 0;
				mPathInc = 1;
			}
		}
		
		public function stopFollowPath(destroyPath:Boolean = true):void
		{
			mPathMovingSpeed = 0;
			if(destroyPath )mPaths = null; 
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			
		}
		
		protected function updatePathMotion(deltaTime:Number):void
		{
			//first check if we need to be pointing at the next node yet
			var pathNode:Object = mPaths[mPathIndex];
			var deltaX:Number = pathNode.x - x;
			var deltaY:Number = pathNode.y - y;
			
			var horizontalOnly:Boolean = (mPathMovingMode & PATH_HORIZONTAL_ONLY) > 0;
			var verticalOnly:Boolean = (mPathMovingMode & PATH_VERTICAL_ONLY) > 0;
			
			if(horizontalOnly)
			{
				if(((deltaX > 0) ? deltaX : -deltaX ) < mPathMovingSpeed * deltaTime)
				{
					pathNode = advancePath();
				}
			}
			else if(verticalOnly)
			{
				if(((deltaY > 0) ? deltaY : -deltaY) < mPathMovingSpeed * deltaTime)
					pathNode = advancePath();
			}
			else
			{
				if(Math.sqrt(deltaX * deltaX + deltaY * deltaY) < mPathMovingSpeed * deltaTime)
					pathNode = advancePath();
			}
			
			//then just move toward the current node at the requested speed
			if(mPathMovingSpeed != 0)
			{
				//set velocity based on path mode
				if(horizontalOnly || (y == pathNode.y))
				{
					if((x < pathNode.x ? mPathMovingSpeed : -mPathMovingSpeed) < 0)
						angle = -MathUtil.HALF_PI;
					else angle = MathUtil.HALF_PI;
				}
				else if(verticalOnly || (y == pathNode.x))
				{
					if((y < pathNode.y ? mPathMovingSpeed: -mPathMovingSpeed) < 0)
						angle = 0;
					else
						angle = Math.PI;
				}
				else
				{
					angle = MathUtil.twoPointToRadian(x, y, pathNode.x, pathNode.y);
				}
			}			
		}
		
		/**
		 * Internal function that decides what node in the path to aim for next based on the behavior flags.
		 * 
		 * @return	The node (a <code>FlxPoint</code> object) we are aiming for next.
		 */
		protected function advancePath(snap:Boolean = true):Object
		{
			if(snap)
			{
				var oldPathNode:Object = mPaths[mPathIndex];
				if(oldPathNode != null)
				{
					if((mPathMovingMode & PATH_VERTICAL_ONLY) == 0)
						x = oldPathNode.x;
					
					if((mPathMovingMode & PATH_HORIZONTAL_ONLY) == 0) 
						y = oldPathNode.y;
				}
			}
			
			mPathIndex += mPathInc;
			
			if((mPathMovingMode & PATH_BACKWARD) > 0)
			{
				if(mPathIndex < 0)
				{
					mPathIndex = 0;
					mPathMovingSpeed = 0;
				}
			}
			else if((mPathMovingMode & PATH_LOOP_FORWARD) > 0)
			{
				if(mPathIndex >= mPaths.length)
					mPathIndex = 0;
			}
			else if((mPathMovingMode & PATH_LOOP_BACKWARD) > 0)
			{
				if(mPathIndex < 0)
				{
					mPathIndex = mPaths.length - 1;
					if(mPathIndex < 0) mPathIndex = 0;
				}
			}
			else if((mPathMovingMode & PATH_YOYO) > 0)
			{
				if(mPathIndex > 0)
				{
					if(mPathIndex >= mPaths.length)
					{
						mPathIndex = mPaths.length - 2;
						if(mPathIndex < 0) mPathIndex = 0;
						mPathInc = -mPathInc;
					}
				}
				else if(mPathIndex < 0)
				{
					mPathIndex = 1;
					if(mPathIndex >= mPaths.length) mPathIndex = mPaths.length - 1;
					if(mPathIndex < 0) mPathIndex = 0;
					mPathInc = -mPathInc;
				}
			}
			else
			{
				if(mPathIndex >= mPaths.length)
				{
					mPathIndex = mPaths.length - 1;
					mPathMovingSpeed = 0;
				}
			}
			
			return mPaths[mPathIndex];
		}
	}
}