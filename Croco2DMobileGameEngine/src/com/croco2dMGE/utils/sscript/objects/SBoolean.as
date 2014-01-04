package com.croco2dMGE.utils.sscript.objects
{
	public final class SBoolean extends SObject
	{
		public static const FALSE:SBoolean = new SBoolean(false);
		public static const TRUE:SBoolean = new SBoolean(true);
		
		private var mValue:Boolean = false;
		
		public function SBoolean(value:Boolean)
		{
			super();
			
			mValue = value;
		}
		
		override protected function onInit():void
		{
			defineProperty("toSString", 
				new SFunction(function(name:String, params:SArray):SObject {
					return new SString(mValue.toString());
				}));
			
			defineProperty("toSNumber", 
				new SFunction(function(name:String, params:SArray):SObject {
					return new SNumber(mValue ? 1 : 0);
				}));
			
			defineProperty("toSBoolean", 
				new SFunction(function(name:String, params:SArray):SObject {
					return mValue ? TRUE : FALSE;
				}));
		}
	}
}