package com.croco2dMGE.utils.cache
{
	public class ObjectReferencePoolGroup
	{
		private var items:Vector.<IObjectReferencePool>;
		
		public function ObjectReferencePoolGroup()
		{
			super();
			
			items = new Vector.<IObjectReferencePool>();
		}
		
		public function get length():int { return items.length; }
		
		public function dispose():void
		{
			var item:IObjectReferencePool;
			var n:int = items.length;
			for(var i:int = 0; i < n; i++)
			{
				item = items[i];
				item.dispose();
			}
			items = null;
		}
		
		public function getItem(name:String):IObjectReferencePool
		{
			var item:IObjectReferencePool;
			var n:int = items.length;
			for(var i:int = 0; i < n; i++)
			{
				item = items[i];
				
				if(item.name == name) return item;
			}
			
			return item;
		}
		
		public function add(item:IObjectReferencePool):void
		{
			if(!item) return;
			
			var index:int = items.indexOf(item);
			if(index != -1) return;
			
			items.push(item);
			onItemAdded(item);
		}
		
		protected function onItemAdded(item:IObjectReferencePool):void {};
		
		public function remove(name:String, dispose:Boolean = true):IObjectReferencePool 
		{
			var item:IObjectReferencePool;
			var n:int = items.length;
			for(var i:int = 0; i < n; i++)
			{
				item = items[i];
				
				if(item.name == name) 
				{
					items.splice(i, 1);
					
					onItemRemoved(item);
					
					if(dispose) item.dispose();
					
					return item;
				}
			}
			
			return null;
		}
		
		protected function onItemRemoved(item:IObjectReferencePool):void {};
		
		/**
		 * Automatically goes through and calls update on everything you added.
		 */
		public function tick(deltaTime:Number):void
		{
			var item:IObjectReferencePool;
			var n:int = items.length;
			for(var i:int = 0; i < n; i++)
			{
				item = items[i];
				onItemTick(item, deltaTime);
			}
		}
		
		protected function onItemTick(item:IObjectReferencePool, deltaTime:Number):void
		{
			item.tick(deltaTime);
		}
	}
}