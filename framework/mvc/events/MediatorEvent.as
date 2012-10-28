package framework.mvc.events
{
	import flash.events.Event;
	
	public class MediatorEvent extends Event
	{
		public function MediatorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}