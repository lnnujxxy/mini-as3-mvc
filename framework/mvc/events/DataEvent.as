/**
 * DataEvent.as
 *
 * Use this Event class if you need to pass a single
 * data object in an Event. Note that the data object
 * can be anything, and that you can retrieve it in
 * the function listening for the event.
 *
 * For example:
 *
 * private function onButtonClick( a_event : DataEvent ) : void
 * {
 * 		var data : Object = a_event.data;
 *
 * 		// Do stuff with data
 * }
 */
package framework.mvc.events
{
import flash.events.Event;

public class DataEvent extends Event
{
	/** @var	Event data */
	private var m_data : Object;
	
	public static const WINTER_FF_ACCEPT : String = "DataEvent:WinterFFAccept";
	
	public function DataEvent( a_type : String, a_data : Object = null, a_bubbles : Boolean = false,
		a_cancelable : Boolean = false )
	{
		super( a_type, a_bubbles, a_cancelable );
		
		m_data = a_data;
	}
	
	override public function clone() : Event
	{
		return new DataEvent( type, data, bubbles, cancelable );
	}
	
	/**
	 * @return	Data object associated with this event
	 */
	public function get data() : Object
	{
		return m_data;
	}
}
}
