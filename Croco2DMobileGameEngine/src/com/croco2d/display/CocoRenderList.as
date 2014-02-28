package com.croco2d.display
{
	import starling.core.starling_internal;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class CocoRenderList extends DisplayObjectContainer
	{
		public function CocoRenderList()
		{
			super();
		}
		
		override protected function onChildRemoved(child:DisplayObject):void
		{
			child.starling_internal::setParent(null);
		}
		
		override protected function onChildAdded(child:DisplayObject):void
		{
			child.starling_internal::setParent(this);
		}
	}
}