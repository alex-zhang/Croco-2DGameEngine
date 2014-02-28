package com.croco2d.utils.flow
{
	public class WaitFlowNode extends FlowNode
	{
		public var waitTime:Number = 0.0;
		
		private var mCurRunTime:Number = 0.0;
		
		public function WaitFlowNode()
		{
			super();
		}
		
		override public function tick(deltaTime:Number):void
		{
			mCurRunTime += deltaTime;

			if(mCurRunTime >= waitTime)
			{
				mCurRunTime = 0;
				
				onExcuteFlowCompleted();
			}
		}
	}
}