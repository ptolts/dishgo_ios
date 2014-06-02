// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Options.m instead.

#import "_Options.h"

const struct OptionsAttributes OptionsAttributes = {
	.advanced = @"advanced",
	.id = @"id",
	.max_selections = @"max_selections",
	.min_selections = @"min_selections",
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
	
	if ([key isEqualToString:@"advancedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"advanced"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"max_selectionsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"max_selections"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"min_selectionsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"min_selections"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic advanced;



- (BOOL)advancedValue {
	NSNumber *result = [self advanced];
	return [result boolValue];
}

- (void)setAdvancedValue:(BOOL)value_ {
	[self setAdvanced:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAdvancedValue {
	NSNumber *result = [self primitiveAdvanced];
	return [result boolValue];
}

- (void)setPrimitiveAdvancedValue:(BOOL)value_ {
	[self setPrimitiveAdvanced:[NSNumber numberWithBool:value_]];
}





@dynamic id;






@dynamic max_selections;



- (int16_t)max_selectionsValue {
	NSNumber *result = [self max_selections];
	return [result shortValue];
}

- (void)setMax_selectionsValue:(int16_t)value_ {
	[self setMax_selections:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMax_selectionsValue {
	NSNumber *result = [self primitiveMax_selections];
	return [result shortValue];
}

- (void)setPrimitiveMax_selectionsValue:(int16_t)value_ {
	[self setPrimitiveMax_selections:[NSNumber numberWithShort:value_]];
}





@dynamic min_selections;



- (int16_t)min_selectionsValue {
	NSNumber *result = [self min_selections];
	return [result shortValue];
}

- (void)setMin_selectionsValue:(int16_t)value_ {
	[self setMin_selections:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMin_selectionsValue {
	NSNumber *result = [self primitiveMin_selections];
	return [result shortValue];
}

- (void)setPrimitiveMin_selectionsValue:(int16_t)value_ {
	[self setPrimitiveMin_selections:[NSNumber numberWithShort:value_]];
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
