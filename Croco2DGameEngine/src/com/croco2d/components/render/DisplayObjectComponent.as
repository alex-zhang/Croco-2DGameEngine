package com.croco2d.components.render
{
	import com.croco2d.core.GameObject;
	
	import flash.geom.Point;
	
	import starling.animation.IAnimatable;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.display.DisplayObject;
	import starling.filters.FragmentFilter;

	public class DisplayObjectComponent extends RenderComponent
	{
		public var __dispalyObject:DisplayObject;
		public var __isAnimatableDisplayObject:Boolean;

		public var filter:FragmentFilter;

		public function DisplayObjectComponent()
		{
			super();
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(!__dispalyObject) return null;
			
			//here the logic means __dispalyObject's mousechilren is false.
			if(__dispalyObject.hitTest(localPoint, forTouch))
			{
				return __dispalyObject;
			}
			
			return null;
		}
		
		//display object can share between DsiplayObjectComponent.
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
					__dispalyObject.myData.owner = null;
					__dispalyObject.starling_internal::setParent(null);
				}
				
				__dispalyObject = value;
				
				if(__dispalyObject)
				{
					__dispalyObject.myData.owner = this;
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
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(__dispalyObject)
			{
				//just the set the right matix in stage space.
				__dispalyObject.transformationMatrix = GameObject(owner).transform.__lastModelViewMatrix;
				
				if(filter)
				{
					filter.render(__dispalyObject, support, parentAlpha);
				}
				else
				{
					__dispalyObject.render(support, parentAlpha);
				}
			}
		}
	}
}