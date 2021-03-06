package com.croco2d.screens
{
	import com.croco2d.AppConfig;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;

	public class CrocoScreenNavigator extends ScreenNavigator
	{
		public function CrocoScreenNavigator()
		{
			super();
		}
		
		public function jumToScreen(id:String):Boolean
		{
			var targetScreenItem:ScreenNavigatorItem = getScreen(id);
			if(!targetScreenItem) return false;
			
			var targetScreenProperties:Object = targetScreenItem.properties;
			var targetScreenHubScreenId:String = targetScreenProperties[AppConfig.KEY_HUB_SCREEN_ID];

			if(targetScreenHubScreenId)
			{
				var targetScreenHubScreenItem:ScreenNavigatorItem = getScreen(targetScreenHubScreenId);
				if(!targetScreenHubScreenItem) return false;
				
				targetScreenHubScreenItem.properties[AppConfig.KEY_OWNER_SCREEN_ID] = id;
				
				return jumToScreen(targetScreenHubScreenId);
			}
			else
			{
				showScreen(id);
				
				return true;
			}
		}
	}
}