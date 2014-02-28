package com.croco2d.screens
{
	import com.croco2d.AppConfig;
	
	import feathers.controls.ScreenNavigatorItem;

	public class HubScreen extends CrocoScreen
	{
		public function HubScreen()
		{
			super();
		}
		
		public function get jump2TargetScreenId():String
		{
			return entryScreenData ?
				entryScreenData[AppConfig.KEY_JUMP2TARGET_SCREEN_ID]:
			null;
		}
		
		public function get targetScreenEntryData():Object
		{
			return getTargetScreenNavigatorItem().properties[AppConfig.KEY_ENTRY_SCREEN_DATA];
		}
		
		public function getTargetScreenNavigatorItem():ScreenNavigatorItem
		{
			return getScreenNavigatorItem(jump2TargetScreenId);
		}
		
		//helper
		protected function jump2TargetScreen():void
		{
			owner.showScreen(jump2TargetScreenId);
		}
	}
}