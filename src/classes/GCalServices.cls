public with sharing class GCalServices
{
	public static final String RFC3339 = 'yyyy-MM-dd\'T\'HH:mm:ss.SSS';
	
	public static List<GCalEvent> fetchEvents( String calendarURL )
	{
		List<GCalEvent> events = new List<GCalEvent>();
		
		DateTime rangeStart = DateTime.newInstance( Date.today().toStartOfWeek(), Time.newInstance(0, 0, 0, 0) );
		DateTime rangeEnd = rangeStart.addDays( 7 );
		
		calendarURL += '?start-min=' + rangeStart.format(RFC3339) + '&start-max=' + rangeEnd.format(RFC3339);
		
		Http h = new Http();
		
		HttpRequest req = new HttpRequest();
		req.setEndpoint( calendarURL );
		req.setMethod('GET');
		
		HttpResponse res = h.send( req );
		
		Dom.Document doc = res.getBodyDocument();
		
		Dom.XMLNode feed = doc.getRootElement();
		
		for( Dom.XMLNode childEl : feed.getChildElements() )
		{
			if( 'entry' != childEl.getName() )
				continue;
			
			GCalEvent event = new GCalEvent();
			
			for( Dom.XMLNode c : childEl.getChildElements() )
			{
				if( 'title' == c.getName() )
					event.setTitle( c.getText() );
				
				if( 'gCal:color' == c.getName() )
					System.debug( 'Foo' );
			}
			
			events.add( event );
			
			//GCalEvent event = new GCalEvent( title );
			//events.add( event );
		}
		
		System.debug( events );
		
		return events;
	}
}