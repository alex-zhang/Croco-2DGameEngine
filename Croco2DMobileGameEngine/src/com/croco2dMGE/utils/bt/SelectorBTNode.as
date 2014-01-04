package com.croco2dMGE.utils.bt
{
	public class SelectorBTNode extends CompositeBTNodeBasic
	{
		public function SelectorBTNode(childrenNodes:Vector.<BTNode>)
		{
			super(childrenNodes);
		}
		
		override public function run(btRootNode:BTNode, deltaTime:Number):BTNodeResult
		{
			var n:int = mChildrenNodes.length;
			var childBTNode:BTNode;
			var childBTNodeResult:BTNodeResult;

			for(var i:int = 0; i < n; i++)
			{
				childBTNode = mChildrenNodes[i];
				childBTNodeResult = childBTNode.run(btRootNode, deltaTime);
				
				if(childBTNodeResult.isTrue()) return childBTNodeResult;
				if(childBTNodeResult.isMoreTime()) return childBTNodeResult;
			}
			
			return BTNodeResult.FALSE;
		}
	}
}