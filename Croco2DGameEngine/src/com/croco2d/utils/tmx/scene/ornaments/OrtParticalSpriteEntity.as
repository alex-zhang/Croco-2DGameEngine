package com.croco2d.utils.tmx.scene.ornaments
{
	import com.croco2d.AppConfig;
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.assets.ParticleSetAsset;
	import com.croco2d.components.DisplayComponent;
	import com.croco2d.scene.SceneEntity;
	
	import starling.extensions.PDParticleSystem;

	public class OrtParticalSpriteEntity extends SceneEntity
	{
		public function OrtParticalSpriteEntity()
		{
			super();
		}
		
		override protected function onInit():void
		{
			//==================================================================
			//tmxPropertityParms：
			//1. assetPath : 场景相对路径
			//	format：path/a.parsetres:particleName(粒子纹理名字)
			//
			//==================================================================
			
			//assets
			var assetPath:String = propertyBag.read("assetPath");
			var assetsManager:CrocoAssetsManager = scene.assetsManager;
			
			var particleName:String;
			if(assetPath.indexOf(":"))
			{
				var assetPathArr:Array = assetPath.split(":")
				assetPath = assetPathArr[0];
				particleName = assetPathArr[1];
			}
			
			assetPath = AppConfig.findTargetScenePathResource(scene.name, assetPath);
			var particleSetAsset:ParticleSetAsset = assetsManager.getParticleSetAsset(assetPath);

			var xmlAndTexture:Array = particleName ? 
				particleSetAsset.getParticleConfigByName(particleName) :
				particleSetAsset.getDefaultParticleConfig();
			
			//display
			var particleSystem:PDParticleSystem = new PDParticleSystem(xmlAndTexture[0], xmlAndTexture[1]);
			particleSystem.start();
			
			//display component.
			var displayComponent:DisplayComponent = new DisplayComponent();
			displayComponent.displayObject = particleSystem;
			
			initComponents = [displayComponent];
			
			super.onInit();
		}
	}
}