package
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.components.render.DispalyObjectComponent;
	import com.croco2d.components.render.PDParticleSystemComponent;
	import com.croco2d.core.CrocoGameObject;
	import com.croco2d.screens.SceneScreen;
	import com.fireflyLib.utils.JsonObjectFactorUtil;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	public class CrocoScreen1 extends SceneScreen
	{
		[Embed(source="assets/app/texture.png")]
		private var imageCls:Class;
		
		public function CrocoScreen1()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var img:Image = JsonObjectFactorUtil.createFromJsonConfig({
				clsType:Image,
				ctorParams:[Texture.fromEmbeddedAsset(imageCls)]
//				props:
//				{
//					filter:BlurFilter.createGlow(0x678676)								
//				}
			});
			
			var gameObject:CrocoGameObject = CrocoGameObject.createFromJsonConfig(
				{
					callback:function(go:CrocoGameObject):void {
//						go.transformComponent.setPosition(400, 300);
//						go.transformComponent.rotation = deg2rad(45);
					},
					clsType:CrocoGameObject,
					props:
					{
						initComponents:
						[
							{
								clsType:PDParticleSystemComponent,
								props:
								{
									texture:Texture.fromEmbeddedAsset(imageCls)
								}
							}
							,
							
							{
								clsType:MouseParticalScript
							}
						],
						
						initChildrenGameObjects:
						[
//							{
//								clsType:CrocoGameObject,
//								callback:function(go:CrocoGameObject):void {
//									go.transformComponent.setPosition(100, 20);
//									go.transformComponent.rotation = deg2rad(45);
//									//						go.transformComponent.rotation = deg2rad(45);
//								}, 
//								props:
//								{
//									initComponents:
//									[
//										{
//											clsType:DispalyObjectComponent,
//											props:
//											{
//												dispalyObject:img
//											}
//										}
//									]
//								}
//							}
						]
					}
				});
			
			CrocoEngine.rootGameObject.addGameObejct(gameObject);
		}
	}
}