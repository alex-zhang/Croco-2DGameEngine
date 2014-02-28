package com.croco2d.components
{
	import flash.geom.Point;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;

	public interface IDisplayComponent
	{
		function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject;
		function draw(support:RenderSupport, parentAlpha:Number):void;
	}
}