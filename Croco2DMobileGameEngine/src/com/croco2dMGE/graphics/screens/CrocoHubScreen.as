package com.croco2dMGE.graphics.screens
{
	import com.croco2dMGE.bootStrap.CrocoBootStrapConfig;

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
			return getSlefCrocoScreenNavigatorItem().blackBoard.read(CrocoBootStrapConfig.KEY_JUMP2TARGET_SCEEN_ID);
		}
	}
}