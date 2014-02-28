package com.croco2d.utils.flow
{
	import com.croco2d.core.CrocoObject;

	public class FlowNode extends CrocoObject
	{
		public var __excuted:Boolean = false;
		
		public function FlowNode()
		{
			super();
		}
		
		public final function getParentFlow():FlowNode 
		{ 
			return parent as FlowNode; 
		}
		
		public final function getRootFlow():FlowNode
		{
			return getRootFlow() as FlowNode;
		}
		
		public final function excuteFlow():void
		{
			if(!__excuted)
			{
				onExcuteFlow();
				__excuted = true;
			}
		}
		
		protected function onExcuteFlow():void
		{
			throw new Error("FlowNode:: onExcuteFlow AbstractMethodError!");
		}
		
		//helper
		protected function onExcuteFlowCompleted():void
		{
			kill();
		}
	}
}