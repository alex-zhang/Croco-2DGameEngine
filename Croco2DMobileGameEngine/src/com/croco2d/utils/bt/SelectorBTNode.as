package com.croco2d.utils.bt
{
	public class SelectorBTNode extends CompositeBTNodeBasic
	{
		public function SelectorBTNode(childrenNodes:Vector.<BTNode>)
		{
			super(childrenNodes);
		}
		
		override public function run(btRootNode:BTNode, deltaTime:Number):BTNodeResult
		{
			var n:int = __childrenNodes.length;
			var childBTNode:BTNode;
			var childBTNodeResult:BTNodeResult;

			for(var i:int = 0; i < n; i++)
			{
				childBTNode = __childrenNodes[i];
				childBTNodeResult = childBTNode.run(btRootNode, deltaTime);
				
				if(childBTNodeResult.isTrue()) return childBTNodeResult;
				if(childBTNodeResult.isMoreTime()) return childBTNodeResult;
			}
			
			return BTNodeResult.FALSE;
		}
	}
}