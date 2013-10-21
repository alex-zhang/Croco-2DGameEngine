package com.croco2dMGE.utils.cache
{
	public class ObjectReferenceData implements IObjectReferenceData
	{
		internal var mKey:String;//the unique key
		internal var mContent:*;
		internal var mReferenceCount:int = 0;
		
		public function getKey():String { return mKey; }
		public function getContent():* { return mContent; };
	}
}