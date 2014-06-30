package com.croco2d.utils.tmx.scene.ornaments
{
	import com.croco2d.AppConfig;
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.assets.SoundAsset;
	import com.croco2d.components.DistanceSoundComponent;
	import com.croco2d.scene.CrocoGameObject;
	import com.croco2d.sound.SoundManager;

	public class OrtSurroundingSoundEntity extends CrocoGameObject
	{
		private var mIsSoundPlaying:Boolean = false;

		public function OrtSurroundingSoundEntity()
		{
			super();
			
			visible = false;
		}
		
		override protected function onInit():void
		{
			//==================================================================
			//tmxPropertityParms：
			//1. assetPath : 场景相对路径
			//	format：path/a.mp3
			//
			//说明：声音半径即为声音宽度的一半，建议tmx中使用圆形
			//==================================================================
			
			//assets
			var assetPath:String = propertyBag.read("assetPath");
			
			//bg sound may be has a big range.
			var soundRange:Number = aabb.width >> 1;

			var assetsManager:CrocoAssetsManager = scene.assetsManager;
			
			var soundAsset:SoundAsset = assetsManager.getSoundAsset(
				AppConfig.findScreenResourcePath(scene.name, assetPath));

			//sound component.
			var soundComponent:DistanceSoundComponent = new DistanceSoundComponent();
			soundComponent.sound = soundAsset.sound;
			soundComponent.soundCategory = SoundManager.MUSIC_MIXER_CATEGORY;
			
			initComponents = [soundComponent];
			
			super.onInit();
		}
	}
}