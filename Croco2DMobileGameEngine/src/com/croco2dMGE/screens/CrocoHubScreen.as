package com.croco2dMGE.screens
{
	import com.croco2dMGE.AppConfig;

	public class CrocoHubScreen extends CrocoScreen
	{
		public function CrocoHubScreen()
		{
			super();
		}
		
		//helper
		protected function jumToTargetScreen():void
		{
			owner.showScreen(getJumToTargetScreenID());
		}
		
		public function getJumToTargetScreenID():String
		{
			return getSlefCrocoScreenNavigatorItem()
				.blackBoard.read(AppConfig.KEY_JUMP2TARGET_SCREEN_ID);
		}
		
		public function getJumToTargetScreenData():Object
		{
			return getCrocoScreenNavigatorItem(getJumToTargetScreenID())
				.blackBoard.read(AppConfig.KEY_ENTRY_SCREEN_DATA);
		}
	}
}