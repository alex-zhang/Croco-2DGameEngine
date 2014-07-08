package com.croco2d.core
{
	import com.fireflyLib.utils.EventEmitter;
	import com.llamaDebugger.Logger;

	public class CrocoObjectEntity extends CrocoObject
	{
		public static const EVENT_PLUGIN_COMPONENT:String = "pluginComponent";
		public static const EVENT_PLUGOUT_COMPONENT:String = "plugoutComponent";
		
		public static const EVENT_INIT:String = "init";
		public static const EVENT_ACTIVE:String = "active";
		public static const EVENT_DEACTIVE:String = "deActive";
		
		//----------------------------------------------------------------------
		
		//controll when call the emitEvent.
		public var eventEnable:Boolean = false;

		public var __eventEmitter:EventEmitter;
		
		public var initComponents:Array = null;
		
		public var __onPluginComponentCallback:Function = onPluginComponent;
		public var __onPlugoutComponentCallback:Function = onPlugoutComponent;

		public var __pluinComponentsGroup:CrocoObjectGroup;
		public var __pluinComponentsNameMap:Array;//name->CrocoObject.

		public function CrocoObjectEntity()
		{
			super();
		}
		
		public final function addEventListener(eventType:String, listener:Function):void
		{
			if(!__eventEmitter) __eventEmitter = new EventEmitter(this);
			__eventEmitter.addEventListener(eventType, listener);
		}
		
		public final function removeEventListener(eventType:String, listener:Function):void
		{
			if(__eventEmitter)
			{
				__eventEmitter.removeEventListener(eventType, listener);
			}
		}
		
		public final function removeEventListeners(eventType:String = null):void
		{
			if(__eventEmitter)
			{
				__eventEmitter.removeEventListeners(eventType);
			}
		}
		
		public final function hasEventListener(eventType:String):Boolean
		{
			if(__eventEmitter)
			{
				return __eventEmitter.hasEventListener(eventType);
			}
			
			return false;
		}
		
		//help for emitEvent.
		public final function dispatchEvent(eventType:String, eventObject:Object = null):void
		{
			if(eventEnable)
			{
				if(__eventEmitter && __eventEmitter.hasEventListener(EVENT_PLUGIN_COMPONENT))
				{
					__eventEmitter.dispatchEvent(eventType, eventObject);
				}
			}
		}
		
		public final function pluginComponent(component:CrocoObject):CrocoObject
		{
			if(!component.name)
			{
				Logger.warn("pluginComponent component must has a name.");
				
				component.name = "component_" + getPluginComponentsCount();				
			}
			
			if(hasPluginComponent(component.name)) throw new Error("pluginComponent: " + component.name + " already exist!");

			return __pluinComponentsGroup.addChild(component);
		}
		
		protected function onPluginComponent(component:CrocoObject):void 
		{
			__pluinComponentsNameMap[component.name] = component;
			
			component.owner = this;
			
			component.init();
			component.active();
			
			__pluinComponentsGroup.markChildrenOrderSortDirty();
			
			dispatchEvent(EVENT_PLUGIN_COMPONENT, component);
		}
		
		public final function plugOutComponent(pluginName:String, needDispose:Boolean = false):CrocoObject
		{
			var targetComponent:CrocoObject = findPluinComponent(pluginName);
			if(targetComponent)
			{
				return __pluinComponentsGroup.removeChild(targetComponent, needDispose);
			}

			return null;
		}
		
		protected function onPlugoutComponent(component:CrocoObject, needDispose:Boolean = false):void
		{
			delete __pluinComponentsNameMap[component.name];
			
			component.deactive();
			
			dispatchEvent(EVENT_PLUGOUT_COMPONENT, component);

			if(needDispose) component.dispose();
		}
		
		public final function markPluginComponentsOrderSortDirty():void
		{
			__pluinComponentsGroup.markChildrenOrderSortDirty();
		}
		
		public final function hasPluginComponent(pluginName:String):Boolean
		{
			return Boolean(__pluinComponentsNameMap[pluginName]);
		}
		
		public final function hasPluginComponent2(pluinComponent:CrocoObject):Boolean
		{
			return __pluinComponentsGroup.hasChild(pluinComponent);
		}
		
		public final function findPluinComponent(pluginName:String):CrocoObject
		{
			return __pluinComponentsNameMap[pluginName] as CrocoObject
		}

		public final function getPluginComponentsCount():int
		{
			return __pluinComponentsGroup.length;
		}
		
		public final function findPluinComponentByField(field:String, value:*, filterFunc:Function = null):CrocoObject
		{
			return __pluinComponentsGroup.findChildByField(field, value, filterFunc);
		}
		
		public final function findPluinComponentsByField(field:String, value:*, results:Array = null, filterFunc:Function = null):Array
		{ 
			return __pluinComponentsGroup.findChildrenByField(field, value, results, filterFunc);
		}
		
		public final function findPluinComponentsByTypeCls(typeCls, results:Array = null, filterFunc:Function = null):Array
		{
			return __pluinComponentsGroup.findChildrenByTypeCls(typeCls, results, filterFunc);
		}
		
		public final function findPluinComponentByFilterFunc(filterFunc:Function = null):CrocoObject 
		{
			return __pluinComponentsGroup.findChildByFilterFunc(filterFunc);
		}
		
		public final function findPluinComponentsByFilterFunc(results:Array = null, filterFunc:Function = null):Array 
		{
			return __pluinComponentsGroup.findChildrenByFilterFunc(results, filterFunc);
		}
		
		public final function findAllPluinComponents(results:Array = null):Array
		{
			return __pluinComponentsGroup.findAllChildren(results);
		}
		
		public final function forEachPluinComponent(callback:Function):void
		{
			__pluinComponentsGroup.forEach(callback);
		}
		
		public final function lastForEachPluinComponent(callback:Function):void
		{
			__pluinComponentsGroup.lastForEach(callback);
		}
		
		public final function setPluinComponentProperty(pluginName:String, filedName:String, value:*):void
		{
			var targetRemovedComponent:CrocoObject = findPluinComponent(pluginName);
			if(!targetRemovedComponent) return;
			
			if(filedName in targetRemovedComponent)
			{
				targetRemovedComponent[filedName] = value;
			}
		}
		
		public final function hasPluinComponentProperty(pluginName:String, filedName:String):Boolean
		{
			var targetRemovedComponent:CrocoObject = findPluinComponent(pluginName);
			if(!targetRemovedComponent) return false;
			
			if(filedName in targetRemovedComponent && !(targetRemovedComponent[filedName] is Function))
			{
				return true;
			}
			
			return false;
		}
		
		public final function callPluinComponentFunc(pluginName:String, funcName:String, args:Array = null):*
		{
			var targetRemovedComponent:CrocoObject = findPluinComponent(pluginName);
			if(!targetRemovedComponent) return;
			
			if(funcName in targetRemovedComponent)
			{
				var f:Function = targetRemovedComponent[funcName] as Function;
				if(f)
				{
					return f.apply(null, args);
				}
			}
			
			return undefined;
		}
		
		public final function hasPluinComponentFunc(pluginName:String, funcName:String):Boolean
		{
			var targetRemovedComponent:CrocoObject = findPluinComponent(pluginName);
			if(!targetRemovedComponent) return false;
			
			if(funcName in targetRemovedComponent && (targetRemovedComponent[funcName] is Function))
			{
				return true;
			}
			
			return false;
		}
		
		override protected function onInit():void
		{
			__pluinComponentsNameMap = [];
			
			__pluinComponentsGroup = new CrocoObjectGroup();
			__pluinComponentsGroup.name = "__pluinComponentsGroup";
			__pluinComponentsGroup.initChildren = initComponents;
			__pluinComponentsGroup.__onAddChildCallback = __onPluginComponentCallback;
			__pluinComponentsGroup.__onRemoveChildCallback = __onPlugoutComponentCallback;
			__pluinComponentsGroup.init();
			
			initComponents = null;
		}
		
		override protected function onInited():void
		{
			dispatchEvent(EVENT_INIT);
		}
		
		override protected function onActive():void
		{
			__pluinComponentsGroup.active();
		}
		
		override protected function onActived():void
		{
			dispatchEvent(EVENT_ACTIVE);
		}
		
		override public function tick(deltaTime:Number):void
		{
			__pluinComponentsGroup.tick(deltaTime);
		}

		override protected function onDeactive():void
		{
			__pluinComponentsGroup.deactive();
		}
		
		override protected function onDeactived():void
		{
			dispatchEvent(EVENT_DEACTIVE);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			initComponents = null;
			
			if(__eventEmitter)
			{
				__eventEmitter.dispose();
				__eventEmitter = null;
			}
			
			__onPluginComponentCallback = null;
			__onPlugoutComponentCallback = null;
			
			if(__pluinComponentsGroup)
			{
				__pluinComponentsGroup.dispose();
				__pluinComponentsGroup = null;
			}
			
			__pluinComponentsNameMap = null;
		}
		
		override public function toString():String
		{
			var results:String = super.toString() + "\n" +
				"eventEnable: " + eventEnable + "\n" +
				"__pluinComponentsGroup: " + __pluinComponentsGroup + "\n";
				
				__pluinComponentsGroup.forEach(
					function(item:CrocoObject):void
					{
						results += item + "\n";
					});

			return results;
		}
	}
}