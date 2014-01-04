package com.croco2dMGE.utils.sscript.objects
{
	public final class SString extends SObject
	{
		private var mValue:String;

		public function SString(value:String = "")
		{
			super();
			
			mValue = value || "";
		}
		
		override protected function onInit():void
		{
//			defineProperty("toSString", 
//				new SFunction(function(name:String, params:SArray):SObject {
//					return new SString(mValue);
//				}));
//			
//			defineProperty("toSNumber", 
//				new SFunction(function(name:String, params:SArray):SObject {
//					return new SNumber();
//				}));
//			
//			defineProperty("toSBoolean", 
//				new SFunction(function(name:String, params:SArray):SObject {
//					return nValue == 0 ? SBoolean.FALSE : SBoolean.TRUE;
//				}));
		}
		
		override public function valueOf():*
		{
			return mValue;
		}
		
		public function charAt(index:Number = 0):SString
		{
			return new SString(mValue.charAt(index));
		}
		
		public function indexOf(val:String, startIndex:Number = 0):SNumber
		{
			var index:int = mValue.indexOf(val, startIndex);
			
			return new SNumber(index);
		}
		
		public function substr(startIndex:Number = 0, len:Number = 0x7fffffff):SString
		{
			return new SString(mValue.substr(startIndex, len)); 
		}
	}
}