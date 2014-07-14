package com.croco2d.components.script
{
	import com.croco2d.CrocoEngine;
	import com.fireflyLib.utils.GlobalPropertyBag;
	
	import luaAlchemy.LuaAlchemy;
	
	import starling.core.Starling;

	public class LuaScriptComponent extends ScriptComponent
	{
		public var luaScriptStr:String;
		public var __lua:LuaAlchemy;
		
		public function LuaScriptComponent()
		{
			super();
		}
		
		override protected function onInit():void
		{
			__lua = new LuaAlchemy();
			
			if(!luaScriptStr) 
				throw Error("luaScriptStr is null!");
			
			__lua = new LuaAlchemy();
			__lua.setGlobal("CrocoEngine", CrocoEngine);
			__lua.setGlobal("Starling", Starling);
			__lua.setGlobal("nativeStage", GlobalPropertyBag.stage);
			__lua.setGlobal("starlingStage", Starling.current.stage);
			__lua.setGlobal("this", this);
			
			var runTimeStacks:Array = __lua.doString(luaScriptStr);
			if(runTimeStacks.shift() == false)
			{
				__lua.close();
				__lua = null
				throw new Error("Lua error: " + runTimeStacks.toString());
			}
		}
		
		override protected function onActive():void 
		{
			var runTimeStacks:Array = __lua.callGlobal("onActive");
			if(runTimeStacks.shift() == false)
			{
				__lua.close();
				__lua = null
				throw new Error("Lua error: " + runTimeStacks.toString());
			}
		}
		
		override public function tick(deltaTime:Number):void 
		{
			var runTimeStacks:Array = __lua.callGlobal("tick", deltaTime);
			if(runTimeStacks.shift() == false)
			{
				__lua.close();
				__lua = null
				throw new Error("Lua error: " + runTimeStacks.toString());
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__lua)
			{
				var runTimeStacks:Array = __lua.callGlobal("dispose");
				if(runTimeStacks.shift() == false)
				{
					__lua.close();
					__lua = null
					throw new Error("Lua error: " + runTimeStacks.toString());
				}
			}
		}
	}
}