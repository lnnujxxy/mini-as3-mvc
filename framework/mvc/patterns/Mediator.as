package framework.mvc.patterns
{
	
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

public class Mediator extends FacadeListener
{
	// the mediator name
	protected var mediatorName : String;
	
	// The view component
	protected var viewComponent : DisplayObject;
	
	/**
	 * Constructor.
	 */
	public function Mediator( a_mediatorName : String = null, a_viewComponent : DisplayObject = null )
	{
		this.mediatorName = a_mediatorName;
		this.viewComponent = a_viewComponent;
	}
	
	public function get name() : String
	{
		return mediatorName;
	}
	
	/**
	 * Set the <code>IMediator</code>'s view component.
	 *
	 * @param Object the view component
	 */
	public function setViewComponent( viewComponent : DisplayObject ) : void
	{
		this.viewComponent = viewComponent;
	}
	
	public function onRegister() : void
	{
	}
	
	/**
	 * Called by the View when the Mediator is removed.
	 */
	public function onRemove() : void
	{
		viewComponent = null;
	}
	
	/**
	 * Called by the View when the Mediator is removed.
	 * 
	 * DO NOT OVERRIDE
	 */
	override public function dispose() : void
	{
		// AC - viewComponent is just a refernce to some other object (i.e. swf container) let the container handle the destruction
		onRemove();
		
		super.dispose();
	}
}
}
