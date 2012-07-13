public interface ISObjectRepository
{
	SObject find( Id objectId );
	void save( SObject anSObject );
}