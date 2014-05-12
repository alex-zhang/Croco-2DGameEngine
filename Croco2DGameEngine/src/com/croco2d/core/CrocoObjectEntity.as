package com.croco2d.core
{
	import com.fireflyLib.utils.EventEmitter;
	import com.fireflyLib.utils.PropertyBag;
	import com.llamaDebugger.Logger;
	
	use namespace croco_internal;

	public class CrocoObjectEntity extends CrocoObject
	{
		public static const EVENT_PLUGIN_COMPONENT:String = "pluginComponent";
		public static const EVENT_PLUGOUT_COMPONENT:String = "plugoutComponent";
		public static const EVENT_INIT:String = "init";
		public static const EVENT_ACTIVE:String = "active";
		public static const EVENT_DEACTIVE:String = "deActive";
		
		//----------------------------------------------------------------------
		
		public var initComponents:Array = null;
		public var eventEnable:Boolean = false;

		public var __eventEmitter:EventEmitter;
		public var __propertyBag:PropertyBag = null;
		
		public var __onPluginComponentCallback:Function = onPluginComponent;
		public var __onPlugoutComponentCallback:Function = onPlugoutComponent;

		public var __pluinComponentsGroup:CrocoObjectGroup;
		public var __pluinComponentsNameMap:Array;//name->CrocoObject.

		public function CrocoObjectEntity()
		{
			super();
		}
		
		public function get eventEmitter():EventEmitter
		{
			if(!__eventEmitter) __eventEmitter = new EventEmitter(this);

			return __eventEmitter;
		}
		
		public function get propertyBag():PropertyBag
		{
			if(!__propertyBag) __propertyBag = new PropertyBag();
			
			return __propertyBag;
		}
		
		public function pluginComponent(component:CrocoObject):CrocoObject
		{
			if(!component.name)
			{
				Logger.warn(name, "pluginComponent component must has a name.");
				
				component.name = "component_" + getPluginComponentsCount();				
			}
			
			if(hasPluginComponent(component.name)) throw new Error("pluginComponent: " + component.name + " already exist!");
			
			return __pluinComponentsGroup.addChild(component);
		}
		
		protected function onPluginComponent(component:CrocoObject):void 
		{
			__pluinComponentsNameMap[component.name] = component;
			
			component.parent = __pluinComponentsGroup;
			component.owner = this;
			
			component.init();
			component.active();
			
			__pluinComponentsGroup.markChildrenOrderSortDirty();
			
			if(eventEnable &&　eventEmitter.hasEventListener(EVENT_PLUGIN_COMPONENT))
			{
				eventEmitter.dispatchEvent(EVENT_PLUGIN_COMPONENT, component);
			}
		}
		
		public function plugOutComponent(pluginName:String, needDispose:Boolean = false):CrocoObject
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
			
			if(eventEnable &&　eventEmitter.hasEventListener(EVENT_PLUGOUT_COMPONENT))
			{
				eventEmitter.dispatchEvent(EVENT_PLUGOUT_COMPONENT, component);
			}
			
			if(needDispose)
			{
				component.dispose();
			}
		}
		
		public function markPluginComponentsOrderSortDirty():void
		{
			__pluinComponentsGroup.markChildrenOrderSortDirty();
		}
		
		public function hasPluginComponent(pluginName:String):Boolean
		{
			return Boolean(__pluinComponentsNameMap[pluginName]);
		}
		
		public function hasPluginComponent2(pluinComponent:CrocoObject):Boolean
		{
			return __pluinComponentsGroup.hasChild(pluinComponent);
		}
		
		public function findPluinComponent(pluginName:String):CrocoObject
		{
			return __pluinComponentsNameMap[pluginName] as CrocoObject
		}

		public function getPluginComponentsCount():int
		{
			return __pluinComponentsGroup.length;
		}
		
		public function findPluinComponentByField(field:String, value:*, filterFunc:Function = null):CrocoObject
		{
			return __pluinComponentsGroup.findChildByField(field, value, filterFunc);
		}
		
		public function findPluinComponentsByField(field:String, value:*, results:Array = null, filterFunc:Function = null):Array
		{ 
			return __pluinComponentsGroup.findChildrenByField(field, value, results, filterFunc);
		}
		
		public function findPluinComponentTypeCls(typeCls:Class, filterFunc:Function = null):CrocoObject
		{
			return __pluinComponentsGroup.findChildByTypeCls(typeCls, filterFunc);
		}
		
		public function findPluinComponentsByTypeCls(typeCls, results:Array = null, filterFunc:Function = null):Array
		{
			return __pluinComponentsGroup.findChildrenByTypeCls(typeCls, results, filterFunc);
		}
		
		public function findPluinComponentByFilterFunc(filterFunc:Function = null):CrocoObject 
		{
			return __pluinComponentsGroup.findChildByFilterFunc(filterFunc);
		}
		
		public function findPluinComponentsByFilterFunc(results:Array = null, filterFunc:Function = null):Array 
		{
			return __pluinComponentsGroup.findChildrenByFilterFunc(results, filterFunc);
		}
		
		public function findAllPluinComponents(results:Array = null):Array
		{
			return __pluinComponentsGroup.findAllChildren(results);
		}
		
		public function forEachPluinComponent(callback:Function):void
		{
			__pluinComponentsGroup.forEach(callback);
		}
		
		public function lastForEachPluinComponent(callback:Function):void
		{
			__pluinComponentsGroup.lastForEach(callback);
		}
		
		public function getPluinComponentProperty(pluginName:String, filedName:String):*
		{
			var targetRemovedComponent:CrocoObject = findPluinComponent(pluginName);
			if(!targetRemovedComponent) return undefined;
			
			if(filedName in targetRemovedComponent)
			{
				return targetRemovedComponent[filedName];
			}
			
			return undefined;
		}
		
		public function setPluinComponentProperty(pluginName:String, filedName:String, value:*):void
		{
			var targetRemovedComponent:CrocoObject = findPluinComponent(pluginName);
			if(!targetRemovedComponent) return;
			
			if(filedName in targetRemovedComponent)
			{
				targetRemovedComponent[filedName] = value;
			}
		}
		
		public function callPluinComponentFunc(pluginName:String, funcName:String, args:Array = null):*
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
		
		override protected function onInit():void
		{
			super.onInit();
			
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
			super.onInited();
			
			if(eventEnable && eventEmitter.hasEventListener(EVENT_INIT))
			{
				eventEmitter.dispatchEvent(EVENT_INIT);
			}
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			__pluinComponentsGroup.active();
		}
		
		override protected function onActived():void
		{
			super.onActived();
			
			if(eventEnable && eventEmitter.hasEventListener(EVENT_ACTIVE))
			{
				eventEmitter.dispatchEvent(EVENT_ACTIVE);
			}
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			__pluinComponentsGroup.tick(deltaTime);
		}

		override protected function onDeactive():void
		{
			super.onDeactive();
			
			__pluinComponentsGroup.deactive();
		}
		
		override protected function onDeactived():void
		{
			super.onDeactived();

			if(eventEnable && eventEmitter.hasEventListener(EVENT_DEACTIVE))
			{
				eventEmitter.dispatchEvent(EVENT_DEACTIVE);
			}
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
			
			if(__propertyBag)
			{
				__propertyBag.dispose();
				__propertyBag = null;
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
				"eventEmitter: " + __eventEmitter + "\n" +
				"propertyBag: " + __propertyBag + "\n" +
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