package com.croco2d.components
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.core.CrocoObject;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.animation.IAnimatable;
	import starling.core.RenderSupport;
	import starling.core.starling_internal;
	import starling.display.DisplayObject;

	public class DisplayComponent extends CrocoObject
	{
		public var touchable:Boolean = true;
		public var hitTestBounds:Rectangle;

		private var mDisplayStage:DisplayStage;
		private var mIsAnimatableDisplayObject:Boolean;
		
		public function DisplayComponent()
		{
			super();
			
			mDisplayStage = new DisplayStage(this);

			//draw able.
			visible = true;
		}
		
		public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(forTouch && (!visible || !touchable)) return null;
			
			return mDisplayStage.hitTest(localPoint, forTouch);
		}
		
		public function get displayObject():DisplayObject
		{
			return mDisplayStage.displayObject
		}
		
		public function set displayObject(value:DisplayObject):void
		{
			mDisplayStage.displayObject = value;
			mIsAnimatableDisplayObject = mDisplayStage.displayObject is IAnimatable;
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			mDisplayStage.starling_internal::setParent(CrocoEngine.camera.__displayStage);
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			if(mIsAnimatableDisplayObject)
			{
				IAnimatable(mDisplayStage.displayObject).advanceTime(deltaTime);
			}
		}

		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			super.draw(support, parentAlpha);
			
			mDisplayStage.render(support, parentAlpha);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mDisplayStage)
			{
				mDisplayStage.starling_internal::setParent(null);
				mDisplayStage.dispose();
				mDisplayStage = null;
			}
		}
	}
}

import com.croco2d.CrocoEngine;
import com.croco2d.components.DisplayComponent;
import com.croco2d.scene.CrocoGameObject;
import com.croco2d.utils.CrocoMathUtil;

import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.core.RenderSupport;
import starling.core.starling_internal;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.filters.FragmentFilter;
import starling.utils.MatrixUtil;

//for keep the __displayObject transform matrix chain, independent.
final class DisplayStage extends DisplayObjectContainer
{
	private var mDisplayComponent:DisplayComponent;
	public var __displayObject:DisplayObject;
	
	public function DisplayStage(displayComponent:DisplayComponent)
	{
		super();
		
		mDisplayComponent = displayComponent;
	}
	
	public final function get owner():DisplayComponent
	{
		return mDisplayComponent;
	}
	
	internal function set displayObject(value:DisplayObject):void
	{
		if(__displayObject != value)
		{
			if(__displayObject)
			{
				__displayObject.starling_internal::setParent(null);
			}
			
			__displayObject = value;
			
			__displayObject.starling_internal::setParent(this);
		}
	}
	
	internal function get displayObject():DisplayObject
	{
		return __displayObject;
	}
	
	override public function get transformationMatrix():Matrix
	{
		var mt:Matrix = super.transformationMatrix;
		mt.identity();
		
		var sceneEntity:CrocoGameObject = mDisplayComponent.owner as CrocoGameObject;
		if(!sceneEntity.ignoreCameraMatrix)
		{
			MatrixUtil.prependMatrix(mt, CrocoEngine.camera.transformMatrix);
		}
		
		mt.translate(sceneEntity.x, sceneEntity.y);
		
		return mt;
	}
	
	override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
	{
		if(!__displayObject) return null;
		
		//step 1.
		var localX:Number = localPoint.x;
		var localY:Number = localPoint.y;
		
		var mt:Matrix = CrocoMathUtil.helperMatrix;
		mt.copyFrom(this.transformationMatrix); 
		mt.invert();
		
		MatrixUtil.transformCoords(mt, localX, localY, localPoint);
		
		//step 2.
		//aabb test first.
		var sceneEntity:CrocoGameObject = mDisplayComponent.owner as CrocoGameObject;
		localX = localPoint.x - sceneEntity.x;
		localY = localPoint.y - sceneEntity.y;
		
		var aabb:Rectangle = sceneEntity.aabb;
		if(!aabb || 
			CrocoMathUtil.isOverlapPointAndRectangle(localX, localY, aabb.x, aabb.y, aabb.width, aabb.height))
		{
			mt.copyFrom(__displayObject.transformationMatrix);
			mt.invert();
			MatrixUtil.transformCoords(mt, localX, localY, localPoint);
			
			var hitTestBounds:Rectangle = mDisplayComponent.hitTestBounds;
			if(!hitTestBounds || 
				CrocoMathUtil.isOverlapPointAndRectangle(localPoint.x, localPoint.y, 
					hitTestBounds.x, hitTestBounds.y, hitTestBounds.width, hitTestBounds.height))
			{
				return __displayObject.hitTest(localPoint, forTouch);
			}
		}
		
		return null;
	}
	
	override public function render(support:RenderSupport, parentAlpha:Number):void
	{
		if(__displayObject && __displayObject.hasVisibleArea)
		{
			support.pushMatrix();

			support.transformMatrix(this);
			support.transformMatrix(__displayObject);
			
			var blendMode:String = support.blendMode;
			support.blendMode = __displayObject.blendMode;
			
			var filter:FragmentFilter = __displayObject.filter;
			if (filter) filter.render(__displayObject, support, parentAlpha);
			else        __displayObject.render(support, parentAlpha);
			
			support.blendMode = blendMode;

			support.popMatrix();
		}
	}
	
	override public function dispose():void
	{
		super.dispose();
		
		mDisplayComponent = null;

		if(__displayObject)
		{
			__displayObject.starling_internal::setParent(null);
			__displayObject.dispose();
			__displayObject = null;
		}
	}
}