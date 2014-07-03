package com.croco2d.components.render
{
	import com.croco2d.core.CrocoGameObject;
	
	import flash.geom.Point;
	
	import starling.animation.IAnimatable;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.display.DisplayObject;
	import starling.filters.FragmentFilter;

	public class DispalyObjectComponent extends RenderComponent
	{
		public var __dispalyObject:DisplayObject;
		public var __isAnimatableDisplayObject:Boolean;

		//if __isAnimatableDisplayObject true and this can controll.
		public var isPlayAnimation:Boolean = true;
		public var filter:FragmentFilter;

		public function DispalyObjectComponent()
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
			if(__isAnimatableDisplayObject && isPlayAnimation)
			{
				IAnimatable(__dispalyObject).advanceTime(deltaTime);
			}
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(__dispalyObject)
			{
				//just the set the right matix in stage space.
				__dispalyObject.transformationMatrix = CrocoGameObject(owner).transformComponent.__lastModelViewMatrix;
				
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