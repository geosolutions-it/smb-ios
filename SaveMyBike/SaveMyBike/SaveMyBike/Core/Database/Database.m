#import "Database.h"

#import "STSCore.h"
#import "STSSQLiteDBConnection.h"
#import "Schema.h"

static Database * g_pDatabaseSingleton = nil;

@interface Database()
{
	STSSQLiteDBConnection * m_pDb;
}

@end


@implementation Database

- (id)init
{
	self = [super init];
	if(!self)
		return nil;
	
	return self;
}

- (void)_coreCreate;
{
	
}

- (void)_coreDestroy;
{
	[self cleanup];
}

+ (Database *)instance;
{
	return g_pDatabaseSingleton;
}

+ (void)create
{
	if(g_pDatabaseSingleton)
	{
		return;
	}
	g_pDatabaseSingleton = [Database new];
	[g_pDatabaseSingleton _coreCreate];
}

+ (void)destroy;
{
	if(!g_pDatabaseSingleton)
	{
		return;
	}
	[g_pDatabaseSingleton _coreDestroy];
	g_pDatabaseSingleton = nil;
}

- (bool)attachToPath:(NSString *)szPath
{
	STS_CORE_LOG(@"Database path %@",szPath);

	if(m_pDb)
		[self cleanup];
	
	m_pDb = [STSSQLiteDBConnection new];
	
	if(![m_pDb open:[NSString stringWithFormat:@"file=%@",szPath]])
	{
		STS_CORE_LOG_ERROR(@"Failed to open the database: %@",m_pDb.errorStack.buildMessage);
		m_pDb = nil;
		return false;
	}
	
	Schema * sh = [Schema new];
	if(![sh updateIfNeeded:m_pDb])
	{
		STS_CORE_LOG_ERROR(@"Failed to update the database");
		return false;
	}
	
	return true;
}

- (void)cleanup
{
	if(m_pDb)
	{
		[m_pDb close];
		m_pDb = nil;
	}
}

- (void)close
{
	[self cleanup];
}

- (STSDBConnection *)connection
{
	return m_pDb;
}


@end

