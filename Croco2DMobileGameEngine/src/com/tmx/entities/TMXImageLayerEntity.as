package com.tmx.entities
{
	import com.croco2dMGE.graphics.CrocoImage;
	import com.croco2dMGE.utils.CrocoRect;
	import com.croco2dMGE.world.SceneEntity;
	import com.fireflyLib.core.SystemGlobal;
	import com.tmx.datas.TMXImageData;
	
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	public class TMXImageLayerEntity extends SceneEntity
	{
		public var backgroundImageCls:Class;
		public var imageData:TMXImageData;
		
		protected var mBackgroundImage:CrocoImage;
		
		public function TMXImageLayerEntity()
		{
			super();
		}
		
		override protected function onInit():void
		{
			backgroundImageCls ||= CrocoImage;
			
			var texture:Texture = AssetManager(SystemGlobal.get("AssetManager")).getTexture(imageData.path);
			mBackgroundImage = new CrocoImage(texture.width, texture.height);
			mBackgroundImage.texture = texture;
			mDisplayObject = mBackgroundImage;
			
			visibleTestRect = new CrocoRect(0, 0, texture.width, texture.height);
		}
	}
}