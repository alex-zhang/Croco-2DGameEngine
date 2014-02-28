package com.croco2d.utils
{
	import com.croco2d.components.DisplayComponent;
	
	import starling.events.Touch;

	public function getTouchTargetDisplayComponent(touch:Touch):DisplayComponent
	{
		return Object(touch.target.parent).owner as DisplayComponent;
	}
}