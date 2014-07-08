package com.croco2d.display.animationSprite
{
	import com.croco2d.display.CrocoImage;
	import com.fireflyLib.utils.EventEmitter;
	import com.fireflyLib.utils.MathUtil;
	
	import starling.animation.IAnimatable;
	
	public class AnimationSprite extends CrocoImage implements IAnimatable
	{
		private var mCurrentFrame:int;
		private var mTotalFrame:uint;
		
		private var mFrameDuration:Number;//-> 1 / fps
		
		private var mLoop:Boolean = false;
		private var mPlaying:Boolean = false;
		
		private var mAnimationTime:Number = 0.0;
		
		private var mFrames:Vector.<FrameInfo>;
		
		private var mEventEmitter:EventEmitter = null;
		
		public function AnimationSprite()
		{
			super();
			
			mCurrentFrame = 1;
			mTotalFrame = 0;
			
			mFrameDuration = 1 / 24.0;//default
			
			mAnimationTime = 0.0;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mEventEmitter)
			{
				mEventEmitter.dispose();
				mEventEmitter= null;
			}
			
			mLoop = false;
			mPlaying = false;
			
			mFrames = null;
		}
		
		public function get frames():Vector.<FrameInfo> { return mFrames; }
		public function set frames(value:Vector.<FrameInfo>):void
		{
			if(mFrames != value)
			{
				mFrames = value;

				if(mFrames)
				{
					mCurrentFrame = 1;
					mTotalFrame = mFrames.length;
					
					super.texture = mFrames[mCurrentFrame - 1].texture;
				}
				else
				{
					mCurrentFrame = 1;
					mTotalFrame = 0;
				}
				
				mLoop = false;
				mPlaying = false;
				mFrameDuration = 1 / 24.0;//default
				mAnimationTime = 0.0;
			}
		}
		
		public function get totalFrame():uint
		{
			return mTotalFrame;
		}
		
		public function get eventEmitter():EventEmitter
		{
			if(!mEventEmitter)
			{
				mEventEmitter = new EventEmitter(this);
			}
			
			return mEventEmitter;
		}
		
		public function get fps():Number
		{
			return 1 / mFrameDuration;
		}
		
		public function set fps(value:Number):void
		{
			if (isNaN(value) || value <= 0) throw new ArgumentError("Invalid fps: " + value);
			
			mFrameDuration = 1 / value;
		}
		
		public function get loop():Boolean { return mLoop; }
		public function set loop(value:Boolean):void { mLoop = value; }
		
		public function get currentFrame():int { return mCurrentFrame; }
		public function set currentFrame(value:int):void
		{
			mCurrentFrame = MathUtil.clamp(value, 1, mTotalFrame);
		}
		
		public function get isPlaying():Boolean
		{
			if(mPlaying)
			{
				return mLoop || mCurrentFrame < mTotalFrame;
			}
			else
			{
				return false;
			}
		}
		
		public function get isComplete():Boolean
		{
			return !mLoop && mCurrentFrame == mTotalFrame;
		}
		
		public function play():void
		{
			mPlaying = true;
		}
		
		public function pause():void
		{
			mPlaying = false;
		}
		
		public function stop():void
		{
			pause();
			mCurrentFrame = 1;
		}
		
		public function advanceTime(deltaTime:Number):void
		{
			if(!mPlaying || !mFrames || mCurrentFrame > mTotalFrame) return;
			
			mAnimationTime += deltaTime;
			
			while(mAnimationTime > 0)
			{
				//current animation loop complete
				if(mCurrentFrame == mTotalFrame)
				{
					if(mLoop) 
					{
						mCurrentFrame = 1;
					}
					else
					{
						mPlaying = false;
					}
				}
				else
				{
					mCurrentFrame++;
				}
				
				mAnimationTime -= mFrameDuration;
			}

			onRenderFrame(mCurrentFrame);
		}
		
		protected function onRenderFrame(frame:int):void
		{
			var frameInfo:FrameInfo = mFrames[frame - 1];
			
			if(frameInfo.eventName && eventEmitter.hasEventListener(frameInfo.eventName))
			{
				eventEmitter.dispatchEvent(frameInfo.eventName, frameInfo.eventParams);
			}
			
			super.texture = frameInfo.texture;
		}
	}
}