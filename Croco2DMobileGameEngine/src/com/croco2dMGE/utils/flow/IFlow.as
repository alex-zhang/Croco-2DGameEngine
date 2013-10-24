package com.croco2dMGE.utils.flow
{
	public interface IFlow
	{
		function initialize(data:*):void;
		
		function excuteFlow():void;
		
		function getRootFlow():IFlow;
		
		function getParentFlow():IFlow;
		function setParentFlow(p:IFlow):void;
		
		function notifyChildFlowComplete(childFlow:IFlow):void;
			
		function dispose():void;
	}
}