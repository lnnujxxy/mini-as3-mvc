package framework.mvc.events
{
	import flash.events.Event;
	
	import framework.mvc.Model;
	
	public class ModelEvent extends Event
	{
		
		public var model:Model;
		
		public function ModelEvent(type:String, model:Model, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.model = model;
			super(type, bubbles, cancelable);
		}
	}
}