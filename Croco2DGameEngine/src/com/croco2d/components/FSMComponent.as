package com.croco2d.components
{
	import com.croco2d.core.CrocoObject;
	import com.croco2d.utils.fsm.FSM;

	public class FSMComponent extends CrocoObject
	{
		public var fsmImplCls:Class;
		public var initFSMStates:Array = null;
		public var defaultStateName:String;
		
		public var __fsm:FSM;

		public function FSMComponent()
		{
			super();
		}
		
		public function get fsm():FSM
		{
			return __fsm;
		}

		override protected function onInit():void
		{
			super.onInit();
			
			if(!fsmImplCls) fsmImplCls = FSM;
			
			__fsm = new fsmImplCls();
			__fsm.defaultStateName = defaultStateName;
			__fsm.states = initFSMStates;
			initFSMStates = null;
		}
		
		override public function tick(deltaTime:Number):void
		{
			__fsm.tick(deltaTime);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			fsmImplCls = null;
			initFSMStates = null;
			defaultStateName = null;
			
			if(__fsm)
			{
				__fsm.dispose();
				__fsm = null;
			}
		}
	}
}