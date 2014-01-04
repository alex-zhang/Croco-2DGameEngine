package com.croco2dMGE.utils.flow
{
	import com.croco2dMGE.core.CrocoBasic;

	public class ParallelFlow extends GroupFlowBasic
	{
		public function ParallelFlow()
		{
			super();
		}
		
		override protected function onExcuteFlow():void
		{
			var item:CrocoBasic = myItems.moveFirst();
			while(item)
			{
				item.tickable = true;
				IFlow(item).excuteFlow();
			}
		}
	}
}