package com.croco2d.components.render
{
	import com.croco2d.display.animationSprite.AnimationSprite;
	import com.croco2d.display.animationSprite.FrameInfo;

	public class AnimationSpriteComponent extends DisplayObjectComponent
	{
		public var isAutoPlay:Boolean = true;
		
		public var __frames:Vector.<FrameInfo>;
		public var __animationSprite:AnimationSprite;
		public var __fps:Number = 24;//default
		public var __loop:Boolean = false;
		public var __color:uint = 0xFFFFFF;//default;
		
		public function AnimationSpriteComponent()
		{
			super();
		}
		
		public function get color():uint
		{
			return __color;
		}
		
		public function set color(value:uint):void
		{
			if(__color != value)
			{
				__color = value;
				
				if(__animationSprite)
				{
					__animationSprite.color = __color;
				}
			}
		}
		
		public function get frames():Vector.<FrameInfo> 
		{
			return __frames;
		}
		
		public function set frames(value:Vector.<FrameInfo>):void
		{
			if(__frames != value)
			{
				__frames = value;
				
				if(__animationSprite)
				{
					__animationSprite.frames = __frames;
				}
			}
		}
		
		public function get fps():Number
		{
			return __fps;
		}
		
		public function set fps(value:Number):void
		{
			if(__fps != value)
			{
				__fps = value;
				
				if(__animationSprite)
				{
					__animationSprite.fps = __fps;
				}
			}
		}
		
		public function get loop():Boolean 
		{
			return __loop;
		}
		
		public function set loop(value:Boolean):void 
		{
			if(__loop != value)
			{
				__loop = value;
				
				if(__animationSprite)
				{
					__animationSprite.loop = __loop;
				}
			}
		}
		
		public function get currentFrame():int 
		{
			if(__animationSprite)
			{
				return __animationSprite.currentFrame;
			}
			
			return 0;
		}
		
		public function set currentFrame(value:int):void
		{
			if(__animationSprite)
			{
				__animationSprite.currentFrame = value;
			}
		}
		
		public function get totalFrame():uint
		{
			if(__animationSprite)
			{
				return __animationSprite.totalFrame;
			}
			
			return 0;
		}
		
		public function get isPlaying():Boolean
		{
			if(__animationSprite)
			{
				return __animationSprite.isPlaying;
			}
			
			return false;
		}
		
		public function get isComplete():Boolean
		{
			if(__animationSprite)
			{
				return __animationSprite.isComplete;
			}
			
			return false;
		}
		
		public function play():void
		{
			if(__animationSprite)
			{
				__animationSprite.play();
			}
		}
		
		public function pause():void
		{
			if(__animationSprite)
			{
				__animationSprite.pause();
			}
		}
		
		public function stop():void
		{
			if(__animationSprite)
			{
				__animationSprite.stop();
			}
		}
		
		override protected function onInit():void
		{
			__animationSprite = new AnimationSprite();
			__animationSprite.frames = __frames;
			__animationSprite.fps = __fps;
			__animationSprite.loop = __loop;
			if(__color != 0xffffff)
			{
				__animationSprite.color = __color;
			}
			
			if(isAutoPlay)
			{
				__animationSprite.play();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			__animationSprite = null;
		}
	}
}