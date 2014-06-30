package com.croco2d.utils.tmx.scene
{
	import com.croco2d.scene.CrocoGameObject;
	import com.croco2d.utils.tmx.data.TMXPropertySet;
	import com.fireflyLib.utils.TypeUtility;
	
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	public class TMXEntitiesLayer extends TMXBasicLayer
	{
		public function TMXEntitiesLayer()
		{
			super();
		}
		
		override public function deserialize(xml:XML):void
		{
			super.deserialize(xml);	
			
			initSceneEnetities = [];
			
			var sceneEntity:CrocoGameObject;
			
			var objectXMLs:XMLList = xml.object; 
			for each(var objectXML:XML in objectXMLs)
			{
				sceneEntity = deserializeForTMXObject(objectXML);
				if(sceneEntity)
				{
					initSceneEnetities.push(sceneEntity);
				}
			}
		}

		protected function deserializeForTMXObject(objectXML:XML):CrocoGameObject
		{
			var entityClsType:String;
			var entityCls:Class;
			var entity:CrocoGameObject;
			var entityTMXPropertySet:TMXPropertySet;
			
			if(objectXML.hasOwnProperty("@type"))
			{
				entityClsType = objectXML.@type;
				entityCls = getDefinitionByName(entityClsType) as Class;
				
				entity = new CrocoGameObject();
				entity.type = entityClsType;
				
				entityTMXPropertySet = new TMXPropertySet();
				entityTMXPropertySet.deserialize(objectXML.properties[0]);
				entity.__propertyBag = entityTMXPropertySet;
				
				entity.x = parseInt(objectXML.@x);
				entity.y = parseInt(objectXML.@y);
				
				entity.aabb = new Rectangle(0, 0, parseInt(objectXML.@width), parseInt(objectXML.@height));
				
				if(objectXML.hasOwnProperty("ellipse"))
				{
					entityTMXPropertySet.write("shapeType", "ellipse");
				}
				else if(objectXML.hasOwnProperty("polyline"))
				{
					entityTMXPropertySet.write("shapeType", "polyline");
					entityTMXPropertySet.write("points", deserializeForLinePoints(objectXML.polyline[0]));
				}
				else if(objectXML.hasOwnProperty("polygon"))
				{
					entityTMXPropertySet.write("shapeType", "polygon");
					entityTMXPropertySet.write("points", deserializeForLinePoints(objectXML.polygon[0]));
				}
			}
			
			return null;
		}

//		//object.x,.y...
		protected function deserializeForLinePoints(pointsXML:XML):Array
		{
			var pointsStr:String = pointsXML.@points;
			var pointsStrArr:Array = pointsStr.split(" ");
			
			var pointsLen:int = pointsStrArr.length;
			
			var pointStr:String;
			var pointStrArr:Array;
			
			var point:Object;
			var results:Array = [];
			
			for(var i:int = 0; i < pointsLen; i++)
			{
				pointStr = pointStrArr[i];
				pointStrArr = pointStr.split(",");
				
				results.push(
					{
					x:parseInt(pointStrArr[0]),
					y:parseInt(pointStrArr[1])
				});
			}
			return results;
			
		}
	}
}