// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Dishes.m instead.

#import "_Dishes.h"

const struct DishesAttributes DishesAttributes = {
	.description_text = @"description_text",
	.id = @"id",
	.name = @"name",
	.position = @"position",
	.price = @"price",
	.sizes = @"sizes",
};

const struct DishesRelationships DishesRelationships = {
	.images = @"images",
	.options = @"options",
	.sections = @"sections",
	.sizes_object = @"sizes_object",
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
	
	if ([key isEqualToString:@"positionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"position"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sizesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sizes"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic description_text;






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





@dynamic price;



- (float)priceValue {
	NSNumber *result = [self price];
	return [result floatValue];
}

- (void)setPriceValue:(float)value_ {
	[self setPrice:[NSNumber numberWithFloat:value_]];
}

- (float)primitivePriceValue {
	NSNumber *result = [self primitivePrice];
	return [result floatValue];
}

- (void)setPrimitivePriceValue:(float)value_ {
	[self setPrimitivePrice:[NSNumber numberWithFloat:value_]];
}





@dynamic sizes;



- (BOOL)sizesValue {
	NSNumber *result = [self sizes];
	return [result boolValue];
}

- (void)setSizesValue:(BOOL)value_ {
	[self setSizes:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSizesValue {
	NSNumber *result = [self primitiveSizes];
	return [result boolValue];
}

- (void)setPrimitiveSizesValue:(BOOL)value_ {
	[self setPrimitiveSizes:[NSNumber numberWithBool:value_]];
}





@dynamic images;

	
- (NSMutableOrderedSet*)imagesSet {
	[self willAccessValueForKey:@"images"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"images"];
  
	[self didAccessValueForKey:@"images"];
	return result;
}
	

@dynamic options;

	
- (NSMutableOrderedSet*)optionsSet {
	[self willAccessValueForKey:@"options"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"options"];
  
	[self didAccessValueForKey:@"options"];
	return result;
}
	

@dynamic sections;

	

@dynamic sizes_object;

	






@end
