package com.croco2dMGE.input
{
	import com.croco2dMGE.CrocoEngine;
	import com.croco2dMGE.core.CrocoBasic;

	/**
	 * InputController is the parent of all the controllers classes. It provides the same helper that CitrusObject class : 
	 * it can be initialized with a params object, which can be created via an object parser/factory. 
	 */
	public class InputController extends CrocoBasic
	{
		protected var mDefaultChannel:int = 0;
		
		protected var mAction:InputAction;
		
		public function InputController(name:String)
		{
			this.name = name;
		}
		
		/**
		 * Will register the action to the Input system as an action with an InputPhase.BEGIN phase.
		 * @param	name string that defines the action such as "jump" or "fly"
		 * @param	value optional value for your action.
		 * @param	message optional message for your action.
		 * @param	channel optional channel for your action. (will be set to the defaultChannel if not set.
		 */
		public function triggerON(name:String, value:Number = 0, message:String = null, channel:int = -1):InputAction
		{
			if (actived && CrocoEngine.input.actived)
			{
				mAction = InputAction.create(name, this, channel < 0 ? mDefaultChannel : channel , value, message);
				CrocoEngine.input.doActionON(mAction);
				return mAction;
			}
			
			return null;
		}
		
		/**
		 * Will register the action to the Input system as an action with an InputPhase.END phase.
		 * @param	name string that defines the action such as "jump" or "fly"
		 * @param	value optional value for your action.
		 * @param	message optional message for your action.
		 * @param	channel optional channel for your action. (will be set to the defaultChannel if not set.
		 */
		public function triggerOFF(name:String, value:Number = 0, message:String = null, channel:int = -1):InputAction
		{
			if (actived && CrocoEngine.input.actived)
			{
				mAction = InputAction.create(name, this, channel < 0 ? mDefaultChannel : channel , value, message);
				CrocoEngine.input.doActionOFF(mAction);
				return mAction;
			}
			
			return null;
		}
		
		/**
		 * Will register the action to the Input system as an action with an InputPhase.BEGIN phase if its not yet in the 
		 * actions list, otherwise it will update the existing action's value and set its phase back to InputPhase.ON.
		 * @param	name string that defines the action such as "jump" or "fly"
		 * @param	value optional value for your action.
		 * @param	message optional message for your action.
		 * @param	channel optional channel for your action. (will be set to the defaultChannel if not set.
		 */
		public function triggerCHANGE(name:String, value:Number = 0,message:String = null, channel:int = -1):InputAction
		{
			if (actived && CrocoEngine.input.actived)
			{
				mAction = InputAction.create(name, this, channel < 0 ? mDefaultChannel : channel, value, message);
				CrocoEngine.input.doActionCHANGE(mAction);
				return mAction;
			}
			
			return null;
		}
		
		/**
		 * Will register the action to the Input system as an action with an InputPhase.END phase if its not yet in the 
		 * actions list as well as a time to 1 (so that it will be considered as already triggered.
		 * @param	name string that defines the action such as "jump" or "fly"
		 * @param	value optional value for your action.
		 * @param	message optional message for your action.
		 * @param	channel optional channel for your action. (will be set to the defaultChannel if not set.
		 */
		public function triggerONCE(name:String, value:Number = 0, message:String = null, channel:int = -1):InputAction
		{
			if (actived)
			{
				mAction = InputAction.create(name, this, channel < 0 ? mDefaultChannel : channel , value, message, InputActionPhase.END);
				CrocoEngine.input.doActionON(mAction);
				
				mAction = InputAction.create(name, this, channel < 0 ? mDefaultChannel : channel , value, message, InputActionPhase.END);
				CrocoEngine.input.doActionOFF(mAction);
				
				return mAction;
			}
			return null;
		}
		
		public function get defaultChannel():uint
		{
			return mDefaultChannel;
		}
		
		public function set defaultChannel(value:uint):void
		{
			mDefaultChannel = value;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mAction)
			{
				mAction.dispose();	
				mAction = null;
			}
		}
	}
}