package com.croco2dMGE.utils.cache
{
	public class ObjectReferencePool implements IObjectReferencePool
	{
		private var mName:String;
		
		private var mOnDisposeDeActivedObjectCallback:Function = null;
		private var mSwipTime:Number = 60;//s default 30s
		
		protected var mActivedObjects:Array = [];//key => ObjectData
		protected var mDeActivedObjects:Array = [];//ket => ObjectData
		
		private var mTime:Number = 0.0;
		
		public function ObjectReferencePool()
		{
			super();
		}
		
		public function get name():String { return mName };
		public function set name(value:String):void { mName = value };
		
		public function get swipTime():Number { return mSwipTime };
		public function set swipTime(value:Number):void
		{
			mSwipTime = value;
		}
		
		public function get disposeDeActivedObjectCallback():Function { return mOnDisposeDeActivedObjectCallback };
		public function set disposeDeActivedObjectCallback(value:Function):void
		{
			mOnDisposeDeActivedObjectCallback = value;
		}
		
		public function dispose():void
		{
			var item:ObjectReferenceData = null;
			for each(item in mActivedObjects)
			{
				item.mReferenceCount = 0;
				delete mActivedObjects[item.mKey];
				mDeActivedObjects[item.mKey] = item;
			}
			
			swipDeActivedObjects();
			
			mOnDisposeDeActivedObjectCallback = null;
		}
		
		public function cacheObject(key:String, content:*):void
		{
			if(!key || !content) throw new ArgumentError("ObjectReferencePool::registAndFetchObject invalid key or object");
			
			if(!hasCachedObject(key))
			{
				var item:ObjectReferenceData = new ObjectReferenceData();
				
				item.mKey = key;
				item.mContent = content;

				//import! the object will put into the deactived objects pool. 
				//that means if you will not use the object anymore or use it later. 
				//it may well be disposed in the end if siwp time.
				//so, to make sure that the registed object will not be disposed, you need to
				//call the fetchObject and keep the reference.
				mDeActivedObjects[key] = item;
			}
		}
		
		public function hasCachedObject(key:String):Boolean
		{
			return mDeActivedObjects[key] || mActivedObjects[key];
		}
		
		public function fetch(key:String):IObjectReferenceData
		{
			var item:ObjectReferenceData = null;
			
			item = mDeActivedObjects[key];
			if(item)
			{
				item.mReferenceCount++;
				
				delete mDeActivedObjects[key];
				mActivedObjects[key] = item;
				
				return item;
			}
			
			item = mActivedObjects[key];
			if(item)
			{
				item.mReferenceCount++;
				return item;
			}
			
			throw new Error("there is no ObjectReferenceData in cache pool. key: " + key);
		}
		
		public function release(target:IObjectReferenceData):void
		{
			var item:ObjectReferenceData = mActivedObjects[ObjectReferenceData(target).mKey];
			if(item !== target) throw new Error("target key " +  ObjectReferenceData(target).mKey + "is not in the cache pool.");
			
			if(item.mReferenceCount > 0) item.mReferenceCount--;
			
			//there is no reference to the object. so, remove from the active pool to the deactived one.
			if(item.mReferenceCount == 0)
			{
				delete mActivedObjects[item.mKey];
				mDeActivedObjects[item.mKey] = item;
			}
		}
		
		public function tick(deltaTime:Number):void
		{
			mTime += deltaTime;
			if(mTime > swipTime)
			{
				mTime = 0.0;
				
				swipDeActivedObjects();
			}
		}
		
		private function swipDeActivedObjects():void
		{
			var item:ObjectReferenceData = null;
			for each(item in mDeActivedObjects)
			{
				if(mOnDisposeDeActivedObjectCallback != null)
				{
					mOnDisposeDeActivedObjectCallback(item.mContent);
				}

				delete mDeActivedObjects[item.mKey];
				
				item.mKey = null;
				item.mContent = null;
			}
		}
	}
}