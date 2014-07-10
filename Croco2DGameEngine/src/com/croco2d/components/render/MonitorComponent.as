package com.croco2d.components.render
{
	import com.croco2d.CrocoEngine;

	public class MonitorComponent extends MonitorComponentBasic
	{
		public function MonitorComponent()
		{
			super();
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			CrocoEngine.instance.addEventListener(CrocoEngine.EVENT_AFTER_DRAW, globalAfterDrawHandler);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			CrocoEngine.instance.removeEventListener(CrocoEngine.EVENT_AFTER_DRAW, globalAfterDrawHandler);
		}
		
		protected function globalAfterDrawHandler(eventData:Object = null):void
		{
			drawWatchTarget();
		}
	}
}