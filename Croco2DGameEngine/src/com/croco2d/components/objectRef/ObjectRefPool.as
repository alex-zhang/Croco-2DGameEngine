package com.croco2d.components.objectRef
{
	import com.croco2d.core.CrocoObject;
	import com.llamaDebugger.Logger;
	
	import flash.sampler.getSize;

	public class ObjectRefPool extends CrocoObject
	{
		public var swipDuration:Number = 60;//s
		
		public var __onDisposeContentCallback:Function = onDisposeContent;

		public var __activedObjects:Array;//key => ObjectData
		public var __deActivedObjects:Array;//key => ObjectData
		public var __curSwipTime:Number = 0.0;
		
		public function ObjectRefPool()
		{
			super();
		}
		
		public function addObjectRef(key:String, content:*):void
		{
			if(!key || !content) throw new ArgumentError("ObjectRefPool::addObjectRef invalid key or content!");
			
			if(!hasObjectRef(key))
			{
				//importantly! the object will put into the deactived objects pool. 
				//that means if you will not use the object anymore or use it later. 
				//it will be swip and disposed in the end of siwp time.
				//so, to make sure that the cache object will not be disposed, you need to
				//call the fetchObjectRef and keep the reference.
				__deActivedObjects[key] = ObjectRefData.create(key, content, this);
			}
			else
			{
				Logger.warn("key " + key + " has already exist!", "addObjectRef", "ObjectRefPool");
			}
		}
		
		public function hasObjectRef(key:String):Boolean
		{
			return Boolean(__deActivedObjects[key]) || Boolean(__activedObjects[key]);
		}

		public function fetchObjectRef(key:String):IObjectRefData
		{
			var item:ObjectRefData = null;
			
			//first check the __deActivedObjects pool.
			item = __deActivedObjects[key];
			if(item)
			{
				item.mRefCount++;
				
				//move the item from __deActivedObjects to the __activedObjects.
				delete __deActivedObjects[key];
				__activedObjects[key] = item;
				
				return item.clone();
			}

			//second check the __deActivedObjects pool.
			item = __activedObjects[key];
			if(item)
			{
				item.mRefCount++;
				
				return item.clone();
			}
			
			Logger.error("there is no IObjectRefData in cache pool. key: " + key, "fetchObjectRef", "ObjectRefPool");
			
			return null;
		}
		
		internal function releaseObjectRef(key:String):void
		{
			var item:ObjectRefData = __activedObjects[key];
			if(!item)
			{
				Logger.error("key: " +  key + "is not in the actived cache pool.", "releaseObjectReference", "ObjectRefPool");
				return;
			}
			
			if(item.mRefCount > 0) item.mRefCount--;
			
			//there is no reference to the object. so remove from the active pool to the deactived one.
			if(item.mRefCount == 0)
			{
				delete __activedObjects[item.mKey];
				__deActivedObjects[item.mKey] = item;
			}
		}
		
		public function immediatelySwipAllDeActivedObjects():void
		{
			swipAllDeActivedObjects();
			__curSwipTime = 0;
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			__curSwipTime += deltaTime;
			if(__curSwipTime >= swipDuration)
			{
				__curSwipTime = 0.0;
				
				swipAllDeActivedObjects();
			}
		}
		
		private function swipAllDeActivedObjects():void
		{
			var logMsg:String = debug ? "" : null;
			var itemCount:int = 0;
			
			var item:ObjectRefData = null;
			for each(item in __deActivedObjects)
			{
				delete __deActivedObjects[item.mKey];
				
				__onDisposeContentCallback(item.mKey, item.mContent);
				
				if(debug)
				{
					itemCount++;
					logMsg += "key: " + item.mKey + "size: " + Number(getSize(item.mContent) / 1024 / 1024).toFixed(2) + "\n";
				}
				
				ObjectRefData.recycle(item.mContent);
			}
			
			if(debug)
			{
				logMsg += "count: " + itemCount;
				
				Logger.info(logMsg, "swipDeActivedObjects", "ObjectRefPool");
			}
		}
		
		protected function onDisposeContent(key:String, content:*):void
		{
			//the content must be impl the dispose method!
			content.dispose();

			if(debug)
			{
				Logger.info(this.name, "onDisposeContent", "ObjectRefPool");
			}
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			__activedObjects = [];
			__deActivedObjects = [];
		}
		
		override public function dispose():void
		{
			//clear the __activedObjects
			if(__activedObjects)
			{
				var item:ObjectRefData = null;
				for each(item in __activedObjects)
				{
					onDisposeContent(item.mKey, item.mContent);
					ObjectRefData.recycle(item);
				}

				__activedObjects = null;
			}
			
			if(__deActivedObjects)
			{
				swipAllDeActivedObjects();
				
				__deActivedObjects = null;
			}
			
			__curSwipTime = NaN;
			swipDuration = NaN;
		}
		
		override public function toString():String
		{
			var results:String = super.toString() + "\n" +
				"swipDuration: " + swipDuration + "\n" +
				"swipTime" + __curSwipTime + "\n";
			
			var itemCount:int = 0;
			var itemTotalSize:Number = 0;
			var itemSize:int = 0;
			var item:ObjectRefData = null;
			
			results += "__deActivedObjects: \n";
			for each(item in __deActivedObjects)
			{
				itemSize = getSize(item.mContent);
				itemTotalSize += itemSize;
				itemCount++;
				
				results += "key: " + item.mKey + "size: " + Number(itemSize / 1024 / 1024).toFixed(2) + "\n";
			}
			
			results += "count: " + itemCount + "size: " +  Number(itemTotalSize / 1024 / 1024).toFixed(2) + "\n";
			
			//--
			
			itemCount = 0;
			itemTotalSize = 0;
			
			results += "__activedObjects: \n";
			for each(item in __activedObjects)
			{
				itemSize = getSize(item.mContent);
				itemTotalSize += itemSize;
				itemCount++;
				
				results += "key: " + item.mKey + "size: " + Number(itemSize / 1024 / 1024).toFixed(2) + "\n";
			}
			
			results += "count: " + itemCount + "size: " +  Number(itemTotalSize / 1024 / 1024).toFixed(2);
			
			return results;
		}
	}
}