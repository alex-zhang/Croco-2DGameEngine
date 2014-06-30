package com.croco2d.utils.collision
{
	import com.croco2d.core.CrocoObject;
	import com.croco2d.scene.CrocoGameObject;

	public class SpatialCollisionComponent extends CrocoObject
	{
		public var spatialManager:ISpatialCollisionManager;
		
		public function SpatialCollisionComponent()
		{
			super();
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			if(spatialManager)
			{
				spatialManager.addSceneEntity(owner as CrocoGameObject);
			}
		}
		
		override protected function onDeactive():void
		{
			super.onDeactive();
			
			if(spatialManager)
			{
				spatialManager.removeSceneEntity(owner as CrocoGameObject);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			spatialManager = null;
		}
	}
}