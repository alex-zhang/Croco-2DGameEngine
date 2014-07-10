package com.croco2d.components
{
	import com.croco2d.components.collision.SpatialCollisionComponent;
	import com.croco2d.components.physics.ColliderComponent;
	import com.croco2d.components.physics.PhysicsSpaceComponent;
	import com.croco2d.components.physics.RigidbodyComponent;
	import com.croco2d.components.render.RenderComponent;
	import com.croco2d.components.script.ScriptComponent;
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.GameObject;

	//just help for coding get.
	public class GameObjectComponent extends CrocoObject
	{
		public function GameObjectComponent()
		{
			super();
		}
		
		public final function get gameObject():GameObject
		{
			return owner as GameObject;
		}
		
		public final function get transform():TransformComponent
		{
			return gameObject.transform;
		}
		
		public final function get render():RenderComponent
		{
			return gameObject.render;
		}
		
		public final function get spatialCollision():SpatialCollisionComponent
		{
			return gameObject.spatialCollision;
		}
		
		public final function get physicsSpace():PhysicsSpaceComponent
		{
			return gameObject.physicsSpace;
		}
		
		public final function get rigidbody():RigidbodyComponent
		{
			return gameObject.rigidbody;
		}
		
		public final function get collider():ColliderComponent
		{
			return gameObject.collider;
		}
		
		public final function get cameraRender():RenderComponent
		{
			return gameObject.cameraRender;
		}
		
		public final function get script():ScriptComponent
		{
			return gameObject.script;
		}
	}
}