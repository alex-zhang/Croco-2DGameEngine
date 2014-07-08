package com.croco2d.display
{
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class CocoDisplayObjectList extends DisplayObjectContainer
	{
		public static function childrenSortFunction(childA:DisplayObject, childB:DisplayObject):Number
		{
			//-1 means the bottom depth than the other
			return childA.zOrder > childB.zOrder ? 1 : -1; 
			
			return -1;
		}

		private var mChildrenSortDirty:Boolean = false;
		private var mChildrenSortFunction:Function;
		
		public function CocoDisplayObjectList()
		{
			super();
			
			mChildrenSortFunction = childrenSortFunction;
		}
		
		public final function invalidChildrenSort():void
		{
			mChildrenSortDirty = true;
		}
		
		public function set childrenSortFunction(value:Function):void
		{
			if(mChildrenSortFunction != value)
			{
				mChildrenSortFunction = value;
				
				if(mChildrenSortFunction != null)
				{
					invalidChildrenSort();	
				}
			}
		}
		
		public function get childrenSortFunction():Function
		{
			return mChildrenSortFunction;
		}
		
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if(mChildrenSortDirty)
			{
				if(mChildrenSortFunction != null)
				{
					super.sortChildren(mChildrenSortFunction);
				}
				mChildrenSortDirty = false;
			}
			
			super.render(support, parentAlpha);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			mChildrenSortDirty = false;
			mChildrenSortFunction = null;
		}
	}
}