package framework.mvc
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	import framework.mvc.patterns.Mediator;

	public class View
	{
		
		// Mapping of Mediator names to Mediator instances
		protected var mediatorMap : Dictionary;
		protected var indexMap : Dictionary;
		
		public function View( )
		{
			mediatorMap = new Dictionary();
			indexMap = new Dictionary();
		}
		
		/**
		 * Register an <code>IMediator</code> instance with the <code>View</code>.
		 * 
		 * <P>
		 * Registers the <code>IMediator</code> so that it can be retrieved by name,
		 * and further interrogates the <code>IMediator</code> for its 
		 * <code>INotification</code> interests.</P>
		 * <P>
		 * If the <code>IMediator</code> returns any <code>INotification</code> 
		 * names to be notified about, an <code>Observer</code> is created encapsulating 
		 * the <code>IMediator</code> instance's <code>handleNotification</code> method 
		 * and registering it as an <code>Observer</code> for all <code>INotifications</code> the 
		 * <code>IMediator</code> is interested in.</p>
		 * 
		 * @param mediatorName the name to associate with this <code>IMediator</code> instance
		 * @param mediator a reference to the <code>IMediator</code> instance
		 */
		public function registerMediator( mediator:Mediator, index:int=0) : void
		{
			// do not allow re-registration (you must to removeMediator fist)
			if ( mediatorMap[ mediator.name ] != null ) 
			{
				throw( "Cant register a mediator more than once. Remove the first one" );
				return;
			}	
	
			
			// Register the Mediator for retrieval by name
			mediatorMap[ mediator.name ] = mediator;
			indexMap [ mediator.name ] = index;
			
//			trace("add resource: mediator "+mediator.name+" at pos "+index);
			
			// alert the mediator that it has been registered
			mediator.onRegister();
			
		}
		
		/**
		 * Retrieve an <code>IMediator</code> from the <code>View</code>.
		 * 
		 * @param mediatorName the name of the <code>IMediator</code> instance to retrieve.
		 * @return the <code>IMediator</code> instance previously registered with the given <code>mediatorName</code>.
		 */
		public function getMediator( mediatorName:String ) : Mediator
		{
			return mediatorMap[ mediatorName ];
		}
		
		/**
		 * Remove an <code>IMediator</code> from the <code>View</code>.
		 * 
		 * @param mediatorName name of the <code>IMediator</code> instance to be removed.
		 * @return the <code>IMediator</code> that was removed from the <code>View</code>
		 */
		public function removeMediator( mediatorName:String ) : Mediator
		{
			// Retrieve the named mediator
			var mediator:Mediator = mediatorMap[ mediatorName ] as Mediator;
			
			if ( mediator ) 
			{
				// for every notification this mediator is interested in...
				// remove the mediator from the map		
				mediatorMap[ mediatorName ] = null;
				delete mediatorMap[ mediatorName ];
				
				indexMap[ mediatorName ] = null;
				delete indexMap[ mediatorName ];
				
				// alert the mediator that it has been removed
				mediator.onRemove();
			}
			
			return mediator;
		}

		/**
		 * Removes all <code>IMediator</code> from the <code>View</code> that are registered.
		 */
		public function removeAllMediators() : void
		{
			for (var mediatorName:String in mediatorMap )
			{
				// Retrieve the named mediator
				var mediator : Mediator = mediatorMap[ mediatorName ]  as Mediator;
				
				// for every notification this mediator is interested in...
				// remove the mediator from the map
				mediatorMap[ mediatorName ] = null;
				delete mediatorMap[ mediatorName ];
				
				indexMap[ mediatorName ] = null;
				delete indexMap[ mediatorName ];
				
				// alert the mediator that it has been removed
				mediator.onRemove();
			}
		}		
		
		
		/**
		 * Check if a Mediator is registered or not
		 * 
		 * @param mediatorName
		 * @return whether a Mediator is registered with the given <code>mediatorName</code>.
		 */
		public function hasMediator( mediatorName:String ) : Boolean
		{
			return mediatorMap[ mediatorName ] != null;
		}
		
		/**
		 * Removes all the mediators in the dictionary and calls the remove function 
		 * @return 
		 * 
		 */
		public function disposeAllMediators () : Boolean
		{
			for ( var mediatorName:String in mediatorMap )
			{
				var mediator:Mediator = mediatorMap[ mediatorName ] as Mediator;
				mediator.dispose();
				mediatorMap[ mediatorName ] = null;
				delete mediatorMap[mediatorName];
				
				indexMap[ mediatorName ] = null;
				delete indexMap[ mediatorName ];
			}	
			return true;
		}
		
		public function disposeAfter (after:int) : void
		{
			var toBeDeletedMediators:Vector.<Mediator> = new Vector.<Mediator>();
			
			for ( var mediatorName:String in mediatorMap )
			{
				if(indexMap[ mediatorName ] > after)
				{
					toBeDeletedMediators.push(mediatorMap[ mediatorName ] as Mediator);
				}
			}	
			
			toBeDeletedMediators.sort(sortMediator);
			
			for each(var mediator:Mediator in toBeDeletedMediators) {
				
				indexMap[mediator.name] = null;
				delete indexMap[mediator.name];
				
				mediatorMap[mediator.name] = null;
				delete mediatorMap[mediator.name];
				
				mediator.dispose();
			}

		}
		
		private function sortMediator(a:Mediator, b:Mediator):Number
		{
			if(a==null || b==null) {
				return 0;
			} else {
				return indexMap[b.name] - indexMap[a.name];
			}
		}
		
		public function dispose () : void
		{
			disposeAllMediators();
			mediatorMap = null;
		}
		
	}
}