package com.croco2dMGE.utils.flow
{
	public class WaitFlow extends FlowBasic
	{
		private var waitTime:Number = 0.0;
		private var mCurRunTime:Number = 0.0;
		
		public function WaitFlow()
		{
			super();
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			waitTime = propertyBag.read("waitTime");
		}
		
		override public function tick(deltaTime:Number):void
		{
			mCurRunTime += deltaTime;

			if(mCurRunTime > waitTime)
			{
				onExcuteFlowCompleted();
			}
		}
	}
}