// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Menu.m instead.

#import "_Menu.h"

const struct MenuAttributes MenuAttributes = {
	.id = @"id",
};

const struct MenuRelationships MenuRelationships = {
	.restaurant_owner = @"restaurant_owner",
	.sections = @"sections",
};

const struct MenuFetchedProperties MenuFetchedProperties = {
};

@implementation MenuID
@end

@implementation _Menu

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Menu" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Menu";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Menu" inManagedObjectContext:moc_];
}

- (MenuID*)objectID {
	return (MenuID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic id;






@dynamic restaurant_owner;

	

@dynamic sections;

	
- (NSMutableSet*)sectionsSet {
	[self willAccessValueForKey:@"sections"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"sections"];
  
	[self didAccessValueForKey:@"sections"];
	return result;
}
	






@end
