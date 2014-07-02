package com.croco2d.components
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.core.CrocoGameObject;
	import com.croco2d.core.CrocoObject;
	
	import flash.geom.Point;
	
	import starling.animation.IAnimatable;
	import starling.core.RenderSupport;
	import starling.core.starling_internal;
	import starling.display.DisplayObject;
	import starling.filters.FragmentFilter;

	public class RenderComponent extends CrocoObject
	{
		public var visible:Boolean = true;
		
		public var __dispalyobject:DisplayObject;
		public var __isAnimatableDisplayObject:Boolean;

		public function RenderComponent()
		{
			super();
		}
		
		public final function get dispalyobject():DisplayObject
		{
			return __dispalyobject;
		}
		
		public function set dispalyobject(value:DisplayObject):void
		{
			if(__dispalyobject != value)
			{
				if(__dispalyobject)
				{
					__dispalyobject.starling_internal::setParent(null);
				}
				
				__dispalyobject = value;
				
				if(__dispalyobject)
				{
					__dispalyobject.starling_internal::setParent(CrocoEngine.camera.displayStage);
				}
				
				__isAnimatableDisplayObject = __dispalyobject is IAnimatable;
			}
		}
		
		override public function tick(deltaTime:Number):void
		{
			if(__isAnimatableDisplayObject)
			{
				IAnimatable(__dispalyobject).advanceTime(deltaTime);
			}
		}
		
		public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(__dispalyobject && __dispalyobject.hasVisibleArea)
			{
				const filter:FragmentFilter = __dispalyobject.filter;
				const lastBlendMode:String = support.blendMode;
				
				//update the displayobject matrix for use. eg. filters
				__dispalyobject.transformationMatrix = CrocoGameObject(owner).transformComponent.lastWorldTransformMatrix;

				support.blendMode = __dispalyobject.blendMode;
				
				if (filter) filter.render(__dispalyobject, support, parentAlpha);
				else        __dispalyobject.render(support, parentAlpha);

				support.blendMode = lastBlendMode;
			}
		}
		
		public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(forTouch && !visible) return null;
			
			if(!__dispalyobject) return null;
			
			//here the logic means __dispalyobject's mousechilren is false.
			if(__dispalyobject.hitTest(localPoint, forTouch))
			{
				return __dispalyobject;
			}
			
			return null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__dispalyobject)
			{
				__dispalyobject.starling_internal::setParent(null);
				__dispalyobject.dispose();
				__dispalyobject = null;
			}
		}
	}
}