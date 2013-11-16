package com.croco2dMGE.utils.ai.behaviortree.decorators
{
	import com.croco2dMGE.utils.ai.behaviortree.base.Task;

	/**
	 * This decorator repeats its child forever, and never returns anything
	 * but MORE_TIME.
	 */
	public class RepeatForever extends RepeatUntil
	{
		public function RepeatForever(child:Task)
		{
			super(child);
		}
		
		public override function clone():Task
		{
			return new RepeatForever(child.clone());
		}
	}
}