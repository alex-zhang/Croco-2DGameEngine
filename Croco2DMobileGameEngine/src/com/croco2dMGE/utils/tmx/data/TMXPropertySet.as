package com.croco2dMGE.utils.tmx.data
{
	import com.fireflyLib.utils.PropertyBag;

	public class TMXPropertySet extends PropertyBag
	{
		public function deserialize(xml:XML):void 
		{
			if(!xml) return;
			
			//may be none.
			var propertyName:String;
			var propertyValue:String;
			
			var propertyXMlList:XMLList = xml.property;
			
			for each(var propertyXML:XML in propertyXMlList)
			{
				propertyName = propertyXML.@name;
				propertyValue = propertyXML.@value;
				
				this.write(propertyName, propertyValue);
			}
		}
	}
}