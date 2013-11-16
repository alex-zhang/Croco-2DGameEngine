package com.croco2dMGE.utils.ai.behaviortree.base.scope
{
	import com.croco2dMGE.utils.ai.behaviortree.data.Blackboard;
	
	/**
	 * This class represents the data that the behavior tree might need
	 * in order to complete its processing. This may include a chain
	 * of blackboards for inter-task communication, and a world model
	 * for the game itself. This base class can be overridden to provide
	 * the additional data needed. 
	 */
	public class Scope
	{
		/**
		 * The blackboard associated with this scope. This is public so
		 * it can be accessed directly.
		 */
		public var blackboard:Blackboard;
		
		/**
		 * The timing data associated with the current frame.
		 */
		public var timing:*;
				
		public function Scope()
		{
		}
	}
}