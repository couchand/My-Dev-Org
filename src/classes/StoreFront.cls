public with sharing class StoreFront {
/*
	public PageReference shop(){
		message = 'You have purchased: ';
		for (DisplayMerch item: products){
			
			if (item.count > 0){
				message += item.merch.name + ' (' + item.count + ')   ';
			}
			
		}
		return null;
	}
	
	DisplayMerch[] products;
	public String message { get; set; }
	
	public class DisplayMerch {
		
		public Schlock__c merch { get; set; }
		public Decimal count { get; set; }
		public DisplayMerch(Schlock__c item){
			this.merch = item;
		}
		
	}
	
	public DisplayMerch[] getProducts(){
		
		if (null == products){
			
			products = new DisplayMerch[]{};
			for( Schlock__c item: [select id, name, What_Is_It__c, Value__c from Schlock__c where How_Many_Do_We_Have__c > 0] ){
				
				products.add(new DisplayMerch(item));
				
			}
			
		}
		return products;
		
	}
*/
}