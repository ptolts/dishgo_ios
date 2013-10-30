// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Subsections.m instead.

#import "_Subsections.h"

const struct SubsectionsAttributes SubsectionsAttributes = {
	.id = @"id",
	.name = @"name",
};

const struct SubsectionsRelationships SubsectionsRelationships = {
	.dishes = @"dishes",
	.section_owner = @"section_owner",
};

const struct SubsectionsFetchedProperties SubsectionsFetchedProperties = {
};

@implementation SubsectionsID
@end

@implementation _Subsections

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Subsections" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Subsections";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Subsections" inManagedObjectContext:moc_];
}

- (SubsectionsID*)objectID {
	return (SubsectionsID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic id;






@dynamic name;






@dynamic dishes;

	
- (NSMutableSet*)dishesSet {
	[self willAccessValueForKey:@"dishes"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"dishes"];
  
	[self didAccessValueForKey:@"dishes"];
	return result;
}
	

@dynamic section_owner;

	






@end
