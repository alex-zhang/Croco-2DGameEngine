package com.croco2d.core
{
	public class CrocoObjectDecorator extends CrocoObject
	{
		//child will be the same life-cycle as the cur.
		public var __child:CrocoObject = null;
		
		public function CrocoObjectDecorator(child:CrocoObject)
		{
			super();

			__child = child;
			__child.parent = this;
		}
		
		public function get child():CrocoObject
		{
			return __child;
		}
		
		override protected function onInit():void
		{
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