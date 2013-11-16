package com.croco2dMGE.utils.ai.behaviortree.groups
{
	import com.croco2dMGE.utils.ai.behaviortree.base.OneTaskFromGroup;
	import com.croco2dMGE.utils.ai.behaviortree.base.Task;
	import com.croco2dMGE.utils.ai.behaviortree.base.TaskResult;

	/**
	 * A selector is one of the basic building blocks of a behavior
	 * tree: it tries its children in order and returns true when any
	 * of them return true, and returns false if it gets through them
	 * all.
	 * 
	 * It is used to select one working child, ignoring as many failing
	 * children as it meets.
	 */
	public class Selector extends OneTaskFromGroup
	{
		public function Selector()
		{
			super(false, true, TaskResult.FAILURE);
		}
		
		public override function clone():Task
		{
			var task:Selector = new Selector();
			addClonedChildren(task);
			return task;	
		}		
	}
}