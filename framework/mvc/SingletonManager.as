package casual.framework.patterns
{
	import flash.utils.Dictionary;

	public class SingletonManager
	{
		
		protected static var singletonMap:Dictionary;
		
		public function SingletonManager()
		{
		}
				
		/**
		 Creates a singleton out of a class without adapting or extending the class itself.
		 @param type: The class you want a to created a singleton from.
		 @return The singleton instance of the class.
		 @example
		 */
		public static function getSingleton( type : Class, core : String ):* 
		{
			if ( singletonMap == null)
				singletonMap = new Dictionary();
			
			if ( singletonMap[ core ] == null ) 
				singletonMap[ core ] = new Dictionary();
			
			var coreMap : Dictionary = singletonMap[ core ];
			
			return type in coreMap ? coreMap[type] : coreMap[type] = new type();
		}
		
		public static function removeCore ( core : String ) : Boolean
		{
			if ( singletonMap[ core ] )
			{
				var coreMap : Dictionary = singletonMap[ core ];
				for ( var key : String in coreMap )
				{
					coreMap[ key ] = null;
					delete coreMap[ key ];
				}
				
				singletonMap [ core ] = null;
				delete coreMap[ key ];
			}
			
			return false;
		}
		
		public static function dispose () : void
		{
			for ( var key:String in singletonMap )
			{
				removeCore( key );
				singletonMap[key] = null;
				delete singletonMap[key];
			}
			
			singletonMap = null;
		}
	}
}