package framework.mvc
{
import flash.utils.Dictionary;

import framework.mvc.patterns.Proxy;

public class Model
{
	
	private var proxyMap : Dictionary;
	private var indexMap : Dictionary;
	
	public function Model()
	{
		proxyMap = new Dictionary();
		indexMap = new Dictionary();
	}
	
	/**
	 * Register an <code>IProxy</code> with the <code>Model</code>.
	 *
	 * @param proxy an <code>IProxy</code> to be held by the <code>Model</code>.
	 */
	public function registerProxy( proxy : Proxy , index:int=0) : Boolean
	{
		
		if( proxyMap[ proxy.name ] )
		{
			throw( "ERROR: Proxy already exsists!!" );
			return false;
		}
		
		proxyMap[ proxy.name ] = proxy;
		indexMap [ proxy.name ] = index;
		
//		trace("add resource: proxy "+ proxy.name + " at pos "+index);
		
		proxy.onRegister();
		
		return true;
	}
	
	/**
	 * Retrieve an <code>IProxy</code> from the <code>Model</code>.
	 *
	 * @param proxyName
	 * @return the <code>IProxy</code> instance previously registered with the given <code>proxyName</code>.
	 */
	public function getProxy( proxyName : String ) : Proxy
	{
		return proxyMap[ proxyName ];
	}
	
	/**
	 * Check if a Proxy is registered
	 *
	 * @param proxyName
	 * @return whether a Proxy is currently registered with the given <code>proxyName</code>.
	 */
	public function hasProxy( proxyName : String ) : Boolean
	{
		return proxyMap[ proxyName ] != null;
	}
	
	/**
	 * Remove an <code>IProxy</code> from the <code>Model</code>.
	 *
	 * @param proxyName name of the <code>IProxy</code> instance to be removed.
	 * @return the <code>IProxy</code> that was removed from the <code>Model</code>
	 */
	public function removeProxy( proxyName : String ) : Proxy
	{
		var proxy : Proxy = proxyMap[ proxyName ] as Proxy;
		if( proxy )
		{
			proxyMap[ proxyName ] = null;
			delete proxyMap[ proxyName ];
			
			indexMap[ proxyName ] = null;
			delete indexMap[ proxyName ];
			
//			trace("proxy "+proxyName+" is removed in removeProxy");
			
			proxy.onRemove();
		}
		return proxy;
	}
	
	public function removeAllProxies() : Boolean
	{
		for( var proxyName : String in proxyMap )
		{
			var proxy : Proxy = proxyMap[ proxyName ] as Proxy;
			proxy.dispose();
			proxyMap[ proxyName ] = null;
			delete proxyMap[ proxyName ];
			
			indexMap[ proxyName ] = null;
			delete indexMap[ proxyName ];
			
//			trace("proxy "+proxyName+" is removed in removeAllProxies");
		}
		return true;
	}
	
	public function dispose() : void
	{
		removeAllProxies();
		proxyMap = null;
	}
	
	public function disposeAfter(after:int) : void
	{
		for( var proxyName : String in proxyMap )
		{
			if(indexMap[ proxyName ]>after)
			{
				var proxy : Proxy = proxyMap[ proxyName ] as Proxy;
				proxy.dispose();
				proxyMap[ proxyName ] = null;
				delete proxyMap[ proxyName ];
				
//				trace("remove proxy '"+proxyName+"' at ["+indexMap[ proxyName ]+"] which is after "+after);
				
				indexMap[ proxyName ] = null;
				delete indexMap[ proxyName ];
			}
		}
	}
}
}
