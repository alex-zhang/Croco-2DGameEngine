package com.croco2d.components.collision
{
	import com.croco2d.components.GameObjectComponent;

	public class SpatialCollisionComponent extends GameObjectComponent
	{
		public var spatialManager:ISpatialCollisionManager;
		
		public function SpatialCollisionComponent()
		{
			super();

			tickable = false;
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			if(spatialManager)
			{
				spatialManager.addSpatialCollisionComponent(this);
			}
		}
		
		override protected function onDeactive():void
		{
			super.onDeactive();

			if(spatialManager)
			{
				spatialManager.removeSpatialCollisionComponent(this);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			spatialManager = null;
		}
	}
}