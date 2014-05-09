package com.croco2d.sound
{
    import com.croco2d.sound.ISoundHandle;
    import com.fireflyLib.debug.Logger;
    
    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;

    /**
     * Track an active sound. You should only use ISoundHandle, not access this
     * directly.
     * 
     * @see ISoundHandle See ISoundHandle for documentation on this class.
     * @inheritDocs
     */
    internal class SoundHandle implements ISoundHandle
    {
		internal var mSoundManager:SoundManager;
		internal var mSound:Sound;
		internal var mCategory:String;

		protected var mPan:Number = 0;
		protected var mLoopCount:int = 0;
		protected var pausedPosition:Number = 0;
		
		internal var dirty:Boolean = true;
		internal var playing:Boolean;
		internal var playingCompleted:Boolean = false;
		
		internal var channel:SoundChannel;
		
		protected var mVolume:Number = 1;
		
        public function SoundHandle(soundManager:SoundManager, 
									sound:Sound, 
									category:String, 
									pan:Number, 
									mLoopCount:int, 
									startDelay:Number)
        {
            mSoundManager = soundManager;
			mSound = sound;
            mCategory = category;
			mPan = pan;
            mLoopCount = mLoopCount;
            pausedPosition = startDelay;
            
            resume();
        }
        
        public function get transform():SoundTransform
        {
            if(!channel)
			{
                return new SoundTransform();
			}
			
            return channel.soundTransform;
			
        }

        public function set transform(value:SoundTransform):void
        {
            if(channel)
			{
                channel.soundTransform = value;
			}
			
			dirty = true;
        }

        public function get volume():Number
        {
            return mVolume;
        }

        public function set volume(value:Number):void
        {
			if(mVolume != value)
			{
				mVolume = value;
				dirty = true;	
			}
        }
        
        public function get pan():Number
        {
            return mPan;
        }
        
        public function set pan(value:Number):void
        {
			if(mPan != value)
			{
				mPan = value;
				dirty = true;	
			}
        }
        
        public function get category():String
        {
            return mCategory;
        }

        public function pause():void
        {
            pausedPosition = channel.position;
            channel.stop();
        }
        
        public function resume():void
        {
            dirty = true;
            
            // Note: if pausedPosition is anything but zero, the loops will not reset properly.
            // For now, the ability to "pause" should be avoided.
            try
            {
                channel = mSound.play(pausedPosition, mLoopCount);
                playing = true;   

                // notify when this sound is done (all loops completed)
                channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
            }
            catch(e:Error)
            {
                Logger.error("SoundHandle", "resume Error starting sound playback: " + e.toString());
            }
        }
        
        /**
         * To correctly handle the pause scenario, we need to be notified at the end of each loop,
         * so that we can reset the sound's starting position to 0.
         */
        private function onSoundComplete(e:Event):void
        {
            // since we're tracking the number of loops, decrement the count
            mLoopCount -= 1;

            if(mLoopCount > 0)
            {
                pausedPosition = 0;
                resume();
            }
            else
            {
				stop();
            }
        }
        
        public function stop():void
        {
            pause();
            
            if(mSoundManager.isInPlayingSounds(this))
            {
                // Remove from the mSoundManager.
                mSoundManager.removeSoundHandle(this);
            }
        }
        
        public function get isPlaying():Boolean
        {
            return playing;
        }
    }
}