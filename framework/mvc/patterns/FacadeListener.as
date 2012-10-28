package framework.mvc.patterns
{
import framework.mvc.SingletonKeys;
import framework.mvc.SingletonManager;
import framework.mvc.Facade;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;


public class FacadeListener extends EventDispatcher
{
	protected var facade : Facade = SingletonManager.getSingleton( Facade, SingletonKeys.KEY_CMS );
	
	private var _eventDispatcher : IEventDispatcher = new EventDispatcher();
	
	public function FacadeListener()
	{
	
	}
	
	protected function addListener( type : String, listener : Function ) : void
	{
		facade.addEventListener( type, listener, false, 0, true );
	}
	
	protected function removeListener( type : String, listener : Function ) : void
	{
		facade.removeEventListener( type, listener );
	}
	
	override public function dispatchEvent( event : Event ) : Boolean
	{
		// lets play with this but is probablly not needed
		trace( '[dispatchEvent]: ', event.type );
		facade.dispatchEvent( event );
		return super.dispatchEvent( event );
	}
	
	public function dispose() : void
	{
		facade = null;
	}
	
	public function get eventDispatcher() : IEventDispatcher
	{
		return _eventDispatcher;
	}
	
	public function set eventDispatcher( value : IEventDispatcher ) : void
	{
		_eventDispatcher = value;
	}

}
}
