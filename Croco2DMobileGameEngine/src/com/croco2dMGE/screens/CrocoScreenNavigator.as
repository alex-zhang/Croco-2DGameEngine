package com.croco2dMGE.screens
{
	import com.croco2dMGE.AppConfig;
	
	import feathers.controls.ScreenNavigator;

	public class CrocoScreenNavigator extends ScreenNavigator
	{
		public function CrocoScreenNavigator()
		{
			super();
		}
		
		public function jumToScreen(id:String, data:Object = null):Boolean
		{
			var targetScreenItem:CrocoScreenNavigatorItem = getCrocoScreenNavigatorItem(id);
			if(!targetScreenItem) return false;
			
			targetScreenItem.blackBoard.write(AppConfig.KEY_ENTRY_SCREEN_DATA, data);
			
			if(targetScreenItem.blackBoard.has(AppConfig.KEY_HUB_SCREEN_ID))
			{
				var hubScreenName:String = targetScreenItem.blackBoard.read(AppConfig.KEY_HUB_SCREEN_ID);
				var hubScreenItem:CrocoScreenNavigatorItem = getCrocoScreenNavigatorItem(hubScreenName);
				if(!hubScreenItem) return false;
				
				hubScreenItem.blackBoard.write(AppConfig.KEY_JUMP2TARGET_SCREEN_ID, id);

				return jumToScreen(hubScreenName);
			}
			else
			{
				showScreen(id);
				
				return true;
			}
		}
		
		public function getCrocoScreenNavigatorItem(id:String):CrocoScreenNavigatorItem
		{
			return getScreen(id) as CrocoScreenNavigatorItem;
		}
	}
}