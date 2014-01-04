package com.croco2dMGE.utils.flow
{
	import com.croco2dMGE.core.CrocoBasic;

	public class DecoratorFlow extends FlowBasic
	{
		protected var mChildFlow:CrocoBasic;
		
		public function DecoratorFlow(childFlow:FlowBasic)
		{
			super();
			
			mChildFlow = childFlow;
		}
		
		override protected function onInit():void
		{
			mChildFlow ||= new FlowBasic();
			mChildFlow.init();
		}
		
		override public function tick(deltaTime:Number):void
		{
			if(mChildFlow)
			{
				if(mChildFlow.__alive)
				{
					if(mChildFlow.tickable)
					{
						onItemTick(mChildFlow, deltaTime);
					}
				}
				else
				{
					onItemDispose(mChildFlow);
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mChildFlow)
			{
				mChildFlow.dispose();
				mChildFlow = null;
			}
		}
		
		protected function onItemTick(item:CrocoBasic, deltaTime:Number):void
		{
			item.tick(deltaTime);
		}
		
		protected function onItemDispose(item:CrocoBasic):void
		{
			item.dispose();
			mChildFlow = null;

			__kill();
		}
	}
}