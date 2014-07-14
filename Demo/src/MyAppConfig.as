package
{
	import com.croco2d.AppConfig;
	import com.croco2d.core.GameObject;
	import com.croco2d.screens.FlashBootStrapScreen;
	import com.croco2d.screens.PreloadHubScreen;
	
	import feathers.controls.ScreenNavigatorItem;
	import feathers.core.FeathersControl;

	public class MyAppConfig extends AppConfig
	{
		globalEvnConfig = 
		{
			//1.3333~ 1.777 ratio.
			designWidth:960,
			designHeight:600,
			backgroundColor:0xFFFFFF,
			frameRate:60,
			textureScaleFactor:1.0,
			textureUseMipmaps:false,
			pauseEngineWhenDeActivated:true,
			pauseRenderingWhenDeActivated:true,
			startupLogger:true,
			gravityX:0,
			gravityY:980,
			physicsStepTime: 1/ 20
		}
		
		crocoEngineConfig = 
		{
			clsProps:
			{
				timeScale:1.0,
				tickDeltaTime:1.0 / 60,
					maxTicksPerFrame:5
			},
			
			clsType:"(class)com.croco2d::CrocoEngine",
			
			props:
			{
				debug:true,
				initComponents:
				[
					{
						clsType:"(class)com.croco2d.core::GameObject",

						callback:function(go:GameObject):void
						{
//							go.transform.setPivotPosition(100,100);
						}
						,
						props:
						{
							debug:true,
							name:AppConfig.KEY_CAMERA,
							initComponents:
							[
								{
									clsType:"(class)com.croco2d.components.render::CameraRenderComponent",
									props:
									{
										debug:true
									}
								}
							]
						}
					},
					
					{
						clsType:"(class)com.croco2d.input::InputManager",
						props:
						{
							name:AppConfig.KEY_INPUT_MANAGER,
							initInputControllers:
							[
								{
									clsType:"(class)com.croco2d.input.controllers::KeyboardController"
								}
							]
						}
					},
					{
						clsType:"(class)com.croco2d.sound::SoundManager",
						props:
						{
							name:AppConfig.KEY_SOUND_MANAGER,
							maxConcurrentSounds:10
						}
					},
					{
						clsType:"(class)com.croco2d.assets::CrocoAssetsManager",
						props:
						{
							name:AppConfig.KEY_GLOBAL_ASSETS_MANAGER
						}
					}
				]
			}
		}
		
		bootStrapSceenConfig = 
			{
				clsType:FlashBootStrapScreen,
				
				props:
				{
					launchImage:"launchImage.png",
					fadeoutTime:5
				}
			}
			
			
		screensConfig = 
		[
			{
				clsType:ScreenNavigatorItem,
				
				ctorParams:
				[
					MainScreen,
					null,
					{
						screenID:"MainScreen",
						hubScreenID:"hubScreenId"
					}
				]
			}
			,
			
			{
				clsType:ScreenNavigatorItem,
				
				ctorParams:
				[
					MyHubScreen,
					null,
					{
						screenID:"hubScreenId"
					}
				]
			}
		];
	}
}