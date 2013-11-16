package com.croco2dMGE.graphics.screens
{
	import com.croco2dMGE.bootStrap.CrocoBootStrapConfig;
	
	import feathers.controls.ScreenNavigator;
	
	import starling.animation.Transitions;
	import starling.display.DisplayObject;

	public class CrocoScreenNavigator extends ScreenNavigator
	{
		public function CrocoScreenNavigator()
		{
			super();
			
			transition = fadeTransition
		}
		
		protected function fadeTransition(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void
		{
			Transitions
		}
		
		public function jumToScreen(id:String):Boolean
		{
			var targetScreenItem:CrocoScreenNavigatorItem = getCrocoScreenNavigatorItem(id);
			if(!targetScreenItem) return false;
			
			if(targetScreenItem.blackBoard.has(CrocoBootStrapConfig.KEY_HUB_SCREEN_ID))
			{
				var hubScreenName:String = targetScreenItem.blackBoard.read(CrocoBootStrapConfig.KEY_HUB_SCREEN_ID);
				var hubScreenItem:CrocoScreenNavigatorItem = getCrocoScreenNavigatorItem(hubScreenName);
				if(!hubScreenItem) return false;
				
				hubScreenItem.blackBoard.write(CrocoBootStrapConfig.KEY_JUMP2TARGET_SCEEN_ID, id);
				
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