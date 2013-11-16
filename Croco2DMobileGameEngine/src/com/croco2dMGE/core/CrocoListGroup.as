package com.croco2dMGE.core
{
	import starling.core.RenderSupport;

	public class CrocoListGroup extends CrocoGroup
	{
		public function CrocoListGroup()
		{
			super();
		}

		/**
		 * Automatically goes through and calls update on everything you added.
		 */
		override public function tick(deltaTime:Number):void
		{
			var item:CrocoBasic = myItems.moveFirst();
			while(item)
			{
				if(item.alive)
				{
					if(item.exists && item.active)
					{
						onItemTick(item, deltaTime);
					}	
				}
				else
				{
					onItemKill(item);
				}
				
				item = myItems.moveNext();
			}
		}
		
		protected function onItemKill(item:CrocoBasic):void
		{
			removeItem(item);
			item.dispose();
		}
		
		protected function onItemTick(item:CrocoBasic, deltaTime:Number):void
		{
			item.tick(deltaTime);
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			var item:CrocoBasic = myItems.moveFirst();
			while(item)
			{
				if(item.exists && item.visible)
				{
					onItemDraw(item, support, parentAlpha);
				}
				
				item = myItems.moveNext();
			}
		}
		
		protected function onItemDraw(item:CrocoBasic, support:RenderSupport, parentAlpha:Number):void
		{
			item.draw(support, parentAlpha);
		}
		
		/**
		 * Override this function to handle any deleting or "shutdown" type operations you might need,
		 * such as removing traditional Flash children like Sprite objects.
		 */
		override public function dispose():void
		{
			var item:CrocoBasic = myItems.moveFirst();
			
			while(item)
			{
				item.dispose();
				
				item = myItems.moveNext();
			}
			
			super.dispose();
		}
		
		override protected function onItemAdded(item:CrocoBasic):void
		{
			item.owner = this;
			
			item.init();
			item.onActive();
		}
		
		override protected function onItemRemoved(item:CrocoBasic):void
		{
			item.onDeactive();
			item.owner = null;
		}
	}
}