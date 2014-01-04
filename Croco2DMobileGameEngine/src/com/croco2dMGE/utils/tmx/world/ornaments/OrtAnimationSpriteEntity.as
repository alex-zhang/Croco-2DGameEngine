package com.croco2dMGE.utils.tmx.world.ornaments
{
	import com.croco2dMGE.AppConfig;
	import com.croco2dMGE.graphics.sprite.AnimationInfo;
	import com.croco2dMGE.graphics.sprite.AnimationSetInfo;
	import com.croco2dMGE.graphics.sprite.AnimationSprite;
	import com.croco2dMGE.graphics.sprite.FrameInfo;
	import com.croco2dMGE.utils.assets.AnimationSetAsset;
	import com.croco2dMGE.utils.assets.CrocoAssetsManager;
	import com.croco2dMGE.utils.assets.SpriteSheetAsset;
	import com.croco2dMGE.world.SceneEntity;
	
	import starling.textures.Texture;

	public class OrtAnimationSpriteEntity extends SceneEntity
	{
		public var animationSprite:AnimationSprite;
		
		public function OrtAnimationSpriteEntity()
		{
			super();
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			//==================================================================
			//参数：
			//1. assetPath : 场景相对路径
			//	格式：path/a.sprsres:animationNamePrix(这里指定名称前缀即可,比如叫fly_的纹理集)
			//		path/a.anisetres:animationName(注意这种格式的注册点在模型定义里面, 而上面这种注册点在0，0位置)
			//
			//2.fps: 动画帧频 （如果不指定默认24或a.anisetres里面设置的帧频）
			//
			//==================================================================
			
			var assetPath:String = propertyBag.read("assetPath");
			var fps:Number = int(parseInt(propertyBag.read("fps")));//default
			
			//--
			
			var assetsManager:CrocoAssetsManager = scene.screen.screenPreLoadAssetsManager;
			
			var animationName:String;
			var assetPathArr:Array;
			
			var frames:Vector.<FrameInfo>;
			
			assetPathArr = assetPath.split(":");
			assetPath = assetPathArr[0];
			animationName = assetPathArr[1];
			
			assetPath = AppConfig.findTargetScenePathResource(scene.name, assetPath);
			
			display = animationSprite = new AnimationSprite();
			
			if(assetPath.lastIndexOf(CrocoAssetsManager.SPRIT_SHEET_RES_EXTENTION) != -1)
			{
				var spriteSheetAsset:SpriteSheetAsset = assetsManager.getSpriteSheetAsset(assetPath);
				
				var textures:Vector.<Texture> = spriteSheetAsset.textureAtlas.getTextures(animationName);
				frames = new Vector.<FrameInfo>();
				
				var frameInfo:FrameInfo;
				var texture:Texture;
				var n:int = textures ? textures.length : 0;
				for(var i:int = 0; i < n; i++)
				{
					texture = textures[i];
					frameInfo = new FrameInfo();
					frameInfo.frame = (i + 1);
					frameInfo.texture = texture;
					
					frames.push(frameInfo);
				}
				
				if(fps <= 0) fps = 24;
			}
			else if(assetPath.lastIndexOf(CrocoAssetsManager.ANIMATION_SET_RES_EXTENTION) != -1)
			{
				var animationSetAsset:AnimationSetAsset = assetsManager.getAniSetResAsset(assetPath);
				
				var animationSetInfo:AnimationSetInfo = animationSetAsset.animationSetInfo;
				var animationInfo:AnimationInfo = animationSetInfo.getAnimationInfoByName(animationName);
				
				frames = animationInfo.getFrames();
				
				animationSprite.pivotX = animationSetInfo.pivotX;
				animationSprite.pivotY = animationSetInfo.pivotY;
				
				if(fps <= 0)
				{
					fps = animationInfo.frameRate;
				}
			}
			
			animationSprite.frames = frames;
			animationSprite.fps = fps;
			animationSprite.loop = true;
			animationSprite.play();
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			if(isValidDisplay)
			{
				animationSprite.advanceTime(deltaTime);
			}
		}
	}
}