package com.croco2dMGE.utils.tmx.data
{
	public class TMXObject extends TMXDataBasic
	{
		public var name:String;
		
		//help for script reflection.
		public var type:String;
		
		//position in pixel uint.
		public var x:int;
		public var y:int;
		
		public var width:int;
		public var height:int;
		
		public var propertySet:TMXPropertySet;
		
		override public function deserialize(xml:XML):void 
		{
			super.deserialize(xml);
			
			name = xml.@name;
			type = xml.@type;
			
			x = parseInt(xml.@x);
			y = parseInt(xml.@y);
			
			width = parseInt(xml.@width);
			height = parseInt(xml.@height);
			
			propertySet = new TMXPropertySet();
			propertySet.deserialize(xml.properties[0]);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}