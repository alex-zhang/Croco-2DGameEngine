package com.croco2dMGE.utils.bt
{
	import com.fireflyLib.errors.AbstractMethodError;

	public class CompositeBTNodeBasic extends BTNode
	{
		protected var mChildrenNodes:Vector.<BTNode>;
		
		public function CompositeBTNodeBasic(childrenNodes:Vector.<BTNode>)
		{
			super();
			
			mChildrenNodes = childrenNodes;
			mChildrenNodes.fixed = true;
		}
		
		override public function run(btRootNode:BTNode, deltaTime:Number):BTNodeResult
		{
			throw new AbstractMethodError("run");
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mChildrenNodes)
			{
				var n:int = mChildrenNodes.length;
				for(var i:int = 0; i < n; i++)
				{
					mChildrenNodes[i].dispose();
					mChildrenNodes[i] = null;
				}
				mChildrenNodes = null;
			}
		}
	}
}