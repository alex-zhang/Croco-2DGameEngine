package com.croco2d.utils.bt
{
	public class ConditionBTNode extends BTNode
	{
		public function ConditionBTNode()
		{
			super();
		}
		
		override public function run(btRootNode:BTNode, deltaTime:Number):BTNodeResult
		{
			return BTNodeResult.TRUE;
		}
	}
}