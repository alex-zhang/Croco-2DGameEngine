package com.croco2d.components.bt
{
	/**
	 * A simple decorator that returns true if its child returns false,
	 * and vice versa. Results of null (for more time) are returned
	 * without change.
	 */
	public class NotBTNode extends DecoratorBTNode
	{
		public function NotBTNode(child:BTNode)
		{
			super(child);
		}
		
		public override function run(btRootNode:BTNode, deltaTime:Number):BTNodeResult
		{
			var result:BTNodeResult = super.run(btRootNode, deltaTime);
			
			return result.not();
		}
	}
}