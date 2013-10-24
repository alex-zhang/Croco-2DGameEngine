package com.croco2dMGE.utils.flow
{
	public class ParallelFlow extends BasicGroupFlow
	{
		public function ParallelFlow()
		{
			super();
		}
		
		override protected function onExcuteFlow():void
		{
			if(childrenFlows != null && childrenFlows.length > 0)
			{
				var childFlow:IFlow = childrenFlows.moveFirst();
				while(childFlow)
				{
					childFlow.excuteFlow();
					//this may complete
					if(childrenFlows)
					{
						childFlow = childrenFlows.moveNext();
					}
				}
			}
			else
			{
				onExcuteFlowComplete();
			}
		}
		
		override public function pushFlow(childFlow:IFlow):void
		{
			super.pushFlow(childFlow);
			
			if(isExcuted)
			{
				childFlow.excuteFlow();
			}
		}
		
		override public function notifyChildFlowComplete(childFlow:IFlow):void
		{
			childrenFlows.remove(childFlow);
			
			if(childrenFlows.length == 0)
			{
				onExcuteFlowComplete();
			}
		}
	}
}