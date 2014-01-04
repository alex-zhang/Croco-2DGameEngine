package com.croco2dMGE.utils.fsm
{
    
    /**
     * Simple state that allows for generic transition rules.
     * 
     * This tries each transition in order, and takes the first one that
     * evaluates to true and that succesfully changes state.
     * 
     * More complex state behavior can probably be derived from this class.
     */
    public class FSMStateBasic
    {
        /**
         * List of subclasses of ITransition that are evaluated to transition to
         * new states.
         */ 
        public var transitions:Vector.<FSMTransitionBasic> = new Vector.<FSMTransitionBasic>();
		public var fsm:FSM;
		public var name:String = null;
		
		public function FSMStateBasic(name:String)
		{
			this.name = name;
		}
		
		public function dispose():void
		{
			name = null;
			transitions = null;
			fsm = null;
		}
		
        public function addTransition(t:FSMTransitionBasic):void
        {
            transitions[transitions.length] = t;
			
        }
        
		public function enter():void
		{
		}
		
        public function tick(deltaTime:Number):void
        {
        }

		public function checkFSMTransitions(deltaTime:Number):void
		{
			var transition:FSMTransitionBasic;
			var n:int = transitions.length;
			
			for(var i:int = 0; i < n; i++)
			{
				transition = transitions[i];
				
				if(transition.evaluate(fsm, deltaTime) && 
					fsm.setCurrentState(transition.targetStateName))
				{
					return;
				}
			}	
		}
        
        public function exit():void
        {
        }
    }
}