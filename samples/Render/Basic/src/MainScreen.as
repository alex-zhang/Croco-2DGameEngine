package
{
	import com.croco2d.AppConfig;
	import com.croco2d.CrocoEngine;
	import com.croco2d.components.motion.PathMovingComponent;
	import com.croco2d.components.render.AnimationSpriteComponent;
	import com.croco2d.components.render.ImageComponent;
	import com.croco2d.components.render.PDParticleSystemComponent;
	import com.croco2d.components.render.QuadComponent;
	import com.croco2d.components.render.RibbonTrailComponent;
	import com.croco2d.components.render.TextComponent;
	import com.croco2d.core.GameObject;
	import com.croco2d.screens.SceneScreen;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.extensions.RibbonSegment;
	import starling.utils.deg2rad;

	public class MainScreen extends SceneScreen implements IAnimatable
	{
		public function MainScreen()
		{
			super();
		}
		
		override protected function createScene():GameObject
		{
			
			Starling.juggler.add(this);
			
			CrocoEngine.camera.transform.setPosition(CrocoEngine.stageWidth * 0.5, CrocoEngine.stageHeight * 0.5);
			
			return GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					props:
					{
						initChildrenGameObjects:
						[
							createImage(),
							createText(),
							createQuad(),
							createPDParticleSystem(),
							createRibbonTrail()
						]
					}
				}
			);
		}
		
		private function createImage():GameObject
		{
			return GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					callback:function(go:GameObject):void
					{
						go.transform.setPosition(Math.random() * CrocoEngine.stageWidth * 0.6, Math.random() * CrocoEngine.stageHeight * 0.6);
					}
					,
					props:
					{
						debug:true,
						initComponents:
						[
							{
								clsType:ImageComponent,
								props:
								{
									texture:assetsManager.getImageAsset(AppConfig.findScreenResourcePath(screenID, "monkey.png")).texture
								}
							}
							,
							{
								clsType:PathMovingComponent,
								callback:function(pc:PathMovingComponent):void {
									pc.followPath(createRandomPath(), Math.random() * 200, 4);
								}
							}
						]
					}
				}
			);
		}
		
		private function createText():GameObject
		{
			return GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					callback:function(go:GameObject):void
					{
						go.transform.setPosition(Math.random() * CrocoEngine.stageWidth * 0.6, Math.random() * CrocoEngine.stageHeight * 0.6);
					}
					,
					props:
					{
						debug:true,
						initComponents:
						[
							{
								clsType:TextComponent,
								props:
								{
									border:true,
									color:Math.random() * 0xFFFFFF,
									text:"hello ----------- 中文测试!"
								}
							}
							,
							{
								clsType:PathMovingComponent,
								callback:function(pc:PathMovingComponent):void {
									pc.followPath(createRandomPath(), Math.random() * 200, 4);
								}
							}
						]
					}
				}
			);
		}
		
		private function createQuad():GameObject
		{
			return GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					callback:function(go:GameObject):void
					{
						go.transform.setPosition(Math.random() * CrocoEngine.stageWidth * 0.6, Math.random() * CrocoEngine.stageHeight * 0.6);
					}
					,
					props:
					{
						debug:true,
						initComponents:
						[
							{
								clsType:QuadComponent,
								props:
								{
									color:Math.random() * 0xFFFFFF
								}
							}
							,
							{
								clsType:PathMovingComponent,
								callback:function(pc:PathMovingComponent):void {
									pc.followPath(createRandomPath(), Math.random() * 200, 4);
								}
							}
						]
					}
				}
			);
		}
		
		private function createPDParticleSystem():GameObject
		{
			return GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					callback:function(go:GameObject):void
					{
						go.transform.setPosition(Math.random() * CrocoEngine.stageWidth * 0.6, Math.random() * CrocoEngine.stageHeight * 0.6);
					}
					,
					props:
					{
						debug:true,
						initComponents:
						[
							{
								clsType:PDParticleSystemComponent,
								props:
								{
									initConfig:PARTICLE_CONFIG,
									texture:assetsManager.getImageAsset(AppConfig.findScreenResourcePath(screenID, "partical_texture.png")).texture
								}
							}
							,
							{
								clsType:PathMovingComponent,
								callback:function(pm:PathMovingComponent):void {
									pm.followPath(createRandomPath(), Math.random() * 200, 4);
								}
							}
						]
					}
				}
			);
		}
		
		private var ribbonTrail:RibbonTrailComponent;
		private var followingRibbonSegment:RibbonSegment = new RibbonSegment();
		private var followingRibbonSegmentLine:Vector.<RibbonSegment> =
			new <RibbonSegment>[followingRibbonSegment];
		
		public var ribbonTrail_rotation:Number = 0;
		public function advanceTime(time:Number):void
		{
			if(ribbonTrail)
			{
				ribbonTrail_rotation += deg2rad(90 * time);
				followingRibbonSegment.setTo2(ribbonTrail.transform.x,ribbonTrail.transform.y, 60, ribbonTrail_rotation);
			}
		}
		
		private function createRibbonTrail():GameObject
		{
			return GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					callback:function(go:GameObject):void
					{
						go.transform.setPosition(Math.random() * CrocoEngine.stageWidth * 0.6, Math.random() * CrocoEngine.stageHeight * 0.6);
					}
					,
					props:
					{
						debug:true,
						initComponents:
						[
							{
								clsType:RibbonTrailComponent,
								callback:function(rt:RibbonTrailComponent):void
								{
									ribbonTrail = rt;
								}
								,
								props:
								{
									initTrailSegmentsCount:100,
									movingRatio:0.3,
									alphaRatio:0.94,
									texture:assetsManager.getImageAsset(AppConfig.findScreenResourcePath(screenID, "laser.png")).texture
									,
									followingRibbonSegmentLine:followingRibbonSegmentLine
								}
							}
							,
							{
								clsType:PathMovingComponent,
								callback:function(pm:PathMovingComponent):void {
									pm.followPath(
										[
											{x:200, y:500},
											
											{x:500, y:0},
											
											{x:750, y:500},
											
											{x:1000, y:0},
											
											{x:750, y:500}
										]
										, 200, 4);
								}
							}
						]
					}
				}
			);
		}
		
		private function createRandomPath():Array
		{
			var path:Array = [];
			for(var i:int = 0; i < 10; i++)
			{
				path.push(
					{x:Math.random() * 800, y:Math.random() * 500}
				);
			}
			
			return path;
		}
		
		private static const PARTICLE_CONFIG:XML = <particleEmitterConfig>
																  <texture name="texture.png"/>
																  <sourcePosition x="300.00" y="300.00"/>
																  <sourcePositionVariance x="0.00" y="0.00"/>
																  <speed value="100.00"/>
																  <speedVariance value="30.00"/>
																  <particleLifeSpan value="2.0000"/>
																  <particleLifespanVariance value="1.9000"/>
																  <angle value="270.00"/>
																  <angleVariance value="2.00"/>
																  <gravity x="0.00" y="0.00"/>
																  <radialAcceleration value="0.00"/>
																  <tangentialAcceleration value="0.00"/>
																  <radialAccelVariance value="0.00"/>
																  <tangentialAccelVariance value="0.00"/>
																  <startColor red="1.00" green="0.31" blue="0.00" alpha="0.62"/>
																  <startColorVariance red="0.00" green="0.00" blue="0.00" alpha="0.00"/>
																  <finishColor red="1.00" green="0.31" blue="0.00" alpha="0.00"/>
																  <finishColorVariance red="0.00" green="0.00" blue="0.00" alpha="0.00"/>
																  <maxParticles value="30"/>
																  <startParticleSize value="70.00"/>
																  <startParticleSizeVariance value="49.53"/>
																  <finishParticleSize value="10.00"/>
																  <FinishParticleSizeVariance value="5.00"/>
																  <duration value="-1.00"/>
																  <emitterType value="0"/>
																  <maxRadius value="100.00"/>
																  <maxRadiusVariance value="0.00"/>
																  <minRadius value="0.00"/>
																  <rotatePerSecond value="0.00"/>
																  <rotatePerSecondVariance value="0.00"/>
																  <blendFuncSource value="770"/>
																  <blendFuncDestination value="1"/>
																  <rotationStart value="0.00"/>
																  <rotationStartVariance value="0.00"/>
																  <rotationEnd value="0.00"/>
																  <rotationEndVariance value="0.00"/>
																</particleEmitterConfig>;
	}
}