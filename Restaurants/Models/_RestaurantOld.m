// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RestaurantOld.m instead.

#import "_RestaurantOld.h"

const struct RestaurantOldAttributes RestaurantOldAttributes = {
	.address = @"address",
	.city = @"city",
	.distance = @"distance",
	.does_delivery = @"does_delivery",
	.hours = @"hours",
	.id = @"id",
	.lat = @"lat",
	.lon = @"lon",
	.name = @"name",
	.phone = @"phone",
	.postal_code = @"postal_code",
	.prizes = @"prizes",
};

const struct RestaurantOldRelationships RestaurantOldRelationships = {
	.images = @"images",
	.menu = @"menu",
};

const struct RestaurantOldFetchedProperties RestaurantOldFetchedProperties = {
};

@implementation RestaurantOldID
@end

@implementation _RestaurantOld

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RestaurantOld" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RestaurantOld";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RestaurantOld" inManagedObjectContext:moc_];
}

- (RestaurantOldID*)objectID {
	return (RestaurantOldID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"distanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"does_deliveryValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"does_delivery"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lat"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lonValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lon"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"prizesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"prizes"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic address;






@dynamic city;






@dynamic distance;



- (float)distanceValue {
	NSNumber *result = [self distance];
	return [result floatValue];
}

- (void)setDistanceValue:(float)value_ {
	[self setDistance:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDistanceValue {
	NSNumber *result = [self primitiveDistance];
	return [result floatValue];
}

- (void)setPrimitiveDistanceValue:(float)value_ {
	[self setPrimitiveDistance:[NSNumber numberWithFloat:value_]];
}





@dynamic does_delivery;



- (BOOL)does_deliveryValue {
	NSNumber *result = [self does_delivery];
	return [result boolValue];
}

- (void)setDoes_deliveryValue:(BOOL)value_ {
	[self setDoes_delivery:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveDoes_deliveryValue {
	NSNumber *result = [self primitiveDoes_delivery];
	return [result boolValue];
}

- (void)setPrimitiveDoes_deliveryValue:(BOOL)value_ {
	[self setPrimitiveDoes_delivery:[NSNumber numberWithBool:value_]];
}





@dynamic hours;






@dynamic id;






@dynamic lat;



- (double)latValue {
	NSNumber *result = [self lat];
	return [result doubleValue];
}

- (void)setLatValue:(double)value_ {
	[self setLat:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatValue {
	NSNumber *result = [self primitiveLat];
	return [result doubleValue];
}

- (void)setPrimitiveLatValue:(double)value_ {
	[self setPrimitiveLat:[NSNumber numberWithDouble:value_]];
}





@dynamic lon;



- (double)lonValue {
	NSNumber *result = [self lon];
	return [result doubleValue];
}

- (void)setLonValue:(double)value_ {
	[self setLon:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLonValue {
	NSNumber *result = [self primitiveLon];
	return [result doubleValue];
}

- (void)setPrimitiveLonValue:(double)value_ {
	[self setPrimitiveLon:[NSNumber numberWithDouble:value_]];
}





@dynamic name;






@dynamic phone;






@dynamic postal_code;






@dynamic prizes;



- (int16_t)prizesValue {
	NSNumber *result = [self prizes];
	return [result shortValue];
}

- (void)setPrizesValue:(int16_t)value_ {
	[self setPrizes:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePrizesValue {
	NSNumber *result = [self primitivePrizes];
	return [result shortValue];
}

- (void)setPrimitivePrizesValue:(int16_t)value_ {
	[self setPrimitivePrizes:[NSNumber numberWithShort:value_]];
}





@dynamic images;

	
- (NSMutableOrderedSet*)imagesSet {
	[self willAccessValueForKey:@"images"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"images"];
  
	[self didAccessValueForKey:@"images"];
	return result;
}
	

@dynamic menu;

	
- (NSMutableOrderedSet*)menuSet {
	[self willAccessValueForKey:@"menu"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"menu"];
  
	[self didAccessValueForKey:@"menu"];
	return result;
}
	






@end
