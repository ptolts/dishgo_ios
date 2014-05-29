// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Options.m instead.

#import "_Options.h"

const struct OptionsAttributes OptionsAttributes = {
	.id = @"id",
	.max = @"max",
	.min = @"min",
	.name = @"name",
	.type = @"type",
};

const struct OptionsRelationships OptionsRelationships = {
	.dish_owner = @"dish_owner",
	.list = @"list",
	.sizes_owner = @"sizes_owner",
};

const struct OptionsFetchedProperties OptionsFetchedProperties = {
};

@implementation OptionsID
@end

@implementation _Options

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Options" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Options";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Options" inManagedObjectContext:moc_];
}

- (OptionsID*)objectID {
	return (OptionsID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"maxValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"max"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"minValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"min"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic id;






@dynamic max;



- (int16_t)maxValue {
	NSNumber *result = [self max];
	return [result shortValue];
}

- (void)setMaxValue:(int16_t)value_ {
	[self setMax:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMaxValue {
	NSNumber *result = [self primitiveMax];
	return [result shortValue];
}

- (void)setPrimitiveMaxValue:(int16_t)value_ {
	[self setPrimitiveMax:[NSNumber numberWithShort:value_]];
}





@dynamic min;



- (int16_t)minValue {
	NSNumber *result = [self min];
	return [result shortValue];
}

- (void)setMinValue:(int16_t)value_ {
	[self setMin:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMinValue {
	NSNumber *result = [self primitiveMin];
	return [result shortValue];
}

- (void)setPrimitiveMinValue:(int16_t)value_ {
	[self setPrimitiveMin:[NSNumber numberWithShort:value_]];
}





@dynamic name;






@dynamic type;






@dynamic dish_owner;

	

@dynamic list;

	
- (NSMutableOrderedSet*)listSet {
	[self willAccessValueForKey:@"list"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"list"];
  
	[self didAccessValueForKey:@"list"];
	return result;
}
	

@dynamic sizes_owner;

	






@end
