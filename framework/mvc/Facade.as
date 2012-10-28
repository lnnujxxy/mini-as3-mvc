package framework.mvc
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import framework.mvc.patterns.Mediator;
	import framework.mvc.patterns.Proxy;
	
	public class Facade extends EventDispatcher
	{
		
		//protected static var _instance:Facade = new Facade();
		
		public var controller:Controller;
		public var model:Model;
		public var view:View;
		
		private var indexVec:Vector.<int>;
		
		private var m_index:int;
		
		private var m_postEventHook:Function;
		
		public function Facade()
		{
			/*
			if( _instance != null )
			{
				throw new Error( "Singleton and can only be accessed through Singleton.getInstance()" );
			}
			*/
			//_instance = this;
			initializeFacade();
		}
		
		public function setPostHook(hook:Function):void
		{
			m_postEventHook = hook;
		}

		protected function initializeFacade():void 
		{
			controller = new Controller();
			model = new Model();
			view = new View();
			
			m_index = 0;
			
			indexVec = new Vector.<int>();
		}		
		
		public function markRemoveStart():void
		{
			indexVec.push(m_index-1);
			
			trace("markRemoveStart, current index: "+m_index);
		}
		
		public function markRemoveEnd():void
		{
			if(indexVec.length==0)
			{
				return;
			}
			
			var after:int = indexVec.pop();
			
			disposeAfter(after);
		}
		
		public function removeAllMakrs():void
		{
			var len:int = indexVec.length;
			
			if(len==0)
			{
				return;
			}
			
			var after:int = indexVec[0];
			
			for(var i:int = 0; i<len; i++)
			{
				indexVec.pop();
			}
			
			disposeAfter(after);
		}
		
		/**
		 * Register an <code>ICommand</code> with the <code>Controller</code> by Notification name.
		 * 
		 * @param notificationName the name of the <code>INotification</code> to associate the <code>ICommand</code> with
		 * @param commandClassRef a reference to the Class of the <code>ICommand</code>
		 */
		public function registerCommand( notificationName:String, commandClassRef:Class ):void 
		{
			controller.registerCommand( notificationName, commandClassRef, m_index++ );
		}
		
		/**
		 * Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping from the Controller.
		 * 
		 * @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
		 */
		public function removeCommand( notificationName:String ):void 
		{
			controller.removeCommand( notificationName );
		}
		
		/**
		 * Check if a Command is registered for a given Notification 
		 * 
		 * @param notificationName
		 * @return whether a Command is currently registered for the given <code>notificationName</code>.
		 */
		public function hasCommand( notificationName:String ) : Boolean
		{
			return controller.hasCommand(notificationName);
		}
		
		
		/**
		 * Register an <code>IProxy</code> with the <code>Model</code> by name.
		 * 
		 * @param proxyName the name of the <code>IProxy</code>.
		 * @param proxy the <code>IProxy</code> instance to be registered with the <code>Model</code>.
		 */
		public function registerProxy ( proxy:Proxy ): Boolean	
		{
			return model.registerProxy ( proxy, m_index++);
		}
		
		/**
		 * Retrieve an <code>IProxy</code> from the <code>Model</code> by name.
		 * 
		 * @param proxyName the name of the proxy to be retrieved.
		 * @return the <code>IProxy</code> instance previously registered with the given <code>proxyName</code>.
		 */
		public function getProxy ( proxyName:String ): Proxy
		{
			return model.getProxy ( proxyName );	
		}
		
		/**
		 * Remove an <code>IProxy</code> from the <code>Model</code> by name.
		 *
		 * @param proxyName the <code>IProxy</code> to remove from the <code>Model</code>.
		 * @return the <code>IProxy</code> that was removed from the <code>Model</code>
		 */
		public function removeProxy ( proxyName:String ):Proxy 
		{
			var proxy:Proxy;
			if ( model != null ) proxy = model.removeProxy ( proxyName );	
			return proxy
		}
		
		/**
		 * Check if a Proxy is registered for a given Notification 
		 * 
		 * @param notificationName
		 * @return whether a Proxy is currently registered for the given <code>notificationName</code>.
		 */
		public function hasProxy( name:String ) : Boolean
		{
			return model.hasProxy(name);
		}
		
		/**
		 * Register a <code>IMediator</code> with the <code>View</code>.
		 * 
		 * @param mediatorName the name to associate with this <code>IMediator</code>
		 * @param mediator a reference to the <code>IMediator</code>
		 */
		public function registerMediator( mediator:Mediator ):void 
		{
			if ( view != null )
			{
				view.registerMediator( mediator, m_index++);
			}
		}
		
		/**
		 * Retrieve an <code>IMediator</code> from the <code>View</code>.
		 * 
		 * @param mediatorName
		 * @return the <code>IMediator</code> previously registered with the given <code>mediatorName</code>.
		 */
		public function getMediator( mediatorName:String ) : Mediator 
		{
			return view.getMediator( mediatorName ) as Mediator;
		}
		
		/**
		 * Remove an <code>IMediator</code> from the <code>View</code>.
		 * 
		 * @param mediatorName name of the <code>IMediator</code> to be removed.
		 * @return the <code>IMediator</code> that was removed from the <code>View</code>
		 */
		public function removeMediator( mediatorName:String ) : Mediator 
		{
			var mediator:Mediator;
			if ( view != null ) mediator = view.removeMediator( mediatorName );			
			return mediator;
		}
		
		/**
		 * Check if a Mediator is registered for a given Notification 
		 * 
		 * @param notificationName
		 * @return whether a Mediator is currently registered for the given <code>notificationName</code>.
		 */
		public function hasMediator( name:String ) : Boolean
		{
			return view.hasMediator(name);
		}
		
		/**
		 * Dispatch event.
		 * 
		 * @param event Event to dispatch
		 */
		override public function dispatchEvent(event:Event):Boolean
		{
			var ret:Boolean = super.dispatchEvent(event);
			if (m_postEventHook != null)
			{
				m_postEventHook(event);
			}
			return ret;
		}
		
		public function dispose () : void
		{
			if(indexVec.length == 0)
			{
				throw("the times you call for markRemoveStart is bigger than you call markRemoveEnd");
			}
			
			controller.dispose();
			controller = null;
			
			view.dispose();
			view = null;
			
			model.dispose();
			model = null;
		}
		
		public function disposeAfter (after:int) : void
		{
			// doesn't include 'after'
			if(after<m_index)
			{
				controller.disposeAfter(after);
				view.disposeAfter(after);
				model.disposeAfter(after);
				
				m_index = after+1;
			}

		}
	}
}