package com.croco2dMGE.utils.sscript.objects
{
	public class SArray extends SObject
	{
		private var mValue:Array;
		
		public function SArray(value:Array = null)
		{
			super();
			
			mValue = value || [];
		}
		
		override protected function onInit():void
		{
//			defineProperty("toSString", 
//				new SFunction(function(name:String, params:SArray):SObject {
//					return new SString(nValue.toString());
//				}));
//			
//			defineProperty("toSNumber", 
//				new SFunction(function(name:String, params:SArray):SObject {
//					return new SNumber(nValue ? 1 : 0);
//				}));
//			
//			defineProperty("toSBoolean", 
//				new SFunction(function(name:String, params:SArray):SObject {
//					return nValue ? TRUE : FALSE;
//				}));
		}
	}
}