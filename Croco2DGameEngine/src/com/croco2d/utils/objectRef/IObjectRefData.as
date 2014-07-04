package com.croco2d.utils.objectRef
{
	public interface IObjectRefData
	{
		function getKey():String;
		function getContent():*;
		function getRefCount():int;
		
		function releaseRef():void;
	}
}