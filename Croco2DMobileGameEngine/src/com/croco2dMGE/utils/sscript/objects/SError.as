package com.croco2dMGE.utils.sscript.objects
{
	public class SError extends SObject
	{
		public function SError(value:String)
		{
			super();
			
			defineProperty("text", new SString(value));
		}
	}
}