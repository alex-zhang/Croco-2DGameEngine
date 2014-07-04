package com.croco2d.utils.flow
{
	public class DecoratorFlowNode extends FlowNode
	{
		public var __childFlowNode:FlowNode;
		
		public function DecoratorFlowNode(ChildFlowNode:FlowNode)
		{
			super();
			
			__childFlowNode = ChildFlowNode;
		}
		
		public final function get child():FlowNode
		{
			return __childFlowNode;
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			__childFlowNode.init();
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			__childFlowNode.active();
		}
		
		override protected function onDeactive():void
		{
			super.onDeactive();
			
			__childFlowNode.deactive();
		}
		
		override public function tick(deltaTime:Number):void
		{
			if(__childFlowNode.__alive && __childFlowNode.__actived && __childFlowNode.tickable)
			{
				__childFlowNode.tick(deltaTime);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();

			if(__childFlowNode)
			{
				__childFlowNode.dispose();
				__childFlowNode = null;
			}
		}
	}
}