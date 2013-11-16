package com.croco2dMGE.graphics.screens
{
	import com.fireflyLib.utils.PropertyBag;
	
	import feathers.controls.ScreenNavigatorItem;

	public class CrocoScreenNavigatorItem extends ScreenNavigatorItem
	{
		public var blackBoard:PropertyBag;
		
		public function CrocoScreenNavigatorItem(screen:Object, 
												 events:Object = null, 
												 properties:Object = null, 
												 blackBoardData:Object = null)
		{
			super(screen, events, properties);
			
			blackBoard = new PropertyBag(blackBoardData);
		}
	}
}