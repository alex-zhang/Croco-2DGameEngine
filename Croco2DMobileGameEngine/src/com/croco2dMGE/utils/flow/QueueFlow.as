package com.croco2dMGE.utils.flow
{
	public class QueueFlow extends BasicGroupFlow
	{
		public function QueueFlow()
		{
			super();
		}

		override protected function onExcuteFlow():void
		{
			if(childrenFlows != null && childrenFlows.length > 0)
			{
				var childFlow:IFlow = childrenFlows.moveFirst();
				childFlow.excuteFlow();
			}
			else
			{
				onExcuteFlowComplete();
			}
		}
		
		override public function pushFlow(childFlow:IFlow):void
		{
			super.pushFlow(childFlow);
			
			if(isExcuted && getChildFlowCount() == 1)//the last one so excute
			{
				childFlow.excuteFlow();
			}
		}
		
		override public function notifyChildFlowComplete(childFlow:IFlow):void
		{
			var findChildFlow:IFlow = childrenFlows.moveFirst();
			childrenFlows.remove(findChildFlow);

			if(childrenFlows.length == 0)
			{
				onExcuteFlowComplete();
			}
			else
			{
				findChildFlow = childrenFlows.moveFirst();
				findChildFlow.excuteFlow();
			}
		}
	}
}