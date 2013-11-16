package com.croco2dMGE.extensions.tmx.entities
{
	import com.croco2dMGE.utils.CrocoRect;
	import com.croco2dMGE.world.SceneObject;
	import com.croco2dMGE.extensions.tmx.datas.TMXPropertiesData;

	public class TMXRectCollisionObject extends SceneObject
	{
		public var collisionWidth:int;
		public var collisionHeight:int;
		
		public var propertiesData:TMXPropertiesData;

		public function TMXRectCollisionObject()
		{
			super();
		}
		
		public function deserialize(xml:XML):void
		{
			//base atr
			this.name = xml.@name;
			this.x = parseInt(xml.@x);
			this.y = parseInt(xml.@y);
			
			//properties
			propertiesData = new TMXPropertiesData();
			propertiesData.deserialize(xml.properties[0]);
			
			this.collisionWidth = parseInt(xml.@width);
			this.collisionHeight = parseInt(xml.@height);
		}
		
		override protected function onInit():void
		{
			visibleTestRect = new CrocoRect(0, 0, collisionWidth, collisionHeight);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(propertiesData)
			{
				propertiesData.dispose();
				propertiesData = null;
			}
		}
	}
}