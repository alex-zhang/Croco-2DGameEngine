package com.croco2d.utils.tmx.scene.ornaments
{
	import com.croco2d.AppConfig;
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.assets.ImageAsset;
	import com.croco2d.assets.SpriteSheetAsset;
	import com.croco2d.components.DisplayComponent;
	import com.croco2d.scene.CrocoGameObject;
	
	import starling.display.Shape;
	import starling.display.materials.StandardMaterial;
	import starling.display.shaders.fragment.TextureFragmentShader;
	import starling.display.shaders.vertex.AnimateUVVertexShader;
	import starling.textures.Texture;

	public class OrtLineUVAnimationEntity extends CrocoGameObject
	{
		public function OrtLineUVAnimationEntity()
		{
			super();
		}
		
		override protected function onInit():void
		{
			//==================================================================
			//tmxPropertityParms：
			//1. assetPath : 场景相对路径
			//	format：path/a.png|jpg
			//		   path/a.sprsres:textureNme(纹理集中的纹理名称)
			//
			//2. assetPath2 : 场景相对路径(可选)
			//	format：path/a.png|jpg
			//		   path/a.sprsres:textureNme(纹理集中的纹理名称)
			//
			//3. thickness：(necessary) 
			//  format： 10
			//
			//4. points：构成线的点
			//	该属性无需设置属性，而是使用tmx里面的线段图型。（注意：折线点的数量一定是大于或等于3且总数是奇数）
			//
			//5. uvSpeed:uv动画的滚动速度(不设默认0.1:0.1) 单位像素/秒
			//	format：0.6:0
			//====================================================================
			
			//assets
			var assetPath:String = propertyBag.read("assetPath");
			
			var thickness:Number = parseFloat(propertyBag.read("thickness"));
			var linePoints:Array = propertyBag.read("points");
			
			var uSpped:Number = 0.1;
			var vSpped:Number = 0.1;
			if(propertyBag.has("uvSpeed"))
			{
				var uvSpeedStr:String = propertyBag.read("uvSpeed");
				var uvSpeedArr:Array = uvSpeedStr.split(":");
				
				uSpped = parseFloat(uvSpeedArr[0]);
				vSpped = parseFloat(uvSpeedArr[1]);
			}
			
			var assetsManager:CrocoAssetsManager = scene.assetsManager;
			
			var assetPathArr:Array;
			var assetName:String;
			var textureAsset:ImageAsset;
			var spriteSheetAsset:SpriteSheetAsset;
			
			var lineTexture:Texture;
			if(assetPath.lastIndexOf(CrocoAssetsManager.SPRIT_SHEET_EXTENTION) != -1)
			{
				assetPathArr = assetPath.split(":");
				
				assetPath = assetPathArr[0];
				assetName = assetPathArr[1];
				
				assetPath = AppConfig.findScreenResourcePath(scene.name, assetPath);
				
				spriteSheetAsset = assetsManager.getSpriteSheetAsset(assetPath);
				
				lineTexture = spriteSheetAsset.textureAtlas.getTexture(assetName);
			}
			else
			{
				assetPath = AppConfig.findScreenResourcePath(scene.name, assetPath);
				
				textureAsset = assetsManager.getImageAsset(assetPath);
				
				lineTexture = textureAsset.texture;
			}
			
			//--
			
			var lineTexture2:Texture;
			if(propertyBag.has("assetPath2"))
			{
				var assetPath2:String = propertyBag.read("assetPath2");
				
				if(assetPath2.lastIndexOf(CrocoAssetsManager.SPRIT_SHEET_EXTENTION) != -1)
				{
					assetPathArr = assetPath.split(":");
					
					assetPath2 = assetPathArr[0];
					assetName = assetPathArr[1];
					
					assetPath2 = AppConfig.findScreenResourcePath(scene.name, assetPath2);
					
					spriteSheetAsset = assetsManager.getSpriteSheetAsset(assetPath2);
					
					lineTexture2 = spriteSheetAsset.textureAtlas.getTexture(assetName);
				}
				else
				{
					assetPath2 = AppConfig.findScreenResourcePath(scene.name, assetPath2);
					
					textureAsset = assetsManager.getImageAsset(assetPath2);
					
					lineTexture2 = textureAsset.texture;
				}
			}
			
			//display
			var lineShape:Shape = new Shape();
			
			var lavaMaterial:StandardMaterial = new StandardMaterial();
			lavaMaterial.vertexShader = new AnimateUVVertexShader(uSpped, vSpped);
			lavaMaterial.fragmentShader = new TextureFragmentShader();
			
			lavaMaterial.textures[0] = lineTexture;
			if(lineTexture2)
			{
				lavaMaterial.textures[1] = lineTexture2;
			}
			
			lineShape.graphics.lineMaterial(thickness, lavaMaterial);
			
			var nextPoint:Object;
			var n:int = linePoints.length;
			
			if(n % 2 == 0) 
			{
				linePoints.pop();
				n--;
			}
			
			if(n < 3)
			{
				throw new Error("error point format!!!");
			}
			
			var point:Object = linePoints[0];
			lineShape.graphics.moveTo(point.x, point.y);
			
			var minX:Number = point.x;
			var maxX:Number = point.x;
			
			var minY:Number = point.y;
			var maxY:Number = point.y;
			
			for(var i:int = 1; i < n; i += 2)
			{
				point = linePoints[i];
				nextPoint = linePoints[i + 1];
				
				lineShape.graphics.curveTo(point.x, point.y, nextPoint.x, nextPoint.y);
			}
			
			//display component.
			var displayComponent:DisplayComponent = new DisplayComponent();
			displayComponent.displayObject = lineShape;
			
			initComponents = [displayComponent];
			
			super.onInit();
		}
	}
}