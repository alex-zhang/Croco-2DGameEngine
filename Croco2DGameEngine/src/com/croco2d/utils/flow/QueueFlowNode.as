package com.croco2d.utils.flow
{
	import com.croco2d.core.croco_internal;

	use namespace croco_internal;
	
	public class QueueFlowNode extends GroupFlowNodeBasic
	{
		public function QueueFlowNode()
		{
			super();
		}

		override protected function onExcuteFlow():void
		{
			excuteNextChildFlow();
		}

		override protected function onRemovedFlowNode(flowNode:FlowNode, needDispose:Boolean = false):void
		{
			super.onRemovedFlowNode(flowNode, needDispose);
			
			excuteNextChildFlow();
		}
		
		protected function excuteNextChildFlow():void
		{
			//here need to the next one. excute.
			var flowNode:FlowNode = __childrenFlowNodeSet.moveFirst() as FlowNode;
			if(flowNode)
			{
				flowNode.tickable = true;
				flowNode.excuteFlow();
			}
		}
	}
}