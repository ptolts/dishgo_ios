// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Sections.m instead.

#import "_Sections.h"

const struct SectionsAttributes SectionsAttributes = {
	.id = @"id",
	.name = @"name",
	.position = @"position",
};

const struct SectionsRelationships SectionsRelationships = {
	.dishes = @"dishes",
	.restaurant = @"restaurant",
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
	
	if ([key isEqualToString:@"positionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"position"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic id;






@dynamic name;






@dynamic position;



- (int16_t)positionValue {
	NSNumber *result = [self position];
	return [result shortValue];
}

- (void)setPositionValue:(int16_t)value_ {
	[self setPosition:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePositionValue {
	NSNumber *result = [self primitivePosition];
	return [result shortValue];
}

- (void)setPrimitivePositionValue:(int16_t)value_ {
	[self setPrimitivePosition:[NSNumber numberWithShort:value_]];
}





@dynamic dishes;

	
- (NSMutableOrderedSet*)dishesSet {
	[self willAccessValueForKey:@"dishes"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"dishes"];
  
	[self didAccessValueForKey:@"dishes"];
	return result;
}
	

@dynamic restaurant;

	






@end
