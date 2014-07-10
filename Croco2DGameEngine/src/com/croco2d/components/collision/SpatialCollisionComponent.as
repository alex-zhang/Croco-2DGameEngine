package com.croco2d.components.collision
{
	import com.croco2d.components.GameObjectComponent;

	public class SpatialCollisionComponent extends GameObjectComponent
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
//				spatialManager.addSceneEntity(owner as CrocoGameObject);
			}
		}
		
		override protected function onDeactive():void
		{
			super.onDeactive();
			
			if(spatialManager)
			{
//				spatialManager.removeSceneEntity(owner as CrocoGameObject);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			spatialManager = null;
		}
	}
}