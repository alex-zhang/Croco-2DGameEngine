package com.croco2d.components.motion
{
	import com.croco2d.components.GameObjectComponent;
	import com.fireflyLib.utils.MathUtil;

	public class PathMovingComponent extends GameObjectComponent
	{
		/**
		 * Path behavior controls: move from the start of the path to the end then stop.
		 */
		public static const PATH_FORWARD:uint			= 0;
		/**
		 * Path behavior controls: move from the end of the path to the start then stop.
		 */
		public static const PATH_BACKWARD:uint			= 1;
		/**
		 * Path behavior controls: move from the start of the path to the end then directly back to the start, and start over.
		 */
		public static const PATH_LOOP_FORWARD:uint		= 2;
		/**
		 * Path behavior controls: move from the end of the path to the start then directly back to the end, and start over.
		 */
		public static const PATH_LOOP_BACKWARD:uint		= 3;
		/**
		 * Path behavior controls: move from the start of the path to the end then turn around and go back to the start, over and over.
		 */
		public static const PATH_YOYO:uint				= 4;
		
		public var x:Number;
		public var y:Number;
		public var rotation:Number = 0;
		
		public var bindTarget:Boolean = true;
		
		public var __updateTargetTransformCallback:Function = onUpdateTargetTransform;
		
		public var __paths:Array;/*Any Type of has x, y props*/
		public var __pathMovingSpeed:Number = 0;
		/**
		 * Internal tracker for path behavior flags (like looping, horizontal only, etc).
		 */
		public var __pathMovingMode:uint = 0;
		
		/**
		 * Internal helper, tracks which node of the path this object is moving toward.
		 */
		public var __pathIndex:int = 0;
		/**
		 * Internal helper for node navigation, specifically yo-yo and backwards movement.
		 */
		public var __pathInc:int;
		
		public function PathMovingComponent()
		{
			super();
		}
		
		public function get pathMovingMode():uint
		{
			return __pathMovingMode;
		}
		
		public function get movingPaths():Array
		{
			return __paths ? __paths.concat() : null;
		}
		
		public function followPath(paths:Array, 
								  speed:Number = 10,
								  pathMovingMode:uint = 0):void
		{

			__paths = paths;
			__pathMovingMode = pathMovingMode;
			__pathMovingSpeed = speed;
			
			//get starting node
			if((__pathMovingMode == PATH_BACKWARD) || (__pathMovingMode == PATH_LOOP_BACKWARD))
			{
				__pathIndex = __paths.length - 1;
				__pathInc = -1;
			}
			else
			{
				__pathIndex = 0;
				__pathInc = 1;
			}
		}
		
		override protected function onActive():void
		{
			if(bindTarget)
			{
				x = transform.x;
				y = transform.y;
			}
		}
		
		public function stopFollowPath(destroyPath:Boolean = true):void
		{
			__pathMovingSpeed = 0;
			if(destroyPath) __paths = null; 
		}
		
		override public function tick(deltaTime:Number):void
		{
			if(__paths && __pathMovingSpeed != 0)
			{
				updatePathMotion(deltaTime);
				
				if(bindTarget && owner != null)
				{
					__updateTargetTransformCallback(x, y, rotation);
				}
			}
		}
		
		protected function onUpdateTargetTransform(x:Number, y:Number, rotation:Number):void
		{
			transform.setPosition(x, y);
		}
		
		protected function updatePathMotion(deltaTime:Number):void
		{
			//first check if we need to be pointing at the next node yet
			var pathNode:Object = __paths[__pathIndex];
			
			var movingDeltaDistance:Number = deltaTime * __pathMovingSpeed;
			
			var distanceToCurNode:Number = MathUtil.distance(x, y, pathNode.x, pathNode.y);
			if(distanceToCurNode < movingDeltaDistance)
			{
				//get the next node.
				updatePathIndex();
				pathNode = __paths[__pathIndex];
			}
			
			rotation = MathUtil.twoPointToRadian(x, y, pathNode.x, pathNode.y);
			
			x += movingDeltaDistance * Math.cos(rotation);
			y += movingDeltaDistance * Math.sin(rotation);
		}
		
		/**
		 * Internal function that decides what node in the path to aim for next based on the behavior flags.
		 * 
		 * @return	The node (a <code>FlxPoint</code> object) we are aiming for next.
		 */
		protected function updatePathIndex():void
		{
			__pathIndex += __pathInc;
			
			if((__pathMovingMode & PATH_BACKWARD) > 0)
			{
				if(__pathIndex < 0)
				{
					__pathIndex = 0;
					__pathMovingSpeed = 0;
				}
			}
			else if((__pathMovingMode & PATH_LOOP_FORWARD) > 0)
			{
				if(__pathIndex >= __paths.length)
					__pathIndex = 0;
			}
			else if((__pathMovingMode & PATH_LOOP_BACKWARD) > 0)
			{
				if(__pathIndex < 0)
				{
					__pathIndex = __paths.length - 1;
					if(__pathIndex < 0) __pathIndex = 0;
				}
			}
			else if((__pathMovingMode & PATH_YOYO) > 0)
			{
				if(__pathIndex > 0)
				{
					if(__pathIndex >= __paths.length)
					{
						__pathIndex = __paths.length - 2;
						if(__pathIndex < 0) __pathIndex = 0;
						__pathInc = -__pathInc;
					}
				}
				else if(__pathIndex < 0)
				{
					__pathIndex = 1;
					if(__pathIndex >= __paths.length) __pathIndex = __paths.length - 1;
					if(__pathIndex < 0) __pathIndex = 0;
					__pathInc = -__pathInc;
				}
			}
			else
			{
				if(__pathIndex >= __paths.length)
				{
					__pathIndex = __paths.length - 1;
					__pathMovingSpeed = 0;
				}
			}
		}
	}
}