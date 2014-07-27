package com.croco2d.components.render
{
	import com.llamaDebugger.Logger;
	
	import flash.geom.Matrix;
	
	import starling.core.RenderSupport;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class PDParticleSystemComponent extends RenderComponent
	{
		public var initConfig:XML;
		public var isAutoPlay:Boolean = true;
		public var isUseWorldSpace:Boolean = true;//default is true.
		
		public var __particleSystem:PDParticleSystem;
		public var __texture:Texture;
		public var __defaultTexture:Texture;
		
		public function PDParticleSystemComponent()
		{
			super();
		}
		
		public function get texture():Texture { return __texture; }
		public function set texture(value:Texture):void
		{
			if(__texture != value)
			{
				__texture = value;
				
				if(!__texture) throw new Error("PDParticleSystemComponent texture is null!");
				
				if(__defaultTexture)
				{
					__defaultTexture.dispose();
					__defaultTexture = null;
				}
				
				if(__particleSystem)
				{
					__particleSystem.texture = __texture;
				}
			}
		}
		
		public function get isEmitting():Boolean { return __particleSystem ? __particleSystem.isEmitting : false; }
		public function get capacity():int { return __particleSystem ? __particleSystem.capacity : 0; }
		public function get numParticles():int { return __particleSystem ? __particleSystem.numParticles : 0; }
		
		public function get maxCapacity():int { return __particleSystem ? __particleSystem.maxCapacity : 0; }
		public function set maxCapacity(value:int):void 
		{
			if(__particleSystem)
			{
				__particleSystem.maxCapacity = value;
			}
		}
		
		public function get emissionRate():Number { return __particleSystem ? __particleSystem.emissionRate : 0; }
		public function set emissionRate(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.emissionRate = value;
			}
		}
		
//		public function get emitterX():Number { return __particleSystem ? __particleSystem.emitterX : 0; }
//		public function set emitterX(value:Number):void 
//		{
//			if(__particleSystem)
//			{
//				__particleSystem.emitterX = value;
//			}
//		}
//		
//		public function get emitterY():Number { return __particleSystem ? __particleSystem.emitterY : 0; }
//		public function set emitterY(value:Number):void 
//		{
//			if(__particleSystem)
//			{
//				__particleSystem.emitterY = value;
//			}
//		}
		
		public function get blendFactorSource():String { return __particleSystem ? __particleSystem.blendFactorSource : null; }
		public function set blendFactorSource(value:String):void 
		{
			if(__particleSystem)
			{
				__particleSystem.blendFactorSource = value;
			}
		}
		
		public function get blendFactorDestination():String { return __particleSystem ? __particleSystem.blendFactorDestination : null; }
		public function set blendFactorDestination(value:String):void 
		{
			if(__particleSystem)
			{
				__particleSystem.blendFactorDestination = value;
			}
		}
		
		public function get emitterType():int { return __particleSystem ? __particleSystem.emitterType : 0; }
		public function set emitterType(value:int):void 
		{ 
			if(__particleSystem) 
			{ 
				__particleSystem.emitterType = value; 
			}
		}
		
		public function get emitterXVariance():Number { return __particleSystem ? __particleSystem.emitterXVariance : 0; }
		public function set emitterXVariance(value:Number):void 
		{ 
			if(__particleSystem) 
			{ __particleSystem.emitterXVariance = value; 
			}
		}
		
		public function get emitterYVariance():Number { return __particleSystem ? __particleSystem.emitterYVariance : 0; }
		public function set emitterYVariance(value:Number):void 
		{ 
			if(__particleSystem) 
			{ __particleSystem.emitterYVariance = value;
			}
		}
		
		public function get maxNumParticles():int { return __particleSystem ? __particleSystem.maxNumParticles : 0; }
		public function set maxNumParticles(value:int):void 
		{ 
			if(__particleSystem) 
			{
				__particleSystem.maxNumParticles = value;
			}
		}
		
		public function get lifespan():Number { return __particleSystem ? __particleSystem.lifespan : 0; }
		public function set lifespan(value:Number):void 
		{ 
			if(__particleSystem)
			{
				__particleSystem.lifespan = value;
			}
		}
		
		public function get lifespanVariance():Number { return __particleSystem ? __particleSystem.lifespanVariance : 0; }
		public function set lifespanVariance(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.lifespanVariance = value;
			}
		}
		
		public function get startSize():Number { return __particleSystem ? __particleSystem.startSize : 0; }
		public function set startSize(value:Number):void
		{ 
			if(__particleSystem)
			{
				__particleSystem.startSize = value;
			}
		}
		
		public function get startSizeVariance():Number { return __particleSystem ? __particleSystem.startSizeVariance : 0; }
		public function set startSizeVariance(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.startSizeVariance = value;
			}
		}
		
		public function get endSize():Number { return __particleSystem ? __particleSystem.endSize : 0; }
		public function set endSize(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.endSize = value;
			}
		}
		
		public function get endSizeVariance():Number { return __particleSystem ? __particleSystem.endSizeVariance : 0; }
		public function set endSizeVariance(value:Number):void 
		{ 
			if(__particleSystem)
			{
				__particleSystem.endSizeVariance = value;
			} 
		}
		
		public function get emitAngle():Number { return __particleSystem ? __particleSystem.emitAngle : 0; }
		public function set emitAngle(value:Number):void 
		{ 
			if(__particleSystem)
			{
				__particleSystem.emitAngle = value;
			}
		}
		
		public function get emitAngleVariance():Number { return __particleSystem ? __particleSystem.emitAngleVariance : 0; }
		public function set emitAngleVariance(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.emitAngleVariance = value;
			}
		}
		
		public function get startRotation():Number { return __particleSystem ? __particleSystem.startRotation : 0; } 
		public function set startRotation(value:Number):void 
		{ 
			if(__particleSystem)
			{
				__particleSystem.startRotation = value;
			}
		}
		
		public function get startRotationVariance():Number { return __particleSystem ? __particleSystem.startRotationVariance : 0; } 
		public function set startRotationVariance(value:Number):void 
		{ 
			if(__particleSystem)
			{
				__particleSystem.startRotationVariance = value;
			}
		}
		
		public function get endRotation():Number { return __particleSystem ? __particleSystem.endRotation : 0; } 
		public function set endRotation(value:Number):void 
		{ 
			if(__particleSystem)
			{
				__particleSystem.endRotation = value;
			}
		}
		
		public function get endRotationVariance():Number { return __particleSystem ? __particleSystem.endRotationVariance : 0; } 
		public function set endRotationVariance(value:Number):void 
		{ 
			if(__particleSystem)
			{
				__particleSystem.endRotationVariance = value;
			}
		}
		
		public function get speed():Number { return __particleSystem ? __particleSystem.speed : 0; }
		public function set speed(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.speed = value;
			}
		}
		
		public function get speedVariance():Number { return __particleSystem ? __particleSystem.speedVariance : 0; }
		public function set speedVariance(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.speedVariance = value;
			}
		}
		
		public function get gravityX():Number { return __particleSystem ? __particleSystem.gravityX : 0; }
		public function set gravityX(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.gravityX = value;
			}
		}
		
		public function get gravityY():Number { return __particleSystem ? __particleSystem.gravityY : 0; }
		public function set gravityY(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.gravityY = value;
			}
		}
		
		public function get radialAcceleration():Number { return __particleSystem ? __particleSystem.radialAcceleration : 0; }
		public function set radialAcceleration(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.radialAcceleration = value;
			}
		}
		
		public function get radialAccelerationVariance():Number { return __particleSystem ? __particleSystem.radialAccelerationVariance : 0; }
		public function set radialAccelerationVariance(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.radialAccelerationVariance = value;
			}
		}
		
		public function get tangentialAcceleration():Number { return __particleSystem ? __particleSystem.tangentialAcceleration : 0; }
		public function set tangentialAcceleration(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.tangentialAcceleration = value;
			}
		}
		
		public function get tangentialAccelerationVariance():Number { return __particleSystem ? __particleSystem.tangentialAccelerationVariance : 0; }
		public function set tangentialAccelerationVariance(value:Number):void 
		{ 
			if(__particleSystem)
			{
				__particleSystem.tangentialAccelerationVariance = value;
			}
		}
		
		public function get maxRadius():Number { return __particleSystem ? __particleSystem.tangentialAccelerationVariance : 0; }
		public function set maxRadius(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.maxRadius = value;
			}
		}
		
		public function get maxRadiusVariance():Number { return __particleSystem ? __particleSystem.maxRadiusVariance : 0; }
		public function set maxRadiusVariance(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.maxRadiusVariance = value;
			}
		}
		
		public function get minRadius():Number { return __particleSystem ? __particleSystem.minRadius : 0; }
		public function set minRadius(value:Number):void 
		{ 
			if(__particleSystem)
			{
				__particleSystem.minRadius = value;
			}
		}
		
		public function get rotatePerSecond():Number { return __particleSystem ? __particleSystem.rotatePerSecond : 0; }
		public function set rotatePerSecond(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.rotatePerSecond = value;
			}
		}
		
		public function get rotatePerSecondVariance():Number { return __particleSystem ? __particleSystem.rotatePerSecondVariance : 0; }
		public function set rotatePerSecondVariance(value:Number):void 
		{
			if(__particleSystem)
			{
				__particleSystem.rotatePerSecondVariance = value;
			}
		}
		
		public function get startColor():ColorArgb { return __particleSystem ? __particleSystem.startColor : null; }
		public function set startColor(value:ColorArgb):void 
		{
			if(__particleSystem)
			{
				__particleSystem.startColor = value;
			}		
		}
		
		public function get startColorVariance():ColorArgb { return __particleSystem ? __particleSystem.startColorVariance : null; }
		public function set startColorVariance(value:ColorArgb):void 
		{
			if(__particleSystem)
			{
				__particleSystem.startColorVariance = value;
			}
		}
		
		public function get endColor():ColorArgb { return __particleSystem ? __particleSystem.endColor : null; }
		public function set endColor(value:ColorArgb):void 
		{
			if(__particleSystem)
			{
				__particleSystem.endColor = value;
			}
		}

		public function get endColorVariance():ColorArgb { return __particleSystem ? __particleSystem.endColorVariance : null; }
		public function set endColorVariance(value:ColorArgb):void 
		{
			if(__particleSystem)
			{
				__particleSystem.endColorVariance = value;
			}
		}
		
		public function start(duration:Number=Number.MAX_VALUE):void
		{
			if(__particleSystem)
			{
				__particleSystem.start(duration);
			}
		}
		
		public function stop(clearParticles:Boolean=false):void
		{
			if(__particleSystem)
			{
				__particleSystem.stop(clearParticles);
			}
		}
		
		public function clear():void
		{
			if(__particleSystem)
			{
				__particleSystem.clear();
			}
		}
		
		override protected function onInit():void
		{
			if(!initConfig) initConfig = DEFAULT_CONFIG;
			if(!__texture) 
			{
				Logger.warn("PDParticleSystemComponent's texture is null, here will give a default texture!");
				
				if(!__defaultTexture)
				{
					__defaultTexture = Texture.fromColor(50, 50, 0xFFFFFF);
				}
				
				__texture = __defaultTexture;
			}

			__particleSystem = new PDParticleSystem(initConfig, __texture);
			if(isAutoPlay)
			{
				this.start();
			}
		}
		
		override public function tick(deltaTime:Number):void
		{
			__particleSystem.advanceTime(deltaTime);
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(isUseWorldSpace)
			{
				const modelViewMatrix:Matrix = support.modelViewMatrix;
				
				const lastModelViewMatrixTX:Number = modelViewMatrix.tx;
				const lastModelViewMatrixTY:Number = modelViewMatrix.ty;
				
				modelViewMatrix.tx = 0;
				modelViewMatrix.ty = 0;
				
				__particleSystem.emitterX = lastModelViewMatrixTX;
				__particleSystem.emitterY = lastModelViewMatrixTY;
			}
			
			__particleSystem.render(support, parentAlpha);
			
			if(isUseWorldSpace)
			{
				modelViewMatrix.tx = lastModelViewMatrixTX;
				modelViewMatrix.ty = lastModelViewMatrixTY;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__particleSystem)
			{
				__particleSystem.dispose();
				__particleSystem = null;
			}
			
			if(__defaultTexture)
			{
				__defaultTexture.dispose();
				__defaultTexture = null;
			}
		}
		
		public static const DEFAULT_CONFIG:XML = <particleEmitterConfig>
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
														  <maxParticles value="200"/>
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