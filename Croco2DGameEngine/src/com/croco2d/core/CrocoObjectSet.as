package com.croco2d.core
{
	import com.fireflyLib.utils.UniqueLinkList;

	public class CrocoObjectSet extends CrocoObject
	{
		public static function defaultDepthSortFunction(a:CrocoObject, b:CrocoObject):int
		{
			//-1 means the bottom depth than the other
			return a.sortPriority > b.sortPriority ? 1 : -1;
		}
		
		//--------------------------
		
		//default initChildren.
		public var initChildren:Array = null;
		
		//the sort logic. Default base the sortPriority.
		public var sortFunction:Function = defaultDepthSortFunction;
		
		public var __childrenOrderSortDirty:Boolean = false;
		
		public var __onAddChildCallback:Function = onAddChild;
		public var __onRemoveChildCallback:Function = onRemoveChild;
		public var __childrenLinkList:UniqueLinkList;
		
		public function CrocoObjectSet()
		{
			super();
			
			__childrenLinkList = new UniqueLinkList();
		}

		public function get length():int 
		{ 
			return __childrenLinkList.length;
		}
		
		public function hasChild(item:CrocoObject):Boolean 
		{ 
			return __childrenLinkList.has(item);
		}
		
		public function indexOfChild(item:CrocoObject):int
		{
			return __childrenLinkList.indexOf(item);
		}
		
		public function lastIndexOfChild(item:CrocoObject):int
		{
			return __childrenLinkList.lastIndexOf(item);
		}
		
		public function forEach(callback:Function):void
		{
			var child:CrocoObject = __childrenLinkList.moveFirst();
			while(child)
			{
				callback(child);
				child = __childrenLinkList.moveNext();
			}
		}
		
		public function lastForEach(callback:Function):void
		{
			var child:CrocoObject = __childrenLinkList.moveLast();
			while(child)
			{
				callback(child);
				child = __childrenLinkList.movePre();
			}
		}
		
		croco_internal function moveFirst():CrocoObject
		{
			return __childrenLinkList.moveFirst();
		}
		
		croco_internal function moveLast():CrocoObject
		{
			return __childrenLinkList.moveLast();
		}
		
		croco_internal function moveNext():CrocoObject
		{
			return __childrenLinkList.moveNext();
		}
		
		croco_internal function movePre():CrocoObject
		{
			return __childrenLinkList.movePre();
		}
		
		public function findChildByFilterFunc(filterFunc:Function = null):CrocoObject 
		{
			return __childrenLinkList.findItemByFunction(filterFunc); 
		}
		
		public function findChildrenByFilterFunc(results:Array = null, filterFunc:Function = null):Array 
		{
			return __childrenLinkList.findItemsByFunction(results, filterFunc); 
		}
		
		public function findChildByField(field:String, value:*, filterFunc:Function = null):CrocoObject
		{
			function innerFilterFunc(child:CrocoObject):Boolean
			{
				if(filterFunc != null)
				{
					if(field in child && filterFunc(child))
					{
						return child[field] == value;
					}
				}
				else
				{
					if(field in child)
					{
						return child[field] == value;
					}
				}
			}
			
			return findChildByFilterFunc(innerFilterFunc); 
		}
		
		public function findChildrenByField(field:String, value:*, results:Array = null, filterFunc:Function = null):Array
		{ 
			function innerFilterFunc(child:CrocoObject):Boolean 
			{
				if(filterFunc != null)
				{
					if(field in child && filterFunc(child))
					{
						return child[field] == value;
					}
				}
				else
				{
					if(field in child)
					{
						return child[field] == value;
					}
				}
			}
			
			return findChildrenByFilterFunc(results, innerFilterFunc); 
		}
		
		public function findChildByTypeCls(typeCls:Class, filterFunc:Function = null):CrocoObject
		{
			function innerFilterFunc(child:CrocoObject):Boolean
			{
				if(filterFunc != null)
				{
					if(child is typeCls && filterFunc(child))
					{
						return child;
					}
				}
				else
				{
					if(child is typeCls)
					{
						return child;
					}
				}
			}
			
			return findChildByFilterFunc(filterFunc); 
		}
		
		public function findChildrenByTypeCls(typeCls, results:Array = null, filterFunc:Function = null):Array
		{
			function innerFilterFunc(child:CrocoObject):Boolean
			{
				if(filterFunc != null)
				{
					if(child is typeCls && filterFunc(child))
					{
						return child;
					}
				}
				else
				{
					if(child is typeCls)
					{
						return child;
					}
				}
			}
			
			return findChildrenByFilterFunc(results, innerFilterFunc); 
		}
		
		public function findChildByName(name:String, filterFunc:Function = null):CrocoObject
		{
			return findChildByField("name", name, filterFunc);
		}
		
		public function findChildByType(type:String, filterFunc:Function = null):CrocoObject
		{
			return findChildByField("type", type, filterFunc);
		}
		
		public function findChildrenByType(type:String, results:Array = null, filterFunc:Function = null):Array
		{
			return findChildrenByField("type", type, results, filterFunc);
		}
		
		public function findAllChildren(results:Array = null):Array
		{
			return __childrenLinkList.findAllItems(results);
		}
		
		public function addChild(child:CrocoObject):CrocoObject
		{
			var addedChild:CrocoObject = __childrenLinkList.add(child); 
			if(addedChild)
			{
				__onAddChildCallback(addedChild);
			}

			return addedChild;
		}
		
		protected function onAddChild(child:CrocoObject):void 
		{
		}
		
		public function removeChild(child:CrocoObject, needDispose:Boolean = false):CrocoObject 
		{
			var removedChild:CrocoObject = __childrenLinkList.remove(child);
			if(removedChild)
			{
				__onRemoveChildCallback(child, needDispose);
			}

			return removedChild;
		}
		
		protected function onRemoveChild(child:CrocoObject, needDispose:Boolean = false):void
		{
		}
		
		public final function markChildrenOrderSortDirty():void
		{
			__childrenOrderSortDirty = true;
		}
		
		public final function sortChildrenOrder(compareFunction:Function):void 
		{ 
			__childrenLinkList.sort(compareFunction);
			
			__childrenOrderSortDirty = false;
		}
		
		override protected function onInit():void
		{
			if(initChildren)
			{
				var n:int = initChildren.length;
				for(var i:int = 0; i < n; i++)
				{
					addChild(initChildren[i]);
				}
				
				initChildren = null;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			initChildren = null;
			
			__onAddChildCallback = null;
			__onRemoveChildCallback = null;
			
			if(__childrenLinkList)
			{
				__childrenLinkList.clear();
				__childrenLinkList = null;
			}
		}
		
		override public function toString():String
		{
			var results:String = super.toString() + "\n" +
				"children count: " + length;

			return results;
		}
	}
}