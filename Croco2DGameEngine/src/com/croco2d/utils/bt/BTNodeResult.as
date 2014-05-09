package com.croco2d.utils.bt
{
	/**
	 * This is a simple enumeration, not intended for user instantiation.
	 * Use one of the static instances.
	 */
	public final class BTNodeResult
	{
		/**
		 * Status code to return if the task completes TRUEfully.
		 */
		public static const TRUE:BTNodeResult = new BTNodeResult();
		
		/**
		 * Status code to return if the task completes in FALSE.
		 */
		public static const FALSE:BTNodeResult = new BTNodeResult();
		
		/**
		 * Status code to return if the task does not complete, and needs
		 * more time.
		 */
		public static const MORE_TIME:BTNodeResult = new BTNodeResult();
		
		public function isTrue():Boolean
		{
			return this === TRUE;
		}
		
		public function isFalse():Boolean
		{
			return this === FALSE;
		}
		
		public function isMoreTime():Boolean
		{
			return this === MORE_TIME;
		}
		
		public function isNotFalse():Boolean
		{
			return this !== FALSE;
		}
		
		public function isNotTrue():Boolean
		{
			return this !== TRUE;	
		}
		
		public function isNotMoreTime():Boolean
		{
			return this !== MORE_TIME;
		}
		
		//!
		public function not():BTNodeResult
		{
			if(this === MORE_TIME) return MORE_TIME;
			
			if(this === FALSE) return TRUE;
			
			return FALSE;
		}
		
		//&&
		public function and(result:BTNodeResult):BTNodeResult
		{
			if(this === MORE_TIME || result === MORE_TIME) return MORE_TIME;
			
			if(this === TRUE && result === TRUE) return TRUE;
			
			return FALSE;
		}
		
		//not(and)
		public function nAnd(result:BTNodeResult):BTNodeResult
		{
			return this.and(result).not();
		}
		
		//not(or)
		public function nOr(result:BTNodeResult):BTNodeResult
		{
			return this.or(result).not();
		}
		
		//||
		public function or(result:BTNodeResult):BTNodeResult
		{
			if(this === MORE_TIME || result === MORE_TIME) return MORE_TIME;
			
			if(this === TRUE || result === TRUE) return TRUE;
			
			return FALSE;
		}
		
		//^
		public function xOr(result:BTNodeResult):BTNodeResult
		{
			if(this === MORE_TIME || result === MORE_TIME) return MORE_TIME;
			
			if(this === result) return FALSE;
			
			return TRUE; 
		}
		
		public function nXOr(result:BTNodeResult):BTNodeResult
		{
			return this.xOr(result).not();
		}
	}
}