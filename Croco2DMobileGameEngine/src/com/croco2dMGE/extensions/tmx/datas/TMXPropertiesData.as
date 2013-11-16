package com.croco2dMGE.extensions.tmx.datas
{
	public class TMXPropertiesData extends TMXBasicData
	{
		protected var mProperties:Object = {};
		
		public function TMXPropertiesData()
		{
			super();
		}
		
		override public function deserialize(xml:XML):void
		{
			if(!xml) return;
			//properties
			var propertiesXMLs:XMLList = xml.property;
			for each(var propertyXML:XML in propertiesXMLs)
			{
				mProperties[propertyXML.@name.toString()] = propertyXML.@value.toString();
			}
		}
		
		public function get(key:String):String 
		{
			return mProperties[key];
		}
		
		public function set(key:String, value:String):void 
		{
			mProperties[key] = value;
		}
		
		public function has(key:String):Boolean
		{
			return mProperties.hasOwnProperty(key);
		}
		
		override public function dispose():void
		{
			mProperties = null;
		}
	}
}