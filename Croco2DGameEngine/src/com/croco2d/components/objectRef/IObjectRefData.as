package com.croco2d.components.objectRef
{
	public interface IObjectRefData
	{
		function getKey():String;
		function getContent():*;
		function getRefCount():int;
		
		function releaseRef():void;
	}
}