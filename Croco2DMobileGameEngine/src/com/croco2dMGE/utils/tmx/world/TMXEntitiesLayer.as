package com.croco2dMGE.utils.tmx.world
{
	import com.croco2dMGE.utils.CrocoRect;
	import com.croco2dMGE.utils.tmx.data.TMXPropertySet;
	import com.croco2dMGE.world.SceneObject;
	import com.fireflyLib.utils.TypeUtility;

	public class TMXEntitiesLayer extends TMXBasicLayer
	{
		public function TMXEntitiesLayer()
		{
			super();
		}
		
		protected var mDeserializedEntities:Array;
		
		protected var mTMXEntitiesNameMap:Array;
		
		override protected function onInit():void
		{
			super.onInit();
			
			if(mDeserializedEntities)
			{
				mTMXEntitiesNameMap = [];
				
				var n:int = mDeserializedEntities.length;
				var objectInstance:SceneObject;
				for(var i:int = 0; i < n; i++)
				{
					objectInstance = mDeserializedEntities[i];
					
					if(objectInstance.name && objectInstance.name.length > 0)
					{
						mTMXEntitiesNameMap[objectInstance.name] = objectInstance;
					}
					
					addItem(objectInstance);
				}
				
				mDeserializedEntities = null;
			}
		}
		
		public function getTMXEntityByName(name:String):SceneObject
		{
			return mTMXEntitiesNameMap[name];
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mDeserializedEntities)
			{
				var n:int = mDeserializedEntities.length;
				var objectInstance:SceneObject;
				for(var i:int = 0; i < n; i++)
				{
					objectInstance = mDeserializedEntities[i];
					objectInstance.dispose();
				}
				
				mDeserializedEntities = null;
			}
			
			mTMXEntitiesNameMap = null;
		}
		
		override public function deserialize(xml:XML):void
		{
			super.deserialize(xml);	
			
			mDeserializedEntities = [];
			var objectXMLs:XMLList = xml.object; 
			for each(var objectXML:XML in objectXMLs)
			{
				deserializeForObject(objectXML);
			}
		}
		
		protected function deserializeForObject(objectXML:XML):void
		{
			var objectType:String;
			var objectTypeCls:Class;
			var objectInstance:SceneObject;
			var objectInstancePropertySet:TMXPropertySet;
			var objectVisibleTestRect:CrocoRect;
			
			if(objectXML.hasOwnProperty("@type"))
			{
				objectType = objectXML.@type;
				
				objectTypeCls = TypeUtility.getClassFromName(objectType);
				
				objectInstance = new objectTypeCls();
				objectInstance.type = objectType;
				objectInstance.x = parseInt(objectXML.@x);
				objectInstance.y = parseInt(objectXML.@y);
				objectInstance.visibleTestRect = new CrocoRect(0, 0, parseInt(objectXML.@width), parseInt(objectXML.@height)); 
				
				objectInstancePropertySet = new TMXPropertySet();
				objectInstancePropertySet.deserialize(objectXML.properties[0]);
				objectInstance.propertyBag = objectInstancePropertySet;
				
				if(objectXML.hasOwnProperty("ellipse"))
				{
					objectInstancePropertySet.write("ellipse", true);
				}
				else if(objectXML.hasOwnProperty("polyline"))
				{
					objectInstancePropertySet.write("points", deserializeForPolylinePoints(objectXML.polyline[0]));
				}
				
				mDeserializedEntities.push(objectInstance);
			}
		}
		
		//object.x,.y...
		private function deserializeForPolylinePoints(polylineXML:XML):Array
		{
			var polylinePointsStr:String = polylineXML.@points;
			var polylinePointsStrArr:Array = polylinePointsStr.split(" ");
			
			var pointsLen:int = polylinePointsStrArr.length;
			
			var pointStr:String;
			var pointStrArr:Array;
			
			var point:Object;
			var results:Array = [];
			for(var i:int = 0; i < pointsLen; i++)
			{
				pointStr = polylinePointsStrArr[i];
				pointStrArr = pointStr.split(",");
				
				results.push({
					x:parseInt(pointStrArr[0]),
					y:parseInt(pointStrArr[1])
				});
				
			}
			return results;
			
		}
	}
}