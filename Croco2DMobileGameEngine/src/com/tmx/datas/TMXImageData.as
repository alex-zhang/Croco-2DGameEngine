package com.tmx.datas
{
	public class TMXImageData extends TMXBasicData
	{
		public var path:String;
		
		public var width:int = 0;
		public var height:int = 0;
		
		public var editorPath:String;
		
		override public function deserialize(xml:XML):void
		{
			editorPath = xml.@source;
			
			//opt
			width = parseInt(xml.@width);
			height = parseInt(xml.@height);
		}
		
		override public function dispose():void
		{
			path = null;
			editorPath = null;
		}
	}
}