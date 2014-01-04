package com.croco2dMGE.utils.sscript.objects
{
	public class SFunction extends SObject
	{
		private var mValue:Function;
		
		public function SFunction(value:Function = null)
		{
			super();
			
			mValue = value;
		}
		
		override public function call(name:String, params:SArray):SObject
		{
			if(mValue != null)
			{
				return mValue(name, params);
			}
			
			return SNULL.NULL;
		}
	}
}