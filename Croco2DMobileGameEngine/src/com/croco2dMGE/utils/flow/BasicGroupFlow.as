package com.croco2dMGE.utils.flow
{
	import com.fireflyLib.utils.UniqueLinkList;

	public class BasicGroupFlow extends BasicFlow implements IGroupFlow
	{
		protected var childrenFlows:UniqueLinkList;
		
		public function BasicGroupFlow()
		{
			super();
		}
		
		override public function initialize(data:*):void
		{
			super.initialize(data);
			
			childrenFlows = new UniqueLinkList();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(childrenFlows)
			{
				var childFlow:IFlow = childrenFlows.moveFirst();
				while(childFlow)
				{
					childFlow.dispose();
					childFlow = childrenFlows.moveNext();
				}
	
				childrenFlows = null;
			}
		}
		
		public function pushFlow(childFlow:IFlow):void
		{
			childrenFlows.add(childFlow);
			childFlow.setParentFlow(this);
		}
		
		public function getChildFlowIndex(childFlow:IFlow):int
		{
			if(childrenFlows)
			{
				var findChildIndex:int = 0;
				var findChildFlow:IFlow = childrenFlows.moveFirst();
				while(findChildFlow)
				{
					if(findChildFlow === childFlow) return findChildIndex;
					
					findChildIndex++;
					findChildFlow = childrenFlows.moveNext();
				}
			}
			
			return -1;
		}
		
		public function getChildFlowCount():int
		{
			return childrenFlows != null ? childrenFlows.length : 0;
		}
	}
}