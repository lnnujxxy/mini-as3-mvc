package framework.mvc.events
{

	import flash.events.Event;
	
	public class CommandEvent extends DataEvent
	{
		
		public function CommandEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new CommandEvent( type, data, bubbles, cancelable );
		}
	}
}