package com.croco2d.utils.bt
{

	/**
	 * Decorators are particular kinds of task that have a single child
	 * task and somehow modify its behavior. This is the base class
	 * for these kind of tasks.
	 * 
	 * The class is named for the 'decorator' object-oriented pattern.
	 */
	public class DecoratorBTNode extends BTNode
	{
		/**
		 * Holds the child task we're decorating.
		 */
		protected var mChild:BTNode = null;
		
		/**
		 * Records whether or not the current child is active (i.e. it
		 * returned null from its update method last time it was called).
		 * This allows us to know if we need to terminate it.
		 */
		protected var mIsChildActived:Boolean = false;
		
		public function DecoratorBTNode(child:BTNode)
		{
			super();
			
			mChild = child;	
		}
		
		public function get child():BTNode
		{
			return mChild;
		}
		
		/**
		 * Calls the child task to do its thing. This implementation
		 * keeps track of whether the child is active or not, so we
		 * know whether to terminate it later. Because of this functionality
		 * subclasses overriding this method normally call this base class
		 * method.
		 */
		public override function run(btRootNode:BTNode, deltaTime:Number):BTNodeResult
		{
			return mChild.run(btRootNode, deltaTime);
		}
		
		override public function dispose():void
		{
			if(mChild)
			{
				mChild.dispose();
				mChild = null;
			}
		}
	}
}