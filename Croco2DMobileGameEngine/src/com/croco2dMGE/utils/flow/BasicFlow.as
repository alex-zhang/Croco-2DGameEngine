package com.croco2dMGE.utils.flow
{
	public class BasicFlow implements IFlow
	{
		protected var mParentFlow:IFlow;
		protected var myData:*;
		
		private var mIsExcuted:Boolean = false;
		
		public function BasicFlow()
		{
			super();
		}
		
		//IBattleFlow Interface
		public function get isExcuted():Boolean { return mIsExcuted; }
		
		public function getRootFlow():IFlow
		{
			var f:IFlow = this;
			
			var p:IFlow = null;
			while(f)
			{
				p = f.getParentFlow();
				
				if(p == null) return f;
				
				f = p;
			}
			
			return f;
		}
		
		public function getParentFlow():IFlow { return mParentFlow; }
		public function setParentFlow(value:IFlow):void { mParentFlow = value; }
		public function hasParentFlow():Boolean { return Boolean(mParentFlow); }
		
		public function initialize(data:*):void
		{
			myData = data;
		}
		
		public final function excuteFlow():void
		{
			onExcuteFlow();
			
			mIsExcuted = true;
		}
		
		protected function onExcuteFlow():void
		{
		}
		
		public function dispose():void
		{
			mIsExcuted = false;
			myData = null;
			mParentFlow = null;
		}
		
		protected function onExcuteFlowComplete():void
		{
			var p:IFlow = mParentFlow;
			
			dispose();
			
			if(p != null)
			{
				p.notifyChildFlowComplete(this);
			}
		}
		
		public function notifyChildFlowComplete(childFlow:IFlow):void
		{
			throw new Error("BasicFlow::notifyChildFlowComplete");
		}
	}
}