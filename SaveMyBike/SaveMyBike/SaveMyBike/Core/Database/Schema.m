#import "Schema.h"

#import "TrackingSession.h"
#import "TrackingSessionPoint.h"

@implementation Schema

- (bool)updateDatabase:(STSDBConnection *)db fromVersion:(int)iCurrentVersion
{
	STSDBSchemaUpdateTransaction * t;
	
	if(iCurrentVersion < 5)
	{
		t = [[STSDBSchemaUpdateTransaction alloc] initWithSchema:self andTargetVersion:5];
		
		[t addCreateTableUpdateStepWithTableName:[TrackingSession SQLTableName] andCreationSQL:[TrackingSession SQLScriptForTableCreation:db]];
		[t addCreateTableUpdateStepWithTableName:[TrackingSessionPoint SQLTableName] andCreationSQL:[TrackingSessionPoint SQLScriptForTableCreation:db]];
		
		if(![t executeOnDatabase:db])
			return false;
	}
	
	return true;
}


@end

