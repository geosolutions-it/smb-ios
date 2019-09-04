//
//  STSDBSchema.m
//
//  Created by Szymon Tomasz Stefanek on 7/1/18.
//  Copyright © 2018 Szymon Tomasz Stefanek
//

#import "STSDBSchema.h"
#import "STSDBConnection.h"
#import "STSDBRecordset.h"
#import "STSCore.h"
#import "STSSQLDropTableQueryBuilder.h"


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@implementation STSDBSchemaUpdateStep

- (bool)execute:(STSDBConnection *)db
{
	return false;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation STSDBSchemaSQLUpdateStep

- (bool)execute:(STSDBConnection *)db
{
	if(![db execute:self.sql])
	{
		STS_CORE_LOG_ERROR(@"Failed to execute SQL update step: %@",[db.errorStack buildMessage]);
		return false;
	}
	return true;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation STSDBSchemaCreateTableUpdateStep

- (bool)execute:(STSDBConnection *)db
{
	STSSQLDropTableQueryBuilder * qb = [db createDropTableQueryBuilder];
	qb.tableName = self.tableName;
	qb.ignoreInexistingTable = true;

	if(![db execute:[qb build]])
	{
		STS_CORE_LOG_ERROR(@"Failed to execute create table update drop step for table %@: %@",self.tableName,[db.errorStack buildMessage]);
		return false;
	}

	if(![db execute:self.sql])
	{
		STS_CORE_LOG_ERROR(@"Failed to execute create table update step for table %@: %@",self.tableName,[db.errorStack buildMessage]);
		return false;
	}

	return true;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation STSDBSchemaUpdateTransaction

	- (id)initWithSchema:(STSDBSchema *)s andTargetVersion:(int)iTV;
	{
		self = [super init];
		if(!self)
			return nil;
		
		self.targetVersion = iTV;
		self.schema = s;
		self.steps = [NSMutableArray new];
		
		return self;
	}

	- (void)addCreateTableUpdateStepWithTableName:(NSString *)szTableName andCreationSQL:(NSString *)szSQL
	{
		STSDBSchemaCreateTableUpdateStep * s = [STSDBSchemaCreateTableUpdateStep new];
		s.tableName = szTableName;
		s.sql = szSQL;
		[self.steps addObject:s];
	}

	- (void)addSQLUpdateStepWithSQL:(NSString *)szSQL
	{
		STSDBSchemaSQLUpdateStep * s = [STSDBSchemaSQLUpdateStep new];
		s.sql = szSQL;
		[self.steps addObject:s];
	}

	- (bool)executeOnDatabase:(STSDBConnection *)db
	{
		STS_CORE_LOG(@"Attempting to update database to version %d",self.targetVersion);
		
		if(![db beginTransaction])
		{
			STS_CORE_LOG_ERROR(@"Failed to start transaction");
			return false;
		}
		
		for(STSDBSchemaUpdateStep * s in self.steps)
		{
			if(![s execute:db])
			{
				STS_CORE_LOG_ERROR(@"Update step failed: rolling back!");
				if(![db rollbackTransaction])
				{
					STS_CORE_LOG_ERROR(@"Additionally failed to rollback transaction!");
				}
				return false;
			}
		}
		
		if(![self.schema _setCurrentVersion:self.targetVersion inDatabase:db])
		{
			STS_CORE_LOG_ERROR(@"Failed to update database version: rolling back!");
			if(![db rollbackTransaction])
			{
				STS_CORE_LOG_ERROR(@"Additionally failed to rollback transaction!");
			}
			return false;
		}
		
		if(![db commitTransaction])
		{
			STS_CORE_LOG_ERROR(@"Failed to commit transaction: rolling back!");
			if(![db rollbackTransaction])
			{
				STS_CORE_LOG_ERROR(@"Additionally failed to rollback transaction!");
			}
			return false;
		}
		
		return true;
	}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation STSDBSchema
{
	NSString * m_szVersionTable;
	NSString * m_szVersionField;
}

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	m_szVersionTable = @"T_DatabaseVersion";
	m_szVersionField = @"DV_Version";
	
	return self;
}

- (void)setVersionTableName:(NSString *)szTableName andVersionField:(NSString *)szField
{
	m_szVersionField = szField;
	m_szVersionTable = szTableName;
}

- (int)_getCurrentVersionFromDatabase:(STSDBConnection *)db
{
	int iVer = 0;
	STSDBRecordset * r = [db query:[NSString stringWithFormat:@"select %@ from %@",m_szVersionField,m_szVersionTable]];
	if(!r)
	{
		STS_CORE_LOG(@"Version table doesn't seem to exist: trying to create it");
		
		if(![db execute:[NSString stringWithFormat:@"create table %@(%@ int not null default 0)",m_szVersionTable,m_szVersionField]])
		{
			STS_CORE_LOG_ERROR(@"Failed to create the version table!");
			[NSException raise:@"DbUpdateFaield" format:@"Failed to creat the version table"];
			return -1;
		}
		
		return 0;
	}
	
	if(![r read])
	{
		STS_CORE_LOG(@"There are no version records: assuming version is 0");
		[r close];
		return 0;
	}
	
	iVer = [r intField:m_szVersionField withDefault:-1];
	STS_CORE_LOG(@"Current database version is %d",iVer);
	
	[r close];
	return iVer;
}

- (bool)_setCurrentVersion:(int)iVersion inDatabase:(STSDBConnection *)db
{
	if(![db execute:[NSString stringWithFormat:@"delete from %@",m_szVersionTable]])
	{
		STS_CORE_LOG_ERROR(@"Failed to delete records from the version table: %@",db.errorStack.buildMessage);
		return false;
	}
	if(![db execute:[NSString stringWithFormat:@"insert into %@(%@) values(%d)",m_szVersionTable,m_szVersionField,iVersion]])
	{
		STS_CORE_LOG_ERROR(@"Failed to inserty records to the version table: %@",db.errorStack.buildMessage);
		return false;
	}
	return true;
}

- (bool)updateIfNeeded:(STSDBConnection *)db
{
	[db.errorStack clear];
	
	int iVer = [self _getCurrentVersionFromDatabase:db];
	if(iVer < 0)
	{
		STS_CORE_LOG_ERROR(@"Failed to retrieve current version");
		[NSException raise:@"DbUpdateFail" format:@"Failed to retrieve current database version"];
		return false;
	}
	
	return [self updateDatabase:db fromVersion:iVer];
}

- (bool)updateDatabase:(STSDBConnection *)db fromVersion:(int)iCurrentVersion
{
	[NSException raise:@"Implementation Missing" format:@"Must implement updateDatabase:fromVersion"];
	return false;
}


@end
