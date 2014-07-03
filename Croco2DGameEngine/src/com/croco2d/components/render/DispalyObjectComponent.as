package com.croco2d.components.render
{
	import flash.geom.Point;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.display.DisplayObject;

	public class DispalyObjectComponent extends RenderComponent
	{
		public var __dispalyObject:DisplayObject;
		public var __isAnimatableDisplayObject:Boolean;
		
		public function DispalyObjectComponent()
		{
			super();
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(forTouch && !visible) return null;
			
			if(!__dispalyObject) return null;
			
			//here the logic means __dispalyObject's mousechilren is false.
			if(__dispalyObject.hitTest(localPoint, forTouch))
			{
				return __dispalyObject;
			}
			
			return null;
		}
		
		public final function get dispalyObject():DisplayObject
		{
			return __dispalyObject;
		}
		
		public function set dispalyObject(value:DisplayObject):void
		{
			if(__dispalyObject != value)
			{
				if(__dispalyObject)
				{
					__dispalyObject.starling_internal::setParent(null);
				}
				
				__dispalyObject = value;
				
				if(__dispalyObject)
				{
					__dispalyObject.starling_internal::setParent(Starling.current.stage);
				}
				
				__isAnimatableDisplayObject = __dispalyObject is IAnimatable;
			}
		}
		
		override public function tick(deltaTime:Number):void
		{
			if(__isAnimatableDisplayObject)
			{
				IAnimatable(__dispalyObject).advanceTime(deltaTime);
			}
		}
	}
}