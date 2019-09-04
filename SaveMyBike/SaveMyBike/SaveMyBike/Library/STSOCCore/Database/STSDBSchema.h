//
//  STSDBSchema.h
//
//  Created by Szymon Tomasz Stefanek on 7/1/18.
//  Copyright © 2018 Szymon Tomasz Stefanek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STSDBConnection;
@class STSDBSchema;

@interface STSDBSchemaUpdateStep : NSObject
	- (bool)execute:(STSDBConnection *)db;
@end

@interface STSDBSchemaSQLUpdateStep : STSDBSchemaUpdateStep
	@property(nonatomic) NSString * sql;
	- (bool)execute:(STSDBConnection *)db;
@end

@interface STSDBSchemaCreateTableUpdateStep : STSDBSchemaUpdateStep
	@property(nonatomic) NSString * tableName;
	@property(nonatomic) NSString * sql;
	- (bool)execute:(STSDBConnection *)db;
@end

@interface STSDBSchemaUpdateTransaction : NSObject

	@property(nonatomic) int targetVersion;
	@property(nonatomic) NSMutableArray<STSDBSchemaUpdateStep *> * steps;
	@property(nonatomic) STSDBSchema * schema;

	- (id)initWithSchema:(STSDBSchema *)s andTargetVersion:(int)iTV;

	- (void)addCreateTableUpdateStepWithTableName:(NSString *)szTableName andCreationSQL:(NSString *)szSQL;
	- (void)addSQLUpdateStepWithSQL:(NSString *)szSQL;

	- (bool)executeOnDatabase:(STSDBConnection *)db;

@end


@interface STSDBSchema : NSObject

	- (void)setVersionTableName:(NSString *)szTableName andVersionField:(NSString *)szField;
	- (bool)updateIfNeeded:(STSDBConnection *)db;

	// PURE VIRTUAL: Implement this!
	- (bool)updateDatabase:(STSDBConnection *)db fromVersion:(int)iCurrentVersion;

	- (int)_getCurrentVersionFromDatabase:(STSDBConnection *)db;
	- (bool)_setCurrentVersion:(int)iVersion inDatabase:(STSDBConnection *)db;

@end
