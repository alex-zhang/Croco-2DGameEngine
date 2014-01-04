package com.croco2dMGE.utils.tmx.world.ornaments
{
	import com.croco2dMGE.AppConfig;
	import com.croco2dMGE.graphics.CrocoImage;
	import com.croco2dMGE.utils.CrocoRect;
	import com.croco2dMGE.utils.assets.CrocoAssetsManager;
	import com.croco2dMGE.utils.assets.ImageAsset;
	import com.croco2dMGE.utils.assets.SpriteSheetAsset;
	import com.croco2dMGE.world.SceneEntity;
	
	import starling.textures.Texture;

	public class OrtImageEntity extends SceneEntity
	{
		public var image:CrocoImage;
		
		public function OrtImageEntity()
		{
			super();
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			//==================================================================
			//参数：
			//1. assetPath : 场景相对路径
			//	格式：path/a.png|jpg
			//		path/a.sprsres:textureNme(纹理集中的纹理名称)
			//
			//==================================================================
			
			var assetPath:String = propertyBag.read("assetPath");
			
			//--
			
			var assetsManager:CrocoAssetsManager = scene.screen.screenPreLoadAssetsManager;
			
			var texture:Texture;
			
			if(assetPath.lastIndexOf(CrocoAssetsManager.SPRIT_SHEET_RES_EXTENTION) != -1)
			{
				var assetPathArr:Array = assetPath.split(":");
				assetPath = assetPathArr[0];
				assetPath = AppConfig.findTargetScenePathResource(scene.name, assetPath);
				
				var assetName:String = assetPathArr[1];
				
				var spriteSheetAsset:SpriteSheetAsset = 
					assetsManager.getSpriteSheetAsset(assetPath);
				
				texture = spriteSheetAsset.textureAtlas.getTexture(assetName);
			}
			else
			{
				assetPath = AppConfig.findTargetScenePathResource(scene.name, assetPath);
				
				var textureAsset:ImageAsset = 
					assetsManager.getImageAsset(assetPath);
				
				texture = textureAsset.texture;
			}
			
			display = image = new CrocoImage();
			
			visibleTestRect = new CrocoRect(0, 0, texture.width, texture.height);
			image.texture = texture;
		}
	}
}