package com.croco2dMGE.utils.flow
{
	import com.croco2dMGE.core.CrocoBasic;
	import com.fireflyLib.utils.PropertyBag;

	public class FlowBasic extends CrocoBasic implements IFlow
	{
		public function FlowBasic()
		{
			super();
			
			//don't need. draw, acticved state.
			visible = false;
			actived = false;
			tickable = false;//and the tickable will controll by parent, and false here.
			
			//we need a properBag default for data.
			propertyBag = new PropertyBag();
		}
		
		public function getParentFlow():IFlow { return owner as IFlow; }
		
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
		
		public final function excuteFlow():void
		{
			if(!__inited) return;
			
			super.init();
			
			onExcuteFlow();
		}
		
		protected function onExcuteFlow():void
		{
		}
		
		//helper
		protected final function onExcuteFlowCompleted():void
		{
			__kill();
		}
	}
}