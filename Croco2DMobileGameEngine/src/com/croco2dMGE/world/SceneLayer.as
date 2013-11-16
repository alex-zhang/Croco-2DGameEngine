package com.croco2dMGE.world
{
	import com.croco2dMGE.core.CrocoBasic;
	import com.croco2dMGE.core.CrocoGroup;
	import com.croco2dMGE.core.CrocoListGroup;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	
	public class SceneLayer extends CrocoListGroup
	{
		public static function defaultDepthSortFunction(a:SceneEntity, b:SceneEntity):int
		{
			//-1 means the top depth than the other
			if(a.layerIndex > b.layerIndex) return -1;
			else if(a.layerIndex < b.layerIndex) return 1;
			else//相等时
			{
				if(a.y > b.y) return 1;
				else if(a.y < b.y) return -1;
				else//相等时
				{
					//左边的排在下面
					if(a.x > b.x) return 1;
					else if(a.x < b.x) return -1;
					{
						if(a.zFighting > b.zFighting) return 1;
						else if(a.zFighting < b.zFighting) return -1;
						else
						{
							a.zFighting++;
							return 1;
						}
					}
				}
			}
		}
		
		public var layerIndex:int = 0;
		public var needDepthsort:Boolean = true;
		public var needRealTimeDepthSort:Boolean = false;
		public var depthSortFunction:Function = null;
		public var layerAlpha:Number = 1.0;
		public var touchAble:Boolean = false;
		
		/**
		 * A point that can store numbers from 0 to 1 (for X and Y independently)
		 * that governs how much this object is affected by the camera subsystem.
		 * 0 means it never moves, like a HUD element or far background graphic.
		 * 1 means it scrolls along a the same speed as the foreground layer.
		 * scrollFactor is initialized as (1,1) by default.
		 */
		
		public var scrollFactorX:Number = 1.0;

		public var scrollFactorY:Number = 1.0;
		
		/**
		 * Set to true when we need to resort the layer. 
		 */
		protected var mDepthSortDirty:Boolean = false;
		
		public function SceneLayer()
		{
			super();
			
			this.name = "SceneLayer";
		}
		
		public function markDepthDirty():void
		{
			mDepthSortDirty = true;
		}
		
		//collision
		public function hitTest(pointX:Number, pointY:Number):DisplayObject
		{
			var item:SceneEntity = myItems.moveFirst() as SceneEntity;
			while(item)
			{
				if(item.exists && item.visible &&
					item.touchAble &&
					item.display && 
					item.display.hasVisibleArea && 
					item.isOverlapPoint(pointX, pointY))
				{
					return item.display;
				}
				
				item = myItems.moveNext() as SceneEntity;
			}
			
			return null;
		}
		
		public function queryItemsIsOverlapPoint(pointX:Number, pointY:Number, 
											isOneQuery:Boolean = false, 
											filterCallback:Function = null):Array
		{
			var results:Array = [];
			
			var item:SceneObject = myItems.moveFirst();
			while(item)
			{
				if(item.isOverlapPoint(pointX, pointY) && 
					(filterCallback == null || filterCallback(item)))
				{
					results.push(item);
					
					if(isOneQuery) return results;
				}
				
				item = myItems.moveNext();
			}
			
			return results;
		}
		
		public function queryItemIsOverlapRect(rectX:Number, rectY:Number, 
											   rectWidth:Number, rectHeight:Number,
											   isOneQuery:Boolean = false, 
											   filterCallback:Function = null):Array
		{
			var results:Array = [];
			
			var item:SceneObject = myItems.moveFirst();
			while(item)
			{
				if(item.isOverlapRect(rectX, rectY, rectWidth, rectHeight) && 
					(filterCallback == null || filterCallback(item)))
				{
					results.push(item);
					
					if(isOneQuery) return results;
				}
				
				item = myItems.moveNext();
			}
			
			return results;
		}
		
		public function queryItemsIsOverlapCircle(circleCenterX:Number, 
												  circleCenterY:Number, 
												  circleRadius:Number,
												  isOneQuery:Boolean = false, 
												  filterCallback:Function = null):Array
		{
			var results:Array = [];
			
			var item:SceneObject = myItems.moveFirst();
			while(item)
			{
				if(item.isOverlapCircle(circleCenterX, circleCenterY, circleRadius) && 
					(filterCallback == null || filterCallback(item)))
				{
					results.push(item);
					
					if(isOneQuery) return results;
				}
				
				item = myItems.moveNext();
			}
			
			return results;
		}
		
		public function queryItemsIsOverlapItem(object:SceneObject,
												isOneQuery:Boolean = false, 
												filterCallback:Function = null):Array
		{
			var results:Array = [];
			
			var item:SceneObject = myItems.moveFirst();
			while(item)
			{
				if(item.isOverlapSceneObject(object) && 
					(filterCallback == null || filterCallback(item)))
				{
					results.push(item);
					
					if(isOneQuery) return results;
				}
				
				item = myItems.moveNext();
			}
			
			return results;
		}

		override protected function onInit():void
		{
			depthSortFunction ||= defaultDepthSortFunction;
		}

		override protected function onItemAdded(item:CrocoBasic):void
		{
			super.onItemAdded(item);
			
			var scenecObject:SceneObject = SceneObject(item);
			scenecObject.scrollFactorX = scrollFactorX;
			scenecObject.scrollFactorY = scrollFactorY;
			
			markDepthDirty();
		}
		
		override protected function onItemSwitchFrom(item:CrocoBasic, from:CrocoGroup, target:CrocoGroup):void 
		{
			var scenecObject:SceneObject = SceneObject(item);
			scenecObject.scrollFactorX = scrollFactorX;
			scenecObject.scrollFactorY = scrollFactorY;
		}
		
		//Override the super destroy behavior.
		override public function dispose():void
		{
			super.dispose();
			
			depthSortFunction = null;
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(needDepthsort && 
				(needRealTimeDepthSort || mDepthSortDirty)) updateDepthSort();
			
			super.draw(support, parentAlpha * layerAlpha);
		}
		
		protected function updateDepthSort():void
		{
			mDepthSortDirty = false;
			
			sortItems(depthSortFunction);
		}
	}
}