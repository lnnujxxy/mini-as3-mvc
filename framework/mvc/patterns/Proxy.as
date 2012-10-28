package framework.mvc.patterns
{
import framework.mvc.Facade;

public class Proxy extends FacadeListener
{
	
	public var proxyName : String;
	
	public function Proxy( proxyName : String = null )
	{
		this.proxyName = proxyName; //(proxyName != null)?proxyName:NAME;
	}
	
	public function onRegister() : void
	{
	
	}
	
	public function get name() : String
	{
		return proxyName;
	}
	
	protected function getProxy( type : String ) : Proxy
	{
		return facade.model.getProxy( type );
	}
	
	/**
	 * Called by the Model when the Proxy is removed.
	 */
	public function onRemove() : void
	{
	
	}
	
	/**
	 * Called by the Model when the Proxy is removed.
	 * 
	 * DO NOT OVERRIDE
	 */
	override public function dispose() : void
	{
		onRemove();
		
		super.dispose();
	}
}
}
