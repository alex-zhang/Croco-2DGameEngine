package com.croco2d.utils.tmx.scene
{
	import com.croco2d.AppConfig;
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.components.DisplayComponent;
	import com.croco2d.display.CrocoImage;
	import com.croco2d.scene.CrocoGameObject;

	public class TMXImageLayer extends TMXBasicLayer
	{
		public var backgroundImageEntity:CrocoGameObject;

		private var mImageWidth:Number;
		private var mImageHeight:Number;
		private var mImageSourcePath:String;
		
		public function TMXImageLayer()
		{
			super();
		}
		
		override public function deserialize(xml:XML):void
		{
			super.deserialize(xml);
			
			mImageWidth = parseFloat(xml.@width);
			mImageHeight = parseFloat(xml.@height);
				
			//must has the image XML tag.
			var imageXML:XML = xml.image[0];
			if(imageXML)
			{
				mImageSourcePath = imageXML.@source;
			}
		}
		
		override protected function onInit():void
		{
			var assetsManager:CrocoAssetsManager = scene.assetsManager;
			
			//image.
			var crocoImage:CrocoImage = new CrocoImage();
			var assetURL:String = AppConfig.findScreenResourcePath(scene.name, mImageSourcePath);
			crocoImage.texture = assetsManager.getImageAsset(assetURL).texture;
			
			//display component.
			var displayComponent:DisplayComponent = new DisplayComponent();
			displayComponent.displayObject = crocoImage;

			//entity.
			backgroundImageEntity = new CrocoGameObject();
			backgroundImageEntity.initComponents = [displayComponent];
			
			initSceneEnetities = [backgroundImageEntity];
			
			super.onInit();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			mImageWidth = NaN;
			mImageHeight = NaN;
			
			mImageSourcePath = null;
			
			backgroundImageEntity = null;
		}
	}
}