package com.croco2d.utils.tmx.scene.ornaments
{
	import com.croco2d.AppConfig;
	import com.croco2d.assets.AnimationSetAsset;
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.assets.SpriteSheetAsset;
	import com.croco2d.components.DisplayComponent;
	import com.croco2d.display.animationSprite.AnimationInfo;
	import com.croco2d.display.animationSprite.AnimationSetInfo;
	import com.croco2d.display.animationSprite.AnimationSprite;
	import com.croco2d.display.animationSprite.FrameInfo;
	import com.croco2d.scene.SceneEntity;
	
	import starling.textures.Texture;

	public class OrtAnimationSpriteEntity extends SceneEntity
	{
		public function OrtAnimationSpriteEntity()
		{
			super();
		}
		
		override protected function onInit():void
		{
			//==================================================================
			//tmxPropertityParms：
			//1. assetPath : scene relative path
			//	 format： path/a.sprsres:animationNamePrix(这里指定名称前缀即可,比如叫fly_的纹理集)
			//		     path/a.anisetres:animationName(注意这种格式的注册点在模型定义里面, 而上面这种注册点在0，0位置)
			//
			//2.fps: 动画帧频 （如果不指定默认24或a.anisetres里面设置的帧频）
			//
			//==================================================================
			
			//assets
			var assetPath:String = propertyBag.read("assetPath");
			var fps:Number = int(parseInt(propertyBag.read("fps")));//default
			
			var assetsManager:CrocoAssetsManager = scene.assetsManager;
			
			var animationName:String;
			var assetPathArr:Array;
			
			var frames:Vector.<FrameInfo>;
			
			assetPathArr = assetPath.split(":");
			assetPath = assetPathArr[0];
			animationName = assetPathArr[1];
			
			assetPath = AppConfig.findTargetScenePathResource(scene.name, assetPath);
			
			var pivotX:Number = 0;
			var pivotY:Number = 0;
			
			if(assetPath.lastIndexOf(CrocoAssetsManager.SPRIT_SHEET_EXTENTION) != -1)
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
			else if(assetPath.lastIndexOf(CrocoAssetsManager.ANIMATION_SET_EXTENTION) != -1)
			{
				var animationSetAsset:AnimationSetAsset = assetsManager.getAniSetResAsset(assetPath);
				
				var animationSetInfo:AnimationSetInfo = animationSetAsset.animationSetInfo;
				var animationInfo:AnimationInfo = animationSetInfo.getAnimationInfoByName(animationName);
				
				frames = animationInfo.getFrames();
				
				pivotX = animationSetInfo.pivotX;
				pivotY = animationSetInfo.pivotY;
				
				if(fps <= 0) fps = animationInfo.frameRate;
			}
			
			//display
			var animationSprite:AnimationSprite = new AnimationSprite();
			animationSprite.pivotX = pivotX;
			animationSprite.pivotY = pivotY;
			animationSprite.frames = frames;
			animationSprite.fps = fps;
			animationSprite.loop = true;
			animationSprite.play();
			
			//display component.
			var displayComponent:DisplayComponent = new DisplayComponent();
			displayComponent.displayObject = animationSprite;
			
			initComponents = [displayComponent];
			
			super.onInit();
		}
	}
}