package com.croco2dMGE.utils.flow
{
	public interface IGroupFlow extends IFlow
	{
		function pushFlow(childFlow:IFlow):void;
		
		function getChildFlowIndex(childFlow:IFlow):int;
		function getChildFlowCount():int;
	}
}