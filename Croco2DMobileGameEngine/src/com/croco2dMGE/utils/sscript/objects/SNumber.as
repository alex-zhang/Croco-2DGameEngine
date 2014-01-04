package com.croco2dMGE.utils.sscript.objects
{
	public class SNumber extends SObject
	{
		private var nValue:Number;
		
		public function SNumber(value:Number = 0.0)
		{
			super();
			
			nValue = value;
			
			if(isNaN(nValue))
			{
				nValue = 0.0;
			}
		}
		
		override protected function onInit():void
		{
			defineProperty("toSString", 
				new SFunction(function(name:String, params:SArray):SObject {
					return new SString(nValue.toString());
				}));
			
			defineProperty("toSNumber", 
				new SFunction(function(name:String, params:SArray):SObject {
					return new SNumber(nValue);
				}));
			
			defineProperty("toSBoolean", 
				new SFunction(function(name:String, params:SArray):SObject {
					return nValue == 0 ? SBoolean.FALSE : SBoolean.TRUE;
				}));
		}
		
		override public function valueOf():*
		{
			return nValue;
		}
	}
}