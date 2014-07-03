package com.croco2d.utils
{
	import starling.events.Touch;

	public function getTouchTargetDisplayComponent(touch:Touch):*
	{
		return Object(touch.target.parent).owner;
	}
}