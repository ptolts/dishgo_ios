// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Subsections.m instead.

#import "_Subsections.h"

const struct SubsectionsAttributes SubsectionsAttributes = {
	.id = @"id",
	.name = @"name",
	.position = @"position",
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
	

@dynamic section_owner;

	






@end
