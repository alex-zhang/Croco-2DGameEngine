package com.croco2dMGE.utils.cache
{
	public interface IObjectReferencePool
	{
		function get name():String;
		
		function get swipTime():Number;
		function set swipTime(value:Number):void;
		
		function get disposeDeActivedObjectCallback():Function;
		function set disposeDeActivedObjectCallback(value:Function):void;
		
		function cacheObject(key:String, content:*):void;
		function hasCachedObject(key:String):Boolean;
		function fetch(key:String):IObjectReferenceData;
		function release(target:IObjectReferenceData):void;
		
		function dispose():void;
		function tick(deltaTime:Number):void;
	}
}