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
		
		public function jumToScreen(id:String, entryScreenData:Object = null):Boolean
		{
			var targetScreenItem:ScreenNavigatorItem = getScreen(id);
			if(!targetScreenItem) return false;
			
			var targetScreenProperties:Object = targetScreenItem.properties;
			if(entryScreenData)
			{
				targetScreenProperties[AppConfig.KEY_ENTRY_SCREEN_DATA] = entryScreenData;
			}
			else
			{
				entryScreenData = targetScreenProperties[AppConfig.KEY_ENTRY_SCREEN_DATA];
			}
			
			if(AppConfig.KEY_HUB_SCREEN_ID in entryScreenData)
			{
				var hubScreenId:String = entryScreenData[AppConfig.KEY_HUB_SCREEN_ID];
				var hubScreenItem:ScreenNavigatorItem = getScreen(hubScreenId);
				if(!hubScreenItem) return false;
				
				var hubScreenProperties:Object = hubScreenItem.properties;
				var hubScreenEnterData:Object = hubScreenProperties[AppConfig.KEY_ENTRY_SCREEN_DATA];
				hubScreenEnterData[AppConfig.KEY_JUMP2TARGET_SCREEN_ID] = id;
				
				return jumToScreen(hubScreenId);
			}
			else
			{
				showScreen(id);
				
				return true;
			}
		}
	}
}