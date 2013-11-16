package com.croco2dMGE.extensions.tmx.entities
{
	import com.croco2dMGE.graphics.CrocoImage;
	import com.croco2dMGE.utils.CrocoRect;
	import com.croco2dMGE.world.SceneEntity;
	import com.fireflyLib.utils.GlobalPropertyBag;
	import com.croco2dMGE.extensions.tmx.datas.TMXImageData;
	
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
			
//			var texture:Texture = AssetManager(GlobalPropertyBag.get("AssetManager")).getTexture(imageData.path);
//			mBackgroundImage = new CrocoImage();
//			mBackgroundImage.texture = texture;
//			display = mBackgroundImage;
//			
//			visibleTestRect = new CrocoRect(0, 0, texture.width, texture.height);
		}
	}
}