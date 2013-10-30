// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Sections.m instead.

#import "_Sections.h"

const struct SectionsAttributes SectionsAttributes = {
	.id = @"id",
	.name = @"name",
};

const struct SectionsRelationships SectionsRelationships = {
	.restaurant = @"restaurant",
	.subsections = @"subsections",
};

const struct SectionsFetchedProperties SectionsFetchedProperties = {
};

@implementation SectionsID
@end

@implementation _Sections

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Sections" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Sections";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Sections" inManagedObjectContext:moc_];
}

- (SectionsID*)objectID {
	return (SectionsID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic id;






@dynamic name;






@dynamic restaurant;

	

@dynamic subsections;

	
- (NSMutableSet*)subsectionsSet {
	[self willAccessValueForKey:@"subsections"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"subsections"];
  
	[self didAccessValueForKey:@"subsections"];
	return result;
}
	






@end
