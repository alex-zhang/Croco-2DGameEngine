package com.croco2dMGE.utils.fsm
{
   /**
    * Basic, always-on transition.
    */
   public class FSMTransitionBasic
   {
	  public var targetStateName:String;
      
      public function FSMTransitionBasic(targetStateName:String = null)
      {
		  this.targetStateName = targetStateName;
      }
	  
      public function evaluate(fsm:FSM, deltaTime:Number):Boolean
      {
         return false;
      }
   }
}