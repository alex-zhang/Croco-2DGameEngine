package com.croco2d.components.script
{
	import com.croco2d.components.GameObjectComponent;
	import com.croco2d.core.GameObject;

	public class ScriptComponent extends GameObjectComponent
	{
		public function ScriptComponent()
		{
			super();

			//default.
			this.name = GameObject.PROP_SCRIPT;
		}
	}
}