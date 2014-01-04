package com.croco2dMGE.utils.sscript.operators
{
	import com.croco2dMGE.utils.sscript.objects.SArray;
	import com.croco2dMGE.utils.sscript.objects.SError;
	import com.croco2dMGE.utils.sscript.objects.SFunction;
	import com.croco2dMGE.utils.sscript.objects.SNumber;
	import com.croco2dMGE.utils.sscript.objects.SObject;
	import com.croco2dMGE.world.SceneObject;

	public class SParseFloat extends SFunction
	{
		override public function call(name:String, params:SArray):SObject
		{
//			if(params && params.length)
//			{
//				var item:SObject = SObject(params[0]);
//				return new SNumber(parseFloat(item.valueOf()));
//			}
			
			throw new SError("params length is 0");
		}
	}
}