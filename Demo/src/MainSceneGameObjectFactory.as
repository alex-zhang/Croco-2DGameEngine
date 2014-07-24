package
{
	import com.croco2d.AppConfig;
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.components.motion.PathMovingComponent;
	import com.croco2d.components.render.ImageComponent;
	import com.croco2d.core.GameObject;
	import com.croco2d.screens.CrocoScreen;
	
	import starling.animation.Tween;
	import starling.core.Starling;

	public final class MainSceneGameObjectFactory
	{
		private var screen:CrocoScreen;
		private var crocoAssetsManager:CrocoAssetsManager;
		
		public function MainSceneGameObjectFactory(screen:CrocoScreen)
		{
			this.screen = screen;
			crocoAssetsManager = screen.assetsManager;
		}
		
		public function createScene():GameObject
		{
			return GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					props:
					{
						initChildrenGameObjects:
						[
							createImage()
						]
					}
				}
			);
		}
		
		
		public function createCamera():GameObject
		{
			return GameObject.createFromJsonConfig(
				{
					clsType:"(class)com.croco2d.core::GameObject",
					
					callback:function(go:GameObject):void
					{
						//							go.transform.setPivotPosition(100,100);
						
						var tween:Tween = new Tween(go.transform, 4);
						tween.repeatCount = 0;
						tween.animate("rotation", Math.PI * 2);
						Starling.juggler.add(tween);
					}
					,
					props:
					{
						debug:true,
						initComponents:
						[
							{
								clsType:"(class)com.croco2d.components.render::CameraRenderComponent",
								props:
								{
									debug:true
								}
							}
							,
							{
								clsType:PathMovingComponent,
								callback:function(pc:PathMovingComponent):void
								{
									pc.followPath([{x:5370, y:3000}, {x:0, y:2000}], 200, 4);
								}
							}							
							
						]
					}
				}
			);
		}
		
		public function createImage():GameObject
		{
			return GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					callback:function(go:GameObject):void {go.transform.scale(10)},
					props:
					{
						initComponents:
						[
							{
								clsType:ImageComponent,
								props:
								{
									texture:crocoAssetsManager.getImageAsset(AppConfig.findScreenResourcePath("MainScreen", "img1.png")).texture
								}
							}
//							,
//							{
//								clsType:PathMovingComponent,
//								callback:function(pc:PathMovingComponent):void
//								{
//									pc.followPath([{x:200, y:300}, {x:500, y:100}], 50, 4);
//								}
//							}
						]
					}
				}
			);
		}
		
		
		public function createImage2():GameObject
		{
			return GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					props:
					{
						initComponents:
						[
							{
								clsType:ImageComponent,
								props:
								{
									texture:crocoAssetsManager.getImageAsset(AppConfig.findScreenResourcePath("MainScreen", "add_1.png")).texture
								}
							}
						]
					}
				}
			);
		}
	}
}