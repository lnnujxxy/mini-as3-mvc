package framework.mvc
{	
	import flash.utils.Dictionary;
	
	import framework.mvc.events.CommandEvent;
	import framework.mvc.patterns.Command;
	
	public class Controller
	{
		
		private var commandMap:Dictionary;
		private var indexMap:Dictionary;
		
		public function Controller()
		{
			commandMap = new Dictionary();	
			indexMap = new Dictionary();
		}
		
		public function registerCommand( notificationName : String, commandClassRef : Class, index:int=0 ) : void
		{
			if ( commandMap[ notificationName ] == null ) 
			{
				//view.registerObserver( notificationName, new Observer( executeCommand, this ) );
				var gameContext:Facade = SingletonManager.getSingleton( Facade, SingletonKeys.KEY_CMS );
				gameContext.addEventListener( notificationName, executeCommand, false, 0, true );
			}
			commandMap[ notificationName ] = commandClassRef;
			indexMap[ notificationName ] = index;
			
//			trace("add resource: command "+notificationName+" at pos "+index);
		}
		
		/**
		 * Check if a Command is registered for a given Notification 
		 * 
		 * @param notificationName
		 * @return whether a Command is currently registered for the given <code>notificationName</code>.
		 */
		public function hasCommand( notificationName:String ) : Boolean
		{
			return commandMap[ notificationName ] != null;
		}
		
		/**
		 * Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping.
		 * 
		 * @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
		 */
		public function removeCommand( notificationName : String ) : void
		{
			// if the Command is registered...
			if ( hasCommand( notificationName ) )
			{
				// remove the observer
				var gameContext:Facade = SingletonManager.getSingleton( Facade, SingletonKeys.KEY_CMS );
				gameContext.removeEventListener( notificationName, executeCommand );
				
				// remove the command
				commandMap[ notificationName ] = null;
				delete commandMap[ notificationName ];
				
				indexMap[ notificationName ] = null;
				delete indexMap[ notificationName ];
			}
		}
		
		public function executeCommand( event:CommandEvent ) : void
		{
			var commandClassRef : Class = commandMap[ event.type ];
			if ( commandClassRef == null ) return;
			
			var commandInstance : Command = new commandClassRef();
//			trace("will execute command "+commandClassRef+" under event "+event.type);
			commandInstance.execute( event );
		}
		
		public function removeAllCommands () : Boolean
		{
			for each ( var notificationName:String in commandMap )
			{
				var gameContext:Facade = SingletonManager.getSingleton( Facade, SingletonKeys.KEY_CMS );
				gameContext.removeEventListener( notificationName, executeCommand );
				
				commandMap[ notificationName ] = null;
				delete commandMap[ notificationName ];
				
				indexMap[ notificationName ] = null;
				delete indexMap[ notificationName ];
			}
			
			return true;
		}
		
		public function execute () : void
		{
			
		}
		
		public function dispose () : void
		{
			removeAllCommands();
			commandMap = null;
		}
		
		public function disposeAfter (after:int) : void
		{
			for each ( var notificationName:String in commandMap )
			{
				if(indexMap[ notificationName ] > after)
				{
					var gameContext:Facade = SingletonManager.getSingleton( Facade, SingletonKeys.KEY_CMS );
					gameContext.removeEventListener( notificationName, executeCommand );
					
					commandMap[ notificationName ] = null;
					delete commandMap[ notificationName ];
							
//					trace("remove command '"+notificationName+"' at ["+indexMap[ notificationName ]+"] which is after "+after);
					
					indexMap[ notificationName ] = null;
					delete indexMap[ notificationName ];
				}
			}
		}
	}
}