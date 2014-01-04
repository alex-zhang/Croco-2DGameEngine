package com.croco2dMGE.utils.sscript.objects
{
	import com.fireflyLib.errors.AbstractMethodError;

	public class SObject
	{
		//key -> SObject
		private var mSProperties:Object = {};

		public function SObject()
		{
			super();
			
			onInit();
		}
		
		protected function onInit():void
		{
			//define the function
			defineProperty("toSString", 
				new SFunction(function(name:String, params:SArray):SObject {
					return new SError("AbstractMethodError: " + name);
				}));
			
			defineProperty("toSNumber", 
				new SFunction(function(name:String, params:SArray):SObject {
					return new SError("AbstractMethodError: " + name);
				}));
			
			defineProperty("toSBoolean", 
				new SFunction(function(name:String, params:SArray):SObject {
					return new SError("AbstractMethodError: " + name);
				}));
		}
		
		//AS call internal
		public function defineProperty(name:String, value:SObject):void
		{
			mSProperties[name] = value;
		}
		
		public function deleteProperty(name:String):void
		{
			delete mSProperties[name];
		}
		
		public function hasProperty(name:String):Boolean
		{
			return mSProperties[name] !== undefined;
		}
		
		public function valueOf():*
		{
			throw new AbstractMethodError("getValue");
		}
		
		public function call(name:String, params:SArray):SObject
		{
			if(hasProperty(name))
			{
				var property:SObject = mSProperties[name];
				
				if(property is SFunction)
				{
					return SFunction(property).call(name, params);
				}
			}
			
			return new SError("function: name( " + name + " ) is not exist!");
		}
	}
}