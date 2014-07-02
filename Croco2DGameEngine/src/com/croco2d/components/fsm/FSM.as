package com.croco2d.components.fsm
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
		
		public var __propertyBag:PropertyBag = null;
		
        private var mPreviousState:FSMState = null;
        private var mCurrentState:FSMState = null;
		
		public function FSM()
		{
			super();
		}
		
		public final function get propertyBag():PropertyBag
		{
			if(!__propertyBag) __propertyBag = new PropertyBag();
			
			return __propertyBag;
		}
		
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
			for each(var state:FSMState in states)
			{
				state.dispose();
			}
			states = null;
			
			defaultStateName = null;
			mPreviousState = null;
			mCurrentState = null;
			
			if(__propertyBag)
			{
				__propertyBag.dispose();
				__propertyBag = null;
			}
		}
        
		public function getState(name:String):FSMState
		{
			return states[name] as FSMState;
		}
		
		public function getCurrentState():FSMState
		{
			// DefaultState - we get it if no state is set.
			if(!mCurrentState)
			{
				setCurrentState(defaultStateName);
			}
			
			return mCurrentState;
		}
		
		public function getPreviousState():FSMState
		{
			return mPreviousState;
		}
		
        public function addState(state:FSMState):void
        {
			if(!state.name) throw new Error("FSM::addState state name must be set!");
            states[state.name] = state;
			state.fsm = this;
        }
        
        public function setCurrentState(name:String):Boolean
        {
            var newState:FSMState = getState(name);
            if(!newState) return false;
            
            var oldState:FSMState = mCurrentState;
            
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