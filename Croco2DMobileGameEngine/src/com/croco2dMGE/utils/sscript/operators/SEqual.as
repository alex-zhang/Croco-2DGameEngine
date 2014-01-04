package com.croco2dMGE.utils.sscript.operators
{
	import com.croco2dMGE.utils.sscript.objects.SBoolean;
	import com.croco2dMGE.utils.sscript.objects.SNumber;
	import com.croco2dMGE.utils.sscript.objects.SObject;
	import com.croco2dMGE.utils.sscript.objects.SString;
	import com.croco2dMGE.utils.sscript.objects.SFunction;

	public class SEqual extends SFunction
	{
		public function SEqual()
		{
			super();
		}
		
//		override public function apply(params:Array/*SObject*/):SObject
//		{
//			if(params && params.length == 2)
//			{
//				var item0:SObject = params[0];
//				var item1:SObject = params[1];
//				
//				if(item0 is SBoolean)
//				{
//					if(SBoolean(item0) === item1.toSBoolean())
//					{
//						return SBoolean.TRUE;
//					}
//					else
//					{
//						return SBoolean.FALSE;
//					}
//				}
//				else if(item0 is SString)
//				{
//					if(SString(item0).valueOf() == item1.toSString().valueOf())
//					{
//						return SBoolean.TRUE;
//					}
//					else
//					{
//						return SBoolean.FALSE;
//					}
//				}
//				else if(item0 is SNumber)
//				{
//					if(SNumber(item0).valueOf() == item1.toSNumber().valueOf())
//					{
//						return SBoolean.TRUE;
//					}
//					else
//					{
//						return SBoolean.FALSE;
//					}
//				}
//				else
//				{
//					if(item0 == item1)
//					{
//						return SBoolean.TRUE;
//					}
//					else
//					{
//						return SBoolean.FALSE;
//					}
//				}
//			}
//			
//			throw new Error("params length must be 2");
//		}
	}
}