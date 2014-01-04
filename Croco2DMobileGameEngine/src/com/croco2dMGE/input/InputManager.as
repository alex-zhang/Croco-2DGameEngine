package com.croco2dMGE.input
{
	import com.croco2dMGE.AppConfig;
	import com.croco2dMGE.CrocoEngine;
	import com.croco2dMGE.core.CrocoBasic;
	import com.croco2dMGE.core.CrocoGroup;
	import com.croco2dMGE.core.CrocoListGroup;
	import com.croco2dMGE.input.controllers.KeyboardController;

	/**
	 * A class managing input of any controllers that is an InputController.
	 * Actions are inspired by Midi signals, but they carry an InputAction object.
	 * "action signals" are either ON, OFF, or CHANGE.
	 * to track action status, and check whether action was just triggered or is still on,
	 * actions have phases (see InputAction).
	 **/	
	public class InputManager extends CrocoListGroup
	{
		public static var hasKeyboardController:Boolean = false;
		
		protected var mActions:Vector.<InputAction>;
		
		/**
		 * time interval to clear the InputAction's disposed list automatically.
		 */
		public var clearDisposedActionsInterval:Number = 20;//s
		
		protected var mClearDisposedActionsTime:Number = 0.0;
		
		public function InputManager()
		{
			this.name = "inputManager";
			
			mActions = new Vector.<InputAction>();
			
			visible = false;
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			if(CrocoEngine.debug || InputManager.hasKeyboardController)
			{
				addController(new KeyboardController(AppConfig.KEY_KEY_BOARD_CONTROLLER));
			}
		}
		
		private var mControlllerNameMap:Array = [];
		
		public function addController(controller:InputController):InputController
		{
			return super.addItem(controller) as InputController;
		}
		
		override protected function onItemAdded(item:CrocoBasic):void
		{
			super.onItemAdded(item);
			
			mControlllerNameMap[item.name] = item;
		}
		
		public function removeController(controller:InputController):InputController
		{
			return super.removeItem(controller) as InputController;
		}
		
		public function getController(name:String):InputController
		{
			return mControlllerNameMap[name];
		}
		
		public function hasController(name:String):Boolean
		{
			return mControlllerNameMap[name] !== undefined;
		}
		
		override protected function onItemRemoved(item:CrocoBasic):void
		{
			super.onItemRemoved(item);
			
			delete mControlllerNameMap[item.name];
			
			var inputController:InputController = item as InputController;
			
			stopContrllerActions(inputController);
		}
		
		public function stopContrllerActions(controller:InputController, channel:int = -1):void
		{
			var a:InputAction;
			for each (a in mActions)
			{
				if(a.controller != controller) continue;
				
				if(channel > -1)
				{
					if(a.channel == channel)
					{
						a.mPhase = InputActionPhase.ENDED;
					}
				}
				else
				{
					a.mPhase = InputActionPhase.ENDED;
				}
			}
		}
		
		//dead end
		override public function addItem(item:CrocoBasic):CrocoBasic { return null };
		override public function removeItem(item:CrocoBasic):CrocoBasic { return null };
		override public function switchItemTo(item:CrocoBasic, target:CrocoGroup):CrocoBasic { return null };
		
		
		/**
		 * Returns the corresponding InputAction object if it has been triggered OFF in this frame or in the previous frame,
		 * or null.
		 */
		public function hasDone(actionName:String, channel:int = -1):InputAction
		{
			var a:InputAction;
			for each (a in mActions)
			{
				if (a.name == actionName && 
					(channel > -1 ? a.channel == channel : true ) && 
					a.phase == InputActionPhase.END)
					
					return a;
			}
				
			return null;
		}
		
		/**
		 * Returns the corresponding InputAction object if it has been triggered on the previous frame or is still going,
		 * or null.
		 */
		public function isDoing(actionName:String, channel:int = -1):InputAction
		{
			var a:InputAction;
			for each (a in mActions)
			{
				if (a.name == actionName && 
					(channel > -1 ? a.channel == channel : true ) && 
					a.mTime > 1 && a.phase < InputActionPhase.END)
					
					return a;
			}
				
			return null;
		}
		
		/**
		 * Returns the corresponding InputAction object if it has been triggered on the previous frame.
		 */
		public function justDid(actionName:String, channel:int = -1):InputAction
		{
			var a:InputAction;
			for each (a in mActions)
			{
				if (a.name == actionName && 
					(channel > -1 ? a.channel == channel : true ) && 
					a.mTime == 1)
					
					return a;
			}
				
			return null;
		}
		
		/**
		 * Adds a new action of phase 0 if it does not exist.
		 */
		internal function doActionON(action:InputAction):void
		{
			for each (var a:InputAction in mActions)
			{
				if(a.eq(action))
				{
					a.mPhase = InputActionPhase.BEGIN;
					return;
				}
			}
			
			action.mPhase = InputActionPhase.BEGIN;
			mActions[mActions.length] = action;
		}
		
		/**
		 * Sets action to phase 3. will be advanced to phase 4 in next update, and finally will be removed
		 * on the update after that.
		 */
		internal function doActionOFF(action:InputAction):void
		{
			for each (var a:InputAction in mActions)
			{
				if (a.eq(action))
				{
					a.mPhase = InputActionPhase.END;
					return;
				}
			}
		}
		
		/**
		 * Changes the value property of an action, or adds action to list if it doesn't exist.
		 * a continuous controller, can simply trigger ActionCHANGE and never have to trigger ActionON.
		 * this will take care adding the new action to the list, setting its phase to 0 so it will respond
		 * to justDid, and then only the value will be changed. - however your continous controller DOES have
		 * to end the action by triggering ActionOFF.
		 */
		internal function doActionCHANGE(action:InputAction):void
		{
			for each (var a:InputAction in mActions)
			{
				if (a.eq(action))
				{
					a.mPhase = InputActionPhase.ON;
					a.mValue = action.mValue;
					return;
				}
			}
			
			action.mPhase = InputActionPhase.BEGIN;
			mActions[mActions.length] = action;
		}
		
		/**
		 * Input.update is called in the end of your state update.
		 * keep this in mind while you create new controllers - it acts only after everything else.
		 * update first updates all registered controllers then finally
		 * advances actions phases by one if not phase 2 (phase two can only be voluntarily advanced by
		 * doActionOFF.) and removes actions of phase 4 (this happens one frame after doActionOFF was called.)
		 */
		override public function tick(deltaTime:Number):void
		{
			//clear the InputAction pool.
			mClearDisposedActionsTime += deltaTime;
			if(mClearDisposedActionsTime > clearDisposedActionsInterval)
			{
				mClearDisposedActionsTime = 0.0;
				InputAction.clearDisposed();
			}
			
			super.tick(deltaTime);
			
			var ia:InputAction;
			var n:int = mActions.length;
			for(var i:int = n - 1; i >= 0; i--)
			{
				ia = mActions[i];
				ia.mTime++;
				
				if (ia.mPhase > InputActionPhase.END)
				{
					ia.dispose();
					mActions.splice(i, 1);
				}
				else if (ia.phase !== InputActionPhase.ON)
				{
					ia.mPhase++;
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mActions)
			{
				while(mActions.length)
				{
					mActions.pop().dispose();
				}
				mActions = null;
			}
			
			InputAction.clearDisposed();
		}
	}
}