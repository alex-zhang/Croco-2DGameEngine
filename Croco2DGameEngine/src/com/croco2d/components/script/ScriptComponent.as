package com.croco2d.components.script
{
	import com.croco2d.core.GameObject;
	import com.croco2d.core.CrocoObject;

	public class ScriptComponent extends CrocoObject
	{
		public function ScriptComponent()
		{
			super();
			
			//default.
			this.name = GameObject.PROP_SCRIPT;
		}
	}
}