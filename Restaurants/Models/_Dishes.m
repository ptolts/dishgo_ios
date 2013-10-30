// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Dishes.m instead.

#import "_Dishes.h"

const struct DishesAttributes DishesAttributes = {
	.id = @"id",
	.name = @"name",
};

const struct DishesRelationships DishesRelationships = {
	.images = @"images",
	.options = @"options",
	.subsection = @"subsection",
};

const struct DishesFetchedProperties DishesFetchedProperties = {
};

@implementation DishesID
@end

@implementation _Dishes

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Dishes" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Dishes";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Dishes" inManagedObjectContext:moc_];
}

- (DishesID*)objectID {
	return (DishesID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic id;






@dynamic name;






@dynamic images;

	
- (NSMutableSet*)imagesSet {
	[self willAccessValueForKey:@"images"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"images"];
  
	[self didAccessValueForKey:@"images"];
	return result;
}
	

@dynamic options;

	
- (NSMutableSet*)optionsSet {
	[self willAccessValueForKey:@"options"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"options"];
  
	[self didAccessValueForKey:@"options"];
	return result;
}
	

@dynamic subsection;

	






@end
