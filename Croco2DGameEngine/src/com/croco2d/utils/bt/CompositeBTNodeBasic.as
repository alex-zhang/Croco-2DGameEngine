package com.croco2d.utils.bt
{
	public class CompositeBTNodeBasic extends BTNode
	{
		public var __childrenNodes:Vector.<BTNode>;
		
		public function CompositeBTNodeBasic(childrenNodes:Vector.<BTNode>)
		{
			super();
			
			__childrenNodes = childrenNodes;
			__childrenNodes.fixed = true;
		}
		
		override public function run(btRootNode:BTNode, deltaTime:Number):BTNodeResult
		{
			throw new Error("CompositeBTNodeBasic:: run AbstractMethodError!");
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__childrenNodes)
			{
				var n:int = __childrenNodes.length;
				for(var i:int = 0; i < n; i++)
				{
					__childrenNodes[i].dispose();
					__childrenNodes[i] = null;
				}
				__childrenNodes = null;
			}
		}
	}
}