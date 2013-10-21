package com.tmx.layers
{
	import com.tmx.entities.TMXRectCollisionObject;

	public class TMXRectCollisionLayer extends TMXBasicLayer
	{
		protected var rectCollisionObjects:Array = null;
		
		public function TMXRectCollisionLayer()
		{
			super();
		}

		override public function onActive():void
		{
			//TMXRectCollisionLayer is just a data layer. no tick no draw.
			exists = false;
		}

		override public function deserialize(xml:XML):void
		{
			super.deserialize(xml);
			
			rectCollisionObjects = [];
			var objectXMLs:XMLList = xml.object;
			var rectCollisionObject:TMXRectCollisionObject;
			for each(var objectXML:XML in objectXMLs)
			{
				rectCollisionObject = new TMXRectCollisionObject();
				rectCollisionObject.deserialize(objectXML);
				
				rectCollisionObjects.push(rectCollisionObject);
			}
		}
		
		override protected function onInit():void
		{
			var n:int = rectCollisionObjects ? rectCollisionObjects.length : 0;
			var rectCollisionObject:TMXRectCollisionObject;
			
			for(var i:int = 0; i < n; i++)
			{
				rectCollisionObject = rectCollisionObjects[i];
				this.addItem(rectCollisionObject);
			}
		}
	}
}