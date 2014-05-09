package com.croco2d.entities
{
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.core.CrocoObjectEntity;
	import com.croco2d.core.CrocoObjectGroup;
	import com.croco2d.screens.CrocoScreen;
	
	import flash.geom.Point;
	
	import starling.core.RenderSupport;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	
	public class CrocoScene extends CrocoObjectEntity
	{
		public static const EVENT_ADD_SCENE_LAYER:String = "addSceneLayer";
		public static const EVENT_REMOVE_SCENE_LAYER:String = "removeSceneLayer";

		public var initSceneLayers:Array;
		
		public var screen:CrocoScreen;
		public var screenAssetsManager:CrocoAssetsManager;

		public var touchAble:Boolean = true;
		public var blendMode:String = BlendMode.AUTO;
		public var alpha:Number = 1.0;
		
		public var __layers:Array;//index->Layer
		public var __layersNameMap:Array;//name->Layer
		public var __layersGroup:CrocoObjectGroup;
		
		public var __onAddSceneLayerCallback:Function = onAddSceneLayer;
		public var __onRemoveSceneLayerCallback:Function = onRemoveSceneLayer;
		public var __onCreateNewSceneLayerCallback:Function = onCreateNewSceneLayer;
		
		public function CrocoScene()
		{
			super();

			//draw able.
			visible = true;
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			__layers = [];
			__layersNameMap = [];
			
			__layersGroup = new CrocoObjectGroup();
			__layersGroup.name = "__layersGroup";
			__layersGroup.initChildren = initSceneLayers;
			__layersGroup.init();
			__layersGroup.visible = true;
			__layersGroup.__onAddChildCallback = __onAddSceneLayerCallback;
			__layersGroup.__onRemoveChildCallback = __onRemoveSceneLayerCallback;
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			__layersGroup.active();
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			if(__layersGroup.tickable)
			{
				__layersGroup.tick(deltaTime);
			}
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			var curAlpha:Number = parentAlpha * alpha;
			var lastBlendMode:String = support.blendMode;
			
			support.blendMode = this.blendMode;
			
			if(__layersGroup.visible)
			{
				__layersGroup.draw(support, curAlpha);
			}
			
			super.draw(support, curAlpha);
			
			support.blendMode = lastBlendMode;
		}
		
		override protected function onDeactive():void
		{
			super.onDeactive();
			
			__layersGroup.deactive();
		}
		
		public final function getLayerByIndex(index:int = 0, allocateIfAbsent:Boolean = false):SceneLayer
		{
			// Maybe it already exists.
			if(__layers[index]) return __layers[index];
			
			if(!allocateIfAbsent) return null;
			
			var sceneLayer:SceneLayer = __onCreateNewSceneLayerCallback(__layers.length);
			
			__layersGroup.addChild(sceneLayer);
			
			return sceneLayer;
		}
		
		public final function getLayerByName(name:String):SceneLayer
		{
			return __layersNameMap[name] as SceneLayer;
		}

		public final function get layerCount():uint
		{
			return __layers ? __layers.length : 0;
		}
		
		public function findAllLayers(results:Array = null):Array
		{
			return __layersGroup.findAllChildren(results);
		}
		
		public function forEachLayer(callback:Function):void
		{
			__layersGroup.forEach(callback);
		}
		
		public function lastForEachLayer(callback:Function):void
		{
			__layersGroup.lastForEach(callback);
		}
		
		protected function onCreateNewSceneLayer(layerIndex:int):SceneLayer
		{
			var layer:SceneLayer = new SceneLayer();
			layer.sortPriority = layerIndex;
			layer.name = "SceneLayer::" + layerIndex;
			
			return layer;
		}
		
		//no remove sceneLayer, no nessary.
		public final function addSceneLayer(sceneLayer:SceneLayer):SceneLayer
		{
			if(__layersNameMap[sceneLayer.name]) throw Error("addSceneLayer:: sceneLayer name: " + sceneLayer.name + " is already exsit!");
			if(__layersNameMap[sceneLayer.sortPriority]) throw Error("addSceneLayer:: sceneLayer sortOrderIndex: " + sceneLayer.sortPriority + " is already exsit!");

			return __layersGroup.addChild(sceneLayer) as SceneLayer;
		}
		
		protected function onAddSceneLayer(sceneLayer:SceneLayer):void
		{
			__layersGroup.markChildrenOrderSortDirty();
			
			sceneLayer.parent = __layersGroup;
			sceneLayer.owner = this;
			sceneLayer.init();
			sceneLayer.active();

			__layers[sceneLayer.sortPriority] = sceneLayer;
			__layersNameMap[sceneLayer.name] = sceneLayer;
			
			if(eventEnable && eventEmitter.hasEventListener(EVENT_ADD_SCENE_LAYER))
			{
				eventEmitter.dispatchEvent(EVENT_ADD_SCENE_LAYER, sceneLayer);
			}
		}
		
		protected function onRemoveSceneLayer(sceneLayer:SceneLayer, needDispose:Boolean = false):void
		{
			if(eventEnable && eventEmitter.hasEventListener(EVENT_REMOVE_SCENE_LAYER))
			{
				eventEmitter.dispatchEvent(EVENT_REMOVE_SCENE_LAYER, sceneLayer);
			}
			
			sceneLayer.deactive();
			
			if(needDispose)
			{
				sceneLayer.dispose();
			}
		}
		
		public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if(forTouch && (!touchAble || !visible)) return null;
			
			//front to back!
			var displayObject:DisplayObject;
			
			var sceneLayer:SceneLayer = __layersGroup.moveLast() as SceneLayer;
			while(sceneLayer)
			{
				if(sceneLayer.__alive)
				{
					displayObject = sceneLayer.hitTest(localPoint, forTouch); 
					
					if(displayObject) return displayObject;
				}
				
				sceneLayer = __layersGroup.movePre() as SceneLayer;
			}

			return null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			initSceneLayers = null;
			
			screen = null;
			screenAssetsManager = null;
			alpha = NaN;
			
			__layers = null;
			__layersNameMap = null;
			
			if(__layersGroup)
			{
				__layersGroup.dispose();
				__layersGroup = null;
			}
			
			__onAddSceneLayerCallback = null;
			__onRemoveSceneLayerCallback = null;
			__onCreateNewSceneLayerCallback = null;
		}
		
		override public function toString():String
		{
			var results:String = super.toString() + "\n" +
				"screen: " + screen + "\n" +
				"touchAble: " + touchAble + "\n" +
				"alpha: " + alpha + 
				"__layersGroup: " + __layersGroup;
			
			return results;
		}
	}
}