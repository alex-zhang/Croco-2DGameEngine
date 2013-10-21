package com.croco2dMGE.world
{
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.filters.FragmentFilter;
	
	public class SceneEntity extends SceneObject
	{
		public var mouseEnable:Boolean = false;
		
		protected var mDisplayObject:DisplayObject;
		
		protected var mIsValidDisplayObject:Boolean = false;
		
		public function SceneEntity()
		{
			super();
		}
		
		public function get displayObject():DisplayObject { return mDisplayObject; };
		public function set displayObject(value:DisplayObject):void 
		{
			mDisplayObject = value;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mDisplayObject)
			{
				mDisplayObject.dispose();
				mDisplayObject = null;
			}
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			mIsValidDisplayObject = checkIsNeedDrawDisplayObject();
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			super.draw(support, parentAlpha);
			
			if(mIsValidDisplayObject)
			{
				drawDisplayObject();
				presentDisplayObject(support, parentAlpha);
			}
		}
		
		protected function checkIsNeedDrawDisplayObject():Boolean
		{
			return mDisplayObject && mDisplayObject.hasVisibleArea && isOverlapCamera();
		}
		
		protected function drawDisplayObject():void
		{
			mDisplayObject.x = screenX;
			mDisplayObject.y = screenY;
		}
		
		protected function presentDisplayObject(support:RenderSupport, parentAlpha:Number):void
		{
			var blendMode:String = support.blendMode;
			
			var filter:FragmentFilter = mDisplayObject.filter;
			
			support.pushMatrix();
			support.transformMatrix(mDisplayObject);
			support.blendMode = mDisplayObject.blendMode;
			
			if (filter) filter.render(mDisplayObject, support, parentAlpha);
			else        mDisplayObject.render(support, parentAlpha);
			
			support.blendMode = blendMode;
			support.popMatrix();
		}
	}
}