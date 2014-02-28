package com.croco2d.utils.tmx.scene.ornaments
{
	import com.croco2d.AppConfig;
	import com.croco2d.CrocoEngine;
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.assets.ParticleSetAsset;
	import com.croco2d.entities.SceneEntity;
	
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class OrtParticalSpriteEntity extends SceneEntity
	{
//		public var particleTexture:Texture;
//		
//		protected var mParticleSystem:PDParticleSystem;
//		
//		public function OrtParticalSpriteEntity()
//		{
//			super();
//		}
//		
//		override protected function onInit():void
//		{
//			super.onInit();
//			
//			//==================================================================
//			//参数：
//			//1. assetPath : 场景相对路径
//			//	格式：path/a.parsetres:particleName(粒子纹理名字)
//			//
//			//==================================================================
//			
//			var assetPath:String = propertyBag.read("assetPath");
//			
//			//-
//			
//			var assetsManager:CrocoAssetsManager = scene.screen.screenPreLoadAssetsManager;
//			
//			var particleName:String;
//			if(assetPath.indexOf(":"))
//			{
//				var assetPathArr:Array = assetPath.split(":")
//				assetPath = assetPathArr[0];
//				particleName = assetPathArr[1];
//			}
//			
//			assetPath = AppConfig.findTargetScenePathResource(scene.name, assetPath);
//			var particleSetAsset:ParticleSetAsset = assetsManager.getParticleSetAsset(assetPath);
//
//			var xmlAndTexture:Array = particleName ? 
//				particleSetAsset.getParticleConfigByName(particleName) :
//				particleSetAsset.getDefaultParticleConfig();
//			
//			display = mParticleSystem = new PDParticleSystem(xmlAndTexture[0], xmlAndTexture[1]);
//			
//			mParticleSystem.start();
//		}
//		
//		override public function tick(deltaTime:Number):void
//		{
//			super.tick(deltaTime);
//			
//			if(isValidDisplay)
//			{
//				mParticleSystem.advanceTime(deltaTime);
//			}
//		}
	}
}