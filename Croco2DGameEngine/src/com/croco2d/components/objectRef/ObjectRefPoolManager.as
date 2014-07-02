package com.croco2d.components.objectRef
{
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.CrocoObjectGroup;

	public class ObjectRefPoolManager extends CrocoObject
	{
		public var initObjectRefPools:Array = null;
		
		public var __objectRefPoolsGroup:CrocoObjectGroup;
		public var __objectRefPoolsNameMap:Array;//name->ObjectReferencePool.
		
		public function ObjectRefPoolManager()
		{
			super();
		}

		public function get length():int 
		{ 
			return __objectRefPoolsGroup.length; 
		}
		
		public function hasObjectRefPool(name:String):Boolean
		{
			return Boolean(__objectRefPoolsNameMap[name]);
		}
		
		public function findObjectRefPool(name:String):ObjectRefPool
		{
			return __objectRefPoolsNameMap[name] as ObjectRefPool;
		}
		
		public function addObjectRefPool(objectRefPool:ObjectRefPool):ObjectRefPool
		{
			if(!objectRefPool.name) throw new Error("ObjectRefPoolManager::addObjectRefPool target must has a name.");
			if(hasObjectRefPool(objectRefPool.name)) throw new Error("ObjectRefPoolManager::addObjectRefPool " + objectRefPool.name + " already exist!");
			
			return __objectRefPoolsGroup.addChild(objectRefPool) as ObjectRefPool;
		}
		
		protected function onAddObjectRefPool(objectRefPool:ObjectRefPool):void 
		{
			__objectRefPoolsNameMap[objectRefPool.name] = objectRefPool;
			
			objectRefPool.parent = __objectRefPoolsGroup;
			objectRefPool.owner = this;
			
			objectRefPool.init();
			objectRefPool.active();
		}
		
		public function removeObjectPool(name:String, needDispose:Boolean = false):ObjectRefPool
		{
			var targetObjectReferPool:ObjectRefPool = findObjectRefPool(name);
			if(targetObjectReferPool)
			{
				return __objectRefPoolsGroup.removeChild(targetObjectReferPool, needDispose) as ObjectRefPool;
			}
			
			return null;
		}
		
		protected function onRemoveObjectRefPool(objectReferencePool:ObjectRefPool, needDispose:Boolean = false):void 
		{
			delete __objectRefPoolsNameMap[objectReferencePool.name];
			
			objectReferencePool.deactive();
			
			if(needDispose)
			{
				objectReferencePool.dispose();
			}
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			__objectRefPoolsNameMap = [];
			
			__objectRefPoolsGroup = new CrocoObjectGroup();
			__objectRefPoolsGroup.name = "__objectRefPoolsGroup";
			__objectRefPoolsGroup.initChildren = initObjectRefPools;
			__objectRefPoolsGroup.__onAddChildCallback = onAddObjectRefPool;
			__objectRefPoolsGroup.__onRemoveChildCallback = onRemoveObjectRefPool;
			
			initObjectRefPools = null;
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			__objectRefPoolsGroup.active();
		}
		
		override public function tick(deltaTime:Number):void
		{
			__objectRefPoolsGroup.tick(deltaTime);
		}
		
		override protected function onDeactive():void
		{
			super.onDeactive();
			
			__objectRefPoolsGroup.deactive();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			initObjectRefPools = null;
			
			if(__objectRefPoolsGroup)
			{
				__objectRefPoolsGroup.dispose();
				__objectRefPoolsGroup = null;
			}
			
			__objectRefPoolsNameMap = null;
		}
	}
}