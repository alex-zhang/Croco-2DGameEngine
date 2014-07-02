package com.croco2d.components.flow
{
	import com.croco2d.core.CrocoObjectGroup;
	import com.croco2d.core.CrocoObjectSet;
	import com.croco2d.core.croco_internal;

	use namespace croco_internal;

	public class GroupFlowNodeBasic extends FlowNode
	{
		public var __childrenFlowNodeSet:CrocoObjectSet;
		
		public function GroupFlowNodeBasic()
		{
			super();
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			__childrenFlowNodeSet = new CrocoObjectGroup();
			__childrenFlowNodeSet.name = "__childrenFlowNodeSet";
			__childrenFlowNodeSet.__onAddChildCallback = onAddedFlowNode;
			__childrenFlowNodeSet.__onRemoveChildCallback = onRemovedFlowNode;
			__childrenFlowNodeSet.init();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__childrenFlowNodeSet)
			{
				__childrenFlowNodeSet.dispose();
				
				__childrenFlowNodeSet = null;
			}
		}
		
		public final function pushFlow(flowNode:FlowNode):void
		{
			__childrenFlowNodeSet.addChild(flowNode);
		}
		
		protected function onAddedFlowNode(flowNode:FlowNode):void 
		{
			flowNode.owner = this;
			flowNode.parent = __childrenFlowNodeSet;
			flowNode.tickable = false;
			flowNode.init();
			flowNode.active();
		}
		
		protected function onRemovedFlowNode(flowNode:FlowNode, needDispose:Boolean = false):void
		{
			flowNode.deactive();
			
			if(needDispose)
			{
				flowNode.dispose();
			}
		}
		
		
		public function indexOfFlowNode(flowNode:FlowNode):int
		{
			return __childrenFlowNodeSet.indexOfChild(flowNode);
		}
//		
		public function getFlowNodesCount():int
		{
			return __childrenFlowNodeSet.length;
		}
		
		override public function tick(deltaTime:Number):void
		{
			if(checkGroupFlowsHasCompleted())
			{
				kill();
			}
			else
			{
				var child:FlowNode = __childrenFlowNodeSet.moveFirst() as FlowNode;
				
				while(child)
				{
					if(child.__alive)
					{
						if(child.tickable)
						{
							child.tick(deltaTime);
						}
					}
					else
					{
						//remove and dispose the child that __alive flag is false.
						__childrenFlowNodeSet.removeChild(child, true) as FlowNode;
					}
					
					child = __childrenFlowNodeSet.moveNext() as FlowNode;
				}
			}
		}
		
		protected function checkGroupFlowsHasCompleted():Boolean
		{
			return getFlowNodesCount() == 0;
		}
	}
}