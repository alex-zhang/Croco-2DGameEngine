package com.croco2d.utils.tmx.scene.ornaments
{
	import com.croco2d.AppConfig;
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.assets.ImageAsset;
	import com.croco2d.assets.SpriteSheetAsset;
	import com.croco2d.entities.SceneEntity;
	
	import starling.textures.Texture;

	public class OrtRibbonTrailSpriteEntity extends SceneEntity
	{
		public function OrtRibbonTrailSpriteEntity()
		{
			super();
		}
		
		override protected function onInit():void
		{
			//==================================================================
			//tmxPropertityParms：
			//1. assetPath : scene relative path
			//	format ： path/a.png|jpg
			//		     path/a.sprsres:textureNme(纹理集中的纹理名称)
			//
			//==================================================================
		
			//assets
			var assetPath:String = propertyBag.read("assetPath");
			
			var assetsManager:CrocoAssetsManager = scene.screen.screenAssetsManager;
			
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
				var textureAsset:ImageAsset = assetsManager.getImageAsset(assetPath);
				texture = textureAsset.texture;
			}
		}
	}
}