package com.croco2dMGE.graphics.map
{
	public interface IMapCellRender
	{
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get colIndex():int;
		function set colIndex(value:int):void;

		function get rowIndex():int;
		function set rowIndex(value:int):void;
		
		function get cellWidth():int;
		function get cellHeight():int;
		
		function get owner():MapBasic;
		function set owner(value:MapBasic):void;
		
		function onActive():void;
		function onDeActive():void;
	}
}