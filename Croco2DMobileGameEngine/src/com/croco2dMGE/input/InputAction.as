package com.croco2dMGE.input
{
	/**
	 * InputAction reinforces the Action object structure (and typing.)
	 * it contains static action phase constants as well as helpful comparators.
	 */
	public class InputAction
	{
		// ------------ InputAction Pooling
		/**
		 * list of disposed InputActions. automatically disposed when they end in Input.as
		 */
		internal static var disposed:Vector.<InputAction> = new Vector.<InputAction>();
		
		/**
		 * creates an InputAction either from a disposed InputAction object or a new one.
		 */
		public static function create(name:String, 
									  controller:InputController = null,
									  channel:uint = 0, 
									  value:Number = 0, 
									  message:String = null, 
									  phase:uint = 0, 
									  time:uint = 0):InputAction
		{
			if(disposed.length > 0)
			{
				return disposed.pop().setTo(name, controller, channel, value, message, phase, time);
			}
			else
			{
				return new InputAction(name, controller, channel, value, message, phase, time);
			}
		}
		
		/**
		 * clear the list of disposed InputActions.
		 */
		public static function clearDisposed():void
		{
			disposed.length = 0;
		}

	
		//read only action keys
		private var mName:String;
		private var mController:InputController
		private var mChannel:uint;
		
		internal var mValue:Number;
		internal var mMessage:String;
		internal var mPhase:uint;
		internal var mTime:uint = 0;
		
		public function InputAction(name:String, 
									controller:InputController = null,
									channel:uint = 0, 
									value:Number = 0, 
									message:String = null, 
									phase:uint = 0, 
									time:uint = 0)
		{
			mName = name;
			mController = controller;
			mChannel = channel;
			mValue = value;
			mMessage = message;
			mPhase = phase;
			mTime = time;
		}
		
		/**
		 * Clones the action and returns a new InputAction instance with the same properties.
		 */
		public function clone():InputAction
		{
			return InputAction.create(mName, mController, mChannel , mValue, mMessage, mPhase, mTime);
		}
		
		public function eq(action:InputAction):Boolean
		{
			return mName == action.mName && mController ==action.mController && mChannel == action.mChannel;
		}
		
		public function toString():String
		{
			return "\n[ Action # name: " + mName + " channel: " + mChannel + " value: " + mValue + " phase: " + mPhase + " time: " + mTime + " ]";
		}
		
		public function get name():String { return mName; }
		
		
		public function get controller():InputController { return mController; }
		
		/**
		 * action channel id.
		 */
		public function get channel():uint { return mChannel; }
		/**
		 * time (in frames) the action has been 'running' in the Input system.
		 */
		public function get time():uint { return mTime; }
		
		/**
		 * value the action carries
		 */
		public function get value():Number { return mValue; }
		
		/**
		 * message the action carries
		 */
		public function get message():String { return mMessage;  }
		
		/**
		 * action phase
		 */
		public function get phase():Number { return mPhase; }
		
		/**
		 * set all InputActions's properties (internal for recycling)
		 */
		internal function setTo(name:String, 
								controller:InputController,
								channel:uint = 0, 
								value:Number = 0, 
								message:String = null, 
								phase:uint = 0, 
								time:uint = 0):InputAction
		{
			mName = name;
			mController = controller;
			mChannel = channel;
			mValue = value;
			mMessage = message;
			mPhase = phase;
			mTime = time;
			
			return this;
		}

		public function dispose():void
		{
			mController = null;
			mName = null;
			
			var a:InputAction;
			for each(a in disposed)
			{
				if(this === a) return;
			}
			
			disposed.push(this);
		}
	}
}