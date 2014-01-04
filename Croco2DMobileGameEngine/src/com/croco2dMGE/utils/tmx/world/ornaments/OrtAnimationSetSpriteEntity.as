package com.croco2dMGE.utils.tmx.world.ornaments
{
	import com.croco2dMGE.AppConfig;
	import com.croco2dMGE.graphics.sprite.AnimationSetSprite;
	import com.croco2dMGE.utils.assets.AnimationSetAsset;
	import com.croco2dMGE.utils.assets.CrocoAssetsManager;
	import com.croco2dMGE.world.SceneEntity;

	public class OrtAnimationSetSpriteEntity extends SceneEntity
	{
		public var animationSetSprite:AnimationSetSprite;
		
		public function OrtAnimationSetSpriteEntity()
		{
			super();
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			//==================================================================
			//参数：
			//1. assetPath : 场景相对路径
			//	格式：path/a.anisetres
			//		path/a.anisetres:animationName
			//		如果后面指定动画名则播放指定动画，否则播放默认第一个动画
			//
			//==================================================================
			
			var assetPath:String = propertyBag.read("assetPath");
			
			//--
			
			var assetsManager:CrocoAssetsManager = scene.screen.screenPreLoadAssetsManager;
			
			var animationName:String;
			if(assetPath.indexOf(":"))
			{
				var assetPathArr:Array = assetPath.split(":")
				assetPath = assetPathArr[0];
				animationName = assetPathArr[1];
			}
			
			assetPath = AppConfig.findTargetScenePathResource(scene.name, assetPath);
			var animationSetAsset:AnimationSetAsset = assetsManager.getAniSetResAsset(assetPath);
			
			display = animationSetSprite =  new AnimationSetSprite();
			
			animationSetSprite.animationSetInfo = animationSetAsset.animationSetInfo;
			
			if(!animationName)
			{
				animationName = animationSetAsset.animationSetInfo.defaultAniamtionName;
			}
			
			animationSetSprite.gotoAndPlay(animationName, true);
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			if(isValidDisplay)
			{
				animationSetSprite.advanceTime(deltaTime);
			}
		}
	}
}