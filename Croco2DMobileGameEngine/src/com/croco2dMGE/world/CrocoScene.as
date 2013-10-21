package com.croco2dMGE.world
{
	import com.croco2dMGE.core.CrocoListGroup;
	
	import starling.display.DisplayObject;
	
	public class CrocoScene extends CrocoListGroup
	{
		/**
		 * Holds DisplayObjectSceneLayer instances to use for various layers.
		 * That is, if index 3 of layers[] holds an instance of DisplayObjectSceneLayer
		 * or a subclass, then that instance will be used for layer #3.
		 * 
		 * Note this is only considered at layer setup time. Use getLayer() to
		 * get a layer that is being actively used.
		 */
		public var layers:Array;//SceneLayer
		
		protected var mLayers:Array;
		
		public function CrocoScene()
		{
			super();
		}
		
		override protected function onInit():void
		{
			initLayers();
		}
		
		protected function initLayers():void
		{
			mLayers = [];
			var sceneLayer:SceneLayer;
			
			var n:int = layers ? layers.length : 0;
			for(var i:int = 0; i < n; i++)
			{
				sceneLayer = layers[i];
				
				mLayers[i] = sceneLayer;
				
				sceneLayer.layerIndex = i;
				if(!sceneLayer.name) sceneLayer.name = "SceneLayer::" + i;
				addItem(sceneLayer);
			}
		}
		
		public function getLayer(index:int = 0, allocateIfAbsent:Boolean = false):SceneLayer
		{
			// Maybe it already exists.
			if(mLayers[index]) return mLayers[index];
			
			if(allocateIfAbsent == false) return null;
			
			var sceneLayer:SceneLayer = createSceneLayer(index);
			addItem(sceneLayer);
			
			mLayers.splice(index, 0, sceneLayer);
			
			// Return new layer.
			return sceneLayer;
		}
		
		public function get layerCount():uint
		{
			return mLayers ? mLayers.length : 0;
		}
		
		protected function createSceneLayer(layerIndex:int):SceneLayer
		{
			var layer:SceneLayer = new SceneLayer();
			layer.layerIndex = layerIndex;
			layer.name = "SceneLayer::" + layerIndex;
			
			return layer;
		}
		
		public function mouseHitTest(sceneX:Number, sceneY:Number):DisplayObject
		{
			var item:DisplayObject;
			
			var n:int = mLayers.length;
			var sceneLayer:SceneLayer;
			for(var i:int = 0; i < n; i++)
			{
				sceneLayer = mLayers[i];
				
				if(sceneLayer.mouseEnable && 
					sceneLayer.exists && 
					sceneLayer.visible)
				{
					item = sceneLayer.mouseHitTest(sceneX, sceneY);
					if(item) return item;
				}
			}
			
			return null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			mLayers = null;
			layers = null;
		}
	}
}