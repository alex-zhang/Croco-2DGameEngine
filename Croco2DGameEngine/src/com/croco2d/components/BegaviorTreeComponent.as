package com.croco2d.components
{
	import com.croco2d.core.CrocoObject;
	import com.croco2d.utils.bt.BTNode;
	import com.croco2d.utils.bt.BTRootNode;

	public class BegaviorTreeComponent extends CrocoObject
	{
		public var btRootNodeImplCls:Class;
		public var initBTChildrenNodes:Vector.<BTNode>;
		
		public var __btRootNode:BTRootNode;
		
		public function BegaviorTreeComponent()
		{
			super();
		}
		
		public function get btRootNode():BTRootNode
		{
			return __btRootNode;
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			if(!btRootNodeImplCls) btRootNodeImplCls = BTRootNode;
			
			__btRootNode = new btRootNodeImplCls(initBTChildrenNodes);
			initBTChildrenNodes = null;
		}
		
		override public function tick(deltaTime:Number):void
		{
			__btRootNode.run(__btRootNode, deltaTime);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			initBTChildrenNodes = null;
			
			if(__btRootNode)
			{
				__btRootNode.dispose();
				__btRootNode = null;
			}
		}
	}
}