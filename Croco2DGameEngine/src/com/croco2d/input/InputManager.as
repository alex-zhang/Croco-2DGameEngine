package com.croco2d.input
{
	import com.croco2d.AppConfig;
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.CrocoObjectGroup;
	
	import flash.display.Sprite;
	
	import starling.core.Starling;

	/**
	 * A class managing input of any controllers that is an InputController.
	 * Actions are inspired by Midi signals, but they carry an InputAction object.
	 * "action signals" are either ON, OFF, or CHANGE.
	 * to track action status, and check whether action was just triggered or is still on,
	 * actions have phases (see InputAction).
	 **/	
	public class InputManager extends CrocoObject
	{
		public var globalMouseX:Number = 0.0;
		public var globalMouseY:Number = 0.0;
		
		/**
		 * time interval to clear the InputAction's disposed list automatically.
		 */
		public var clearDisposedActionsInterval:Number = 20;//s
		
		public var initInputControllers:Array;

		public var __clearDisposedActionsTime:Number = 0.0;
		public var _actions:Vector.<InputAction>;
		
		public var __inputControlllersGroup:CrocoObjectGroup;
		public var __inputControlllerNameMap:Array;//name->InputController
		
		public var __starlingNativeOverlay:Sprite;
		
		public function InputManager()
		{
			super();
			
			this.name = AppConfig.KEY_INPUT_MANAGER;
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			_actions = new Vector.<InputAction>();
			__inputControlllerNameMap = [];
			
			__inputControlllersGroup = new CrocoObjectGroup();
			__inputControlllersGroup.name = "__inputControlllersGroup";
			__inputControlllersGroup.initChildren = initInputControllers;
			__inputControlllersGroup.__onAddChildCallback = onAddInputController;
			__inputControlllersGroup.__onRemoveChildCallback = onRemoveInputController;
			
			__starlingNativeOverlay = Starling.current.nativeOverlay;
		}
		
		public function get length():int
		{
			return __inputControlllersGroup.length;
		}
		
		public function hasInputController(name:String):Boolean
		{
			return Boolean(__inputControlllerNameMap[name]);
		}
		
		public function findInputController(name:String):InputController
		{
			return __inputControlllerNameMap[name] as InputController;
		}
		
		public function addInputController(inputController:InputController):InputController
		{
			if(!inputController.name) throw new Error("InputManager::addInputController ObjectReferencePool must has a name.");
			if(hasInputController(inputController.name)) throw new Error("InputManager::addInputController " + inputController.name + " already exist!");
			
			return __inputControlllersGroup.addChild(inputController) as InputController;
		}
		
		protected function onAddInputController(inputController:InputController):void
		{
			__inputControlllerNameMap[inputController.name] = inputController;
			
			inputController.parent = __inputControlllersGroup;
			inputController.owner = this;
			
			inputController.init();
			inputController.active();
		}
		
		public function removeInputController(name:String, needDispose:Boolean = false):InputController
		{
			var targetInputController:InputController = findInputController(name);
			if(targetInputController)
			{
				return __inputControlllersGroup.removeChild(targetInputController, needDispose) as InputController;
			}
			
			return null;
		}
		
		public function onRemoveInputController(inputController:InputController, needDispose:Boolean = false):void
		{
			delete __inputControlllerNameMap[inputController.name];
			
			inputController.deactive();
			
			stopContrllerActions(inputController);
			
			if(needDispose)
			{
				inputController.dispose();
			}
		}
		
		public function stopContrllerActions(controller:InputController, channel:int = -1):void
		{
			var a:InputAction;
			for each (a in _actions)
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
		
		/**
		 * Returns the corresponding InputAction object if it has been triggered OFF in this frame or in the previous frame,
		 * or null.
		 */
		public function hasDone(actionName:String, channel:int = -1):InputAction
		{
			var a:InputAction;
			for each (a in _actions)
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
			for each (a in _actions)
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
			for each (a in _actions)
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
			for each (var a:InputAction in _actions)
			{
				if(a.eq(action))
				{
					a.mPhase = InputActionPhase.BEGIN;
					return;
				}
			}
			
			action.mPhase = InputActionPhase.BEGIN;
			_actions[_actions.length] = action;
		}
		
		/**
		 * Sets action to phase 3. will be advanced to phase 4 in next update, and finally will be removed
		 * on the update after that.
		 */
		internal function doActionOFF(action:InputAction):void
		{
			for each (var a:InputAction in _actions)
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
			for each (var a:InputAction in _actions)
			{
				if (a.eq(action))
				{
					a.mPhase = InputActionPhase.ON;
					a.mValue = action.mValue;
					return;
				}
			}
			
			action.mPhase = InputActionPhase.BEGIN;
			_actions[_actions.length] = action;
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
			globalMouseX = __starlingNativeOverlay.mouseX;
			globalMouseY = __starlingNativeOverlay.mouseY;
			
			//clear the InputAction pool.
			__clearDisposedActionsTime += deltaTime;
			if(__clearDisposedActionsTime > clearDisposedActionsInterval)
			{
				__clearDisposedActionsTime = 0.0;
				InputAction.clearDisposed();
			}
			
			super.tick(deltaTime);
			
			var ia:InputAction;
			var n:int = _actions.length;
			for(var i:int = n - 1; i >= 0; i--)
			{
				ia = _actions[i];
				ia.mTime++;
				
				if (ia.mPhase > InputActionPhase.END)
				{
					ia.dispose();
					_actions.splice(i, 1);
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
			
			__inputControlllerNameMap = null;
			
			if(_actions)
			{
				while(_actions.length)
				{
					_actions.pop().dispose();
				}
				_actions = null;
			}
			
			InputAction.clearDisposed();
		}
	}
}