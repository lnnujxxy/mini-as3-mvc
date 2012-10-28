package framework.mvc.patterns
{
import framework.mvc.events.CommandEvent;

public class Command extends FacadeListener
{
	public function Command()
	{
	}
	
	public function execute( a_commandEvent : CommandEvent ) : void
	{
	
	}
	
	override protected function addListener( a_type : String, a_listener : Function ) : void
	{
		throw new Error( "commands cannot and will not wait or listen to events" );
	}
	
	override protected function removeListener( a_type : String, a_listener : Function ) : void
	{
		throw new Error( "commands cannot and will not wait or listen to events" );
	}
}
}
