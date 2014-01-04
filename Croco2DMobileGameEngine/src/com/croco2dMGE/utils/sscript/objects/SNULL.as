package com.croco2dMGE.utils.sscript.objects
{
	public final class SNULL extends SObject
	{
		public static const NULL:SNULL = new SNULL();
		
		public function SNULL()
		{
			super();
		}
		
		override protected function onInit():void
		{
			defineProperty("toSString", 
				new SFunction(function(name:String, params:SArray):SObject {
					return new SString("null");
				}));
			
			defineProperty("toSNumber", 
				new SFunction(function(name:String, params:SArray):SObject {
					return new SNumber(0);
				}));
			
			defineProperty("toSBoolean", 
				new SFunction(function(name:String, params:SArray):SObject {
					return SBoolean.FALSE;
				}));
		}
	}
}