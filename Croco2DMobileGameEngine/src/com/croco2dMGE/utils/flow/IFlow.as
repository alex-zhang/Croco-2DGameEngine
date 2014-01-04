package com.croco2dMGE.utils.flow
{
	public interface IFlow
	{
		function getRootFlow():IFlow;
		
		function getParentFlow():IFlow;
		
		function excuteFlow():void;
		
		function dispose():void;
	}
}