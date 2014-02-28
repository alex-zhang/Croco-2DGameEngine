package com.croco2d.core
{
	import starling.core.RenderSupport;

	public class CrocoObjectDecorator extends CrocoObject
	{
		//child will be the same life-cycle as the cur.
		public var __child:CrocoObject = null;
		
		public function CrocoObjectDecorator(child:CrocoObject)
		{
			super();

			__child = child;
		}
		
		public final function get child():CrocoObject
		{
			return __child;
		}
		
		override protected function onInit():void
		{
			__child.parent = this;
			
			__child.init();
		}
		
		override protected function onActive():void
		{
			__child.active();
		}
		
		override public function tick(deltaTime:Number):void 
		{
			if(__child.tickable)
			{
				__child.tick(deltaTime);
			}
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			super.draw(support, parentAlpha);
			
			if(__child.visible)
			{
				__child.draw(support, parentAlpha);
			}
		}
		
		override protected function onDeactive():void
		{
			__child.deactive();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__child)
			{
				__child.dispose();
				__child = null;
			}
		}
		
		override public function toString():String
		{
			var results:String = super.toString() + "\n" +
				"child: " + __child;

			return results;
		}
	}
}