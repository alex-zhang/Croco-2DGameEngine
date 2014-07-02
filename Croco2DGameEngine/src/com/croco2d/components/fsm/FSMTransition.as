package com.croco2d.components.fsm
{
   /**
    * Basic, always-on transition.
    */
   public class FSMTransition
   {
	  public var targetStateName:String;
      
      public function FSMTransition(targetStateName:String = null)
      {
		  this.targetStateName = targetStateName;
      }
	  
      public function evaluate(fsm:FSM, deltaTime:Number):Boolean
      {
         return false;
      }
   }
}