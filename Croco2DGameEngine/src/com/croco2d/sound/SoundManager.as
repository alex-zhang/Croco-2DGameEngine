package com.croco2d.sound
{
    import com.croco2d.core.CrocoObject;
    
    import flash.media.Sound;
    import flash.media.SoundTransform;
    
    /**
     * This class implements the ISoundManager interface. See ISoundManager
     * for full documentation.
     * 
     * @see ISoundManager See ISoundManager for full documentation.
     */
    public class SoundManager extends CrocoObject
    {
        public static const MUSIC_MIXER_CATEGORY:String = "music";
        public static const SFX_MIXER_CATEGORY:String = "sfx";
        
        public var maxConcurrentSounds:int = 10;

        protected var playingSounds:Array = [];
        protected var categories:Object = {};
        protected var cachedSounds:Object = {};
        protected var rootCategory:SoundCategory = new SoundCategory();
        
        public function SoundManager()
        {
			super();
			
            createCategory(MUSIC_MIXER_CATEGORY);
            createCategory(SFX_MIXER_CATEGORY);
        }
        
        public function play(sound:Sound, category:String = "sfx",
							 pan:Number = 0.0, 
							 loopCount:int = 0, 
							 startDelay:Number = 0.0):ISoundHandle
        {
            // Cap sound playback.
            if(playingSounds.length > maxConcurrentSounds)
            {
                return null;
            }
            
            // Great, so set up the SoundHandle, start it, and return it.
            var sh:SoundHandle = new SoundHandle(this, sound, category, pan, loopCount, startDelay);            

            // Look up its category.
            var categoryRef:SoundCategory = categories[category] as SoundCategory;
            
            // Apply the category's transform to avoid transitory sound issues.
            if(categoryRef)
			{
                sh.transform = SoundCategory.applyCategoriesToTransform(categoryRef.muted, sh.pan, sh.volume, categoryRef);            
			}

            // Add to the list of playing sounds.
            playingSounds.push(sh);
            
            return sh;
        }
        
        public function set muted(value:Boolean):void
        {
            rootCategory.muted = value;
            rootCategory.dirty = true;
        }
        
        public function get muted():Boolean
        {
            return rootCategory.muted;
        }
        
        public function set volume(value:Number):void
        {
            rootCategory.transform.volume = value;
            rootCategory.dirty = true;
        }
        
        public function get volume():Number
        {
            return rootCategory.transform.volume;
        }
        
        public function createCategory(category:String):void
        {
            categories[category] = new SoundCategory();
        }
        
        public function removeCategory(category:String):void
        {
            // TODO: Will tend to break if any sounds are using this category.
            categories[category] = null;
            delete categories[category];
        }
        
        public function setCategoryMuted(category:String, value:Boolean):void
        {
            categories[category].muted = value;
            categories[category].dirty = true;
        }
        
        public function getCategoryMuted(category:String):Boolean
        {
            return categories[category].muted;
        }
        
        public function setCategoryVolume(category:String, value:Number):void
        {
            categories[category].transform.volume = value;
            categories[category].dirty = true;
        }
        
        public function getCategoryVolume(category:String):Number
        {
            return categories[category].transform.volume;
        }
        
        public function setCategoryTransform(category:String, transform:SoundTransform):void
        {
            categories[category].transform = transform;
            categories[category].dirty = true;            
        }
        
        public function getCategoryTransform(category:String):SoundTransform
        {
            return categories[category].transform;
        }
        
        public function stopCategorySounds(category:String):void
        {
            for(var i:int = 0; i< playingSounds.length; i++)
            {
                if((playingSounds[i] as SoundHandle).category != category)
                    continue;

                (playingSounds[i] as SoundHandle).stop();
                i--;//??
            }
        }

        public function stopAll():void
        {
            while(playingSounds.length)
			{
                (playingSounds[playingSounds.length-1] as SoundHandle).stop();
			}
        }
        
        public function getSoundHandlesInCategory(category:String, outArray:Array):void
        {
            for(var i:int=0; i<playingSounds.length; i++)
            {
                if((playingSounds[i] as SoundHandle).category != category)
                    continue;
                
                outArray.push(playingSounds[i]);
            }
        }
        
		override public function tick(deltaTime:Number):void
		{
			// Push dirty state down.
			if(!rootCategory.dirty)
			{
				// Each category must dirty its sounds.
				for(var categoryName:String in categories)
				{
					// Skip clean.
					if(categories[categoryName].dirty == false) continue;
					
					// OK, mark appropriate sounds as dirty.
					for(var j:int=0; j<playingSounds.length; j++)
					{
						var csh:SoundHandle = playingSounds[j] as SoundHandle;
						
						if(csh.category != categoryName) continue;
						
						csh.dirty = true;
					}
					
					// Clean the state.
					categories[categoryName].dirty = false;
				}
			}
			else
			{
				// Root state is dirty, so we can clean all the categories.
				for(var categoryName2:String in categories)
				{
					categories[categoryName2].dirty = false;
				}
			}
			
			// Now, update every dirty sound.
			var n:int = playingSounds.length;
			var curSoundHandle:SoundHandle;
			for(var i:int=0; i < n; i++)
			{
				curSoundHandle = playingSounds[i] as SoundHandle;
				if(curSoundHandle.dirty == false && rootCategory.dirty == false) continue;
				
				// It is dirty, so update the transform.
				if(curSoundHandle.channel)
				{
					curSoundHandle.channel.soundTransform = 
						SoundCategory.applyCategoriesToTransform(
							false, curSoundHandle.pan, curSoundHandle.volume, 
							rootCategory, categories[curSoundHandle.category]);                    
				}
				
				// Clean it.
				curSoundHandle.dirty = false;
			}
			
			// Clean the root category.
			rootCategory.dirty = false;
		}
        
        internal function isInPlayingSounds(sh:SoundHandle):Boolean
        {
            var idx:int = playingSounds.indexOf(sh);
            return idx != -1;
        }

        internal function removeSoundHandle(sh:SoundHandle):void
        {
            var idx:int = playingSounds.indexOf(sh);
            if(idx == -1)
                throw new Error("Could not find in list of playing sounds!");
            playingSounds.splice(idx, 1);
        }
    }
}