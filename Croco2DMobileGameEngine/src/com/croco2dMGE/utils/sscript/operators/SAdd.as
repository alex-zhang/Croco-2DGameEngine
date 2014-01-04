package com.croco2dMGE.utils.sscript.operators
{
	import com.croco2dMGE.utils.sscript.objects.SError;
	import com.croco2dMGE.utils.sscript.objects.SFunction;
	import com.croco2dMGE.utils.sscript.objects.SNumber;
	import com.croco2dMGE.utils.sscript.objects.SObject;
	import com.croco2dMGE.utils.sscript.objects.SString;

	public class SAdd extends SFunction
	{
//		override public function apply(params:Array/*SObject*/):SObject
//		{
//			if(params && params.length)
//			{
//				var i:int = 0;
//				var n:int = params.length;
//				var item:SObject;
//				
//				if(params[0] is SNumber)
//				{
//					var resultNumberValue:Number = 0.0;
//					
//					for(i = 0; i < n; i++)
//					{
//						item = params[i];
//						item = item.toSNumber();
//						
//						resultNumberValue += item.valueOf();
//					}
//					
//					return new SNumber(resultNumberValue);
//				}
//				else//SString
//				{
//					var resultStringValue:String = "";
//					
//					for(i = 0; i < n; i++)
//					{
//						item = params[i];
//						item = item.toSString();
//						
//						resultStringValue += item.valueOf();
//					}
//				}
//				
//				return new SString(resultStringValue);
//			}
//			else
//			{
//				throw new SError("params length is 0");
//			}
//		}
	}
}