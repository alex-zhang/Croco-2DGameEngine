package com.croco2dMGE.core
{
	import com.fireflyLib.utils.UniqueLinkList;

	//A Group of CrocoBasic Object Manager.
	public class CrocoGroup extends CrocoBasic
	{
		protected var myItems:UniqueLinkList;
		
		public function CrocoGroup()
		{
			super();
			
			myItems = new UniqueLinkList();
		}

		public function get length():int { return myItems.length; }
		
		override public function dispose():void
		{
			super.dispose();
			
			myItems.clear();
			myItems = null;
		}
		
		public function hasItem(item:CrocoBasic):Boolean 
		{ 
			return myItems.hasItem(item); 
		}
		
		public function findItemByField(field:String, value:*):CrocoBasic
		{ 
			return findItemByFunction(
				function(item:CrocoBasic):Boolean {
					return item[field] == value;
				}); 
		}
		
		public function findItemByFunction(func:Function):CrocoBasic 
		{ 
			return myItems.findItemByFunction(func); 
		}
		
		public function addItem(item:CrocoBasic):CrocoBasic 
		{
			var addedItem:CrocoBasic = myItems.add(item); 
			
			if(addedItem)
			{
				onItemAdded(item);
			}
			
			return addedItem;
		}
		
		protected function onItemAdded(item:CrocoBasic):void {};
		
		public function removeItem(item:CrocoBasic):CrocoBasic 
		{
			var removedItem:CrocoBasic = myItems.remove(item);
			
			if(removedItem)
			{
				onItemRemoved(item);
			}
			
			return removedItem;
		}
		
		protected function onItemRemoved(item:CrocoBasic):void {};
		
		public function switchItemTo(item:CrocoBasic, target:CrocoGroup):CrocoBasic
		{
			var removedItem:CrocoBasic = myItems.remove(item);
			var addedItem:CrocoBasic = target.myItems.add(item);
			
			if(removedItem && addedItem)
			{
				this.onItemSwitchTo(item, this, target);	
				target.onItemSwitchFrom(item, this, target);
				
				return item;
			}
			
			return null;
		}
		
		protected function onItemSwitchFrom(item:CrocoBasic, from:CrocoGroup, target:CrocoGroup):void {};
		protected function onItemSwitchTo(item:CrocoBasic, from:CrocoGroup, target:CrocoGroup):void {};
		
		public function sortItems(compareFunction:Function):void { myItems.sort(compareFunction); };
		
//		override public function overlaps(target:CrocoBasic):Boolean
//		{
//			var item:CrocoBasic = myItems.moveFirst();
//			while(item)
//			{
//				if(item.exists && item.active && item.visible && target.overlaps(target))
//				{
//					return true;
//				}
//				
//				item = myItems.moveNext();
//			}
//			
//			return false;
//		}
	}
}