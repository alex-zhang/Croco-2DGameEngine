package com.croco2d.display.animationSprite
{
	public class AnimationSetSprite extends AnimationSprite
	{
		private var mAnimationSetInfo:AnimationSetInfo;
		private var mCurrentAniamtionName:String;
		
		public function AnimationSetSprite()
		{
			super();
		}
		
		public function get animationSetInfo():AnimationSetInfo { return mAnimationSetInfo; }
		public function set animationSetInfo(value:AnimationSetInfo):void
		{
			mAnimationSetInfo = value;

			if(!mAnimationSetInfo)
			{
				frames = null;
			}
		}
		
		public function get currentAniamtionName():String { return mCurrentAniamtionName; }
		
		public function gotoAndPlay(animationName:String, loop:Boolean = false, duration:Number = NaN):void
		{
			if(!mAnimationSetInfo || !mAnimationSetInfo.hasAnimation(animationName)) return;
			
			mCurrentAniamtionName = animationName;
			
			var animationInfo:AnimationInfo = mAnimationSetInfo.getAnimationInfoByName(mCurrentAniamtionName);
			
			this.frames = animationInfo.getFrames();
			this.currentFrame = 1;
			
			this.fps = !isNaN(duration) ?
				animationInfo.getFrameCount() / duration :
				animationInfo.frameRate;
			
			this.loop = loop;
			
			this.play();
		}
	}
}