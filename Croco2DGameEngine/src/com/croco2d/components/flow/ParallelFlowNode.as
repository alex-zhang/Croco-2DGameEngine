package com.croco2d.components.flow
{
	public class ParallelFlowNode extends GroupFlowNodeBasic
	{
		public function ParallelFlowNode()
		{
			super();
		}

		override protected function onExcuteFlow():void
		{
			__childrenFlowNodeSet.forEach(function(flowNode:FlowNode):void {
				flowNode.tickable = true;
				flowNode.excuteFlow();
			});
		}
	}
}