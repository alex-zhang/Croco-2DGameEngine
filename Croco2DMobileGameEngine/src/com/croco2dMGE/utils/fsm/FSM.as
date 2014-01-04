package com.croco2dMGE.utils.fsm
{
    import com.fireflyLib.utils.PropertyBag;

    /**
     * Implementation of IMachine; probably any custom FSM would be based on this.
     *
     * @see IMachine for API docs.
     */
    public class FSM
    {
        /** 
         * Set of states, indexed by name.
         */
        public var states:Array = [];
        
        /**
         * What state will we start out in?
         */
        public var defaultStateName:String = null;
		
		public var propertyBag:PropertyBag = null;
        
        private var mPreviousState:FSMStateBasic = null;
        private var mCurrentState:FSMStateBasic = null;
        
        public function tick(deltaTime:Number):void
        {
            // DefaultState - we get it if no state is set.
            if(!mCurrentState)
			{
                setCurrentState(defaultStateName);
			}
            
            if(mCurrentState)
			{
                mCurrentState.tick(deltaTime);
				mCurrentState.checkFSMTransitions(deltaTime);
			}
        }
		
		public function dispose():void
		{
			for each(var state:FSMStateBasic in states)
			{
				state.dispose();
			}
			states = null;
			
			defaultStateName = null;
			mPreviousState = null;
			mCurrentState = null;
			propertyBag = null;
		}
        
		public function getState(name:String):FSMStateBasic
		{
			return states[name] as FSMStateBasic;
		}
		
		public function getCurrentState():FSMStateBasic
		{
			// DefaultState - we get it if no state is set.
			if(!mCurrentState)
			{
				setCurrentState(defaultStateName);
			}
			
			return mCurrentState;
		}
		
		public function getPreviousState():FSMStateBasic
		{
			return mPreviousState;
		}
		
        public function addState(state:FSMStateBasic):void
        {
            states[state.name] = state;
			state.fsm = this;
        }
        
        public function setCurrentState(name:String):Boolean
        {
            var newState:FSMStateBasic = getState(name);
            if(!newState) return false;
            
            var oldState:FSMStateBasic = mCurrentState;
            
			if(oldState != newState)
			{
				mPreviousState = mCurrentState;
				mCurrentState = newState;
					
				// Old state gets notified it is changing out.
				if(oldState)
				{
					oldState.exit();
				}
				
				// New state finds out it is coming in.    
				newState.enter();
				
				return true;
			}
			else
			{
				return false;
			}
        }
    }
}