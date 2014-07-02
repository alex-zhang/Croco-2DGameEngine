package com.croco2d.components.objectRef
{
	internal final class ObjectRefData implements IObjectRefData
	{
		public static var __objectReferenceDataPool:Array = [];

		public static function create(key:String, content:*, owner:ObjectRefPool):ObjectRefData
		{
			var result:ObjectRefData = __objectReferenceDataPool.length > 0 ?
				__objectReferenceDataPool.pop() :
				new ObjectRefData(); 

			result.mKey = key;
			result.mContent = content;
			result.mRefCount = 0;
			result.mOwner = owner;
			result.mHasReleased = false;
			
			return result;
		}
		
		public static function recycle(value:ObjectRefData):void
		{
			value.mKey = null;
			value.mContent = undefined;
			value.mRefCount = 0;
			value.mOwner = null;
			value.mHasReleased = true;
			
			__objectReferenceDataPool.push(value);
		}
		
		//----------------------------------------------------------------------
		
		internal var mKey:String;//the unique key
		internal var mContent:*;
		internal var mRefCount:int = 0;
		internal var mOwner:ObjectRefPool = null;
		internal var mHasReleased:Boolean = true;
		
		//IObjectReferenceData Interface.
		public function getKey():String 
		{
			if(mHasReleased) throw new Error("ObjectReferenceData has already released!");
			
			return mKey; 
		}
		
		public function getContent():* 
		{
			if(mHasReleased) throw new Error("ObjectReferenceData has already released!");
			
			return mContent;
		}
		
		public function getRefCount():int
		{
			if(mHasReleased) throw new Error("ObjectReferenceData has already released!");
			
			return mRefCount;
		}
		
		public function releaseRef():void
		{
			if(mHasReleased) throw new Error("ObjectReferenceData has already released!");
			
			mOwner.releaseObjectRef(mKey);
			
			ObjectRefData.recycle(this);
		}
		
		public function clone():ObjectRefData
		{
			if(mHasReleased) throw new Error("ObjectReferenceData has already released!");

			var c:ObjectRefData = ObjectRefData.create(mKey, mContent, mOwner);

			c.mKey = mKey;
			c.mContent = mContent;
			c.mRefCount = mRefCount;
			c.mOwner = mOwner;
			c.mHasReleased = mHasReleased;
			
			return c;
		}
	}
}