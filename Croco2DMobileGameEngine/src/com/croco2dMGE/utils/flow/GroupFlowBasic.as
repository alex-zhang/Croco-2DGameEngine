package com.croco2dMGE.utils.flow
{
	import com.croco2dMGE.core.CrocoBasic;
	import com.croco2dMGE.core.CrocoGroup;
	import com.fireflyLib.errors.AbstractMethodError;
	import com.fireflyLib.utils.PropertyBag;

	public class GroupFlowBasic extends CrocoGroup implements IGroupFlow
	{
		public function GroupFlowBasic()
		{
			super();
			
			//don't need. draw, acticved state.
			visible = false;
			actived = false;
			tickable = false;//and the tickable will controll by parent, and false here.
			
			//we need a properBag default for data.
			propertyBag = new PropertyBag();
		}
		
		//dead end
		override public function addItem(item:CrocoBasic):CrocoBasic { return null; };
		override public function removeItem(item:CrocoBasic):CrocoBasic { return null; };
		
		override public function dispose():void
		{
			var item:CrocoBasic = myItems.moveFirst();
			
			while(item)
			{
				item.dispose();
				
				item = myItems.moveNext();
			}
			
			super.dispose();
		}
		
		//IGroupFlow Interface
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
		
		public function pushFlow(childFlow:IFlow):void
		{
			super.addItem(childFlow);
		}
		
		override protected function onItemAdded(item:CrocoBasic):void 
		{
			item.owner = this;
			item.tickable = false;
		}
		
		public final function excuteFlow():void
		{
			if(!__inited) return;

			super.init();
			
			onExcuteFlow();
		}
		
		protected function onExcuteFlow():void
		{
			throw new AbstractMethodError("onExcuteFlow");
		}
		
		public function getChildFlowIndex(childFlow:IFlow):int
		{
			if(myItems)
			{
				var findChildIndex:int = 0;
				
				var findChildFlow:FlowBasic = myItems.moveFirst();
				while(findChildFlow)
				{
					if(findChildFlow === childFlow) return findChildIndex;
					
					findChildFlow = myItems.moveNext();
					
					findChildIndex++;
				}
			}
			
			return -1;
		}
		
		public function getChildFlowCount():int
		{
			return super.length;
		}
		
		override public function tick(deltaTime:Number):void
		{
			if(checkGroupFlowsHasCompleted())
			{
				__kill();
			}
			else
			{
				var item:CrocoBasic = myItems.moveFirst();
				while(item)
				{
					if(item.__alive)
					{
						if(item.tickable)
						{
							onItemTick(item, deltaTime);
						}
					}
					else
					{
						onItemDispose(item);
					}
					
					item = myItems.moveNext();
				}
			}
		}
		
		protected function checkGroupFlowsHasCompleted():Boolean
		{
			return getChildFlowCount() == 0;
		}
		
		protected function onItemDispose(item:CrocoBasic):void
		{
			removeItem(item);
			item.dispose();
		}
		
		protected function onItemTick(item:CrocoBasic, deltaTime:Number):void
		{
			item.tick(deltaTime);
		}
	}
}