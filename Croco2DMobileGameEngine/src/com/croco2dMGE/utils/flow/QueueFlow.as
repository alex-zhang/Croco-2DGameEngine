package com.croco2dMGE.utils.flow
{
	import com.croco2dMGE.core.CrocoBasic;

	public class QueueFlow extends GroupFlowBasic
	{
		public function QueueFlow()
		{
			super();
		}

		override protected function onExcuteFlow():void
		{
			var item:CrocoBasic = myItems.moveFirst();
			if(item)
			{
				item.tickable = true;
				IFlow(item).excuteFlow();
			}
		}
		
		override protected function onItemDispose(item:CrocoBasic):void
		{
			super.onItemDispose(item);
			
			//here need to the next one. excute.
			var nextItem:CrocoBasic = myItems.moveFirst();
			if(nextItem)
			{
				nextItem.tickable = true;
				IFlow(nextItem).excuteFlow();
			}
		}
	}
}