package com.croco2d.utils.flow
{
	import com.croco2d.core.CrocoObject;

	public class FlowComponent extends CrocoObject
	{
		public var flowNodeImplCls:Class;
		
		public var __rootFlowNode:FlowNode;
		
		public function FlowComponent()
		{
			super();
		}
		
		public function rootFlowNode():FlowNode
		{
			return __rootFlowNode;
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			if(!flowNodeImplCls) flowNodeImplCls = QueueFlowNode;
			
			__rootFlowNode = new flowNodeImplCls();
			
			__rootFlowNode.init();
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			__rootFlowNode.active();
		}
		
		override protected function onDeactive():void
		{
			super.onDeactive();
			
			__rootFlowNode.deactive();
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			__rootFlowNode.tick(deltaTime);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__rootFlowNode)
			{
				__rootFlowNode.dispose();
				__rootFlowNode = null;
			}
		}
	}
}