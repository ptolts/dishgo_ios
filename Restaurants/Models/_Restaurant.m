// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Restaurant.m instead.

#import "_Restaurant.h"

const struct RestaurantAttributes RestaurantAttributes = {
	.address = @"address",
	.id = @"id",
	.lat = @"lat",
	.lon = @"lon",
	.name = @"name",
	.phone = @"phone",
};

const struct RestaurantRelationships RestaurantRelationships = {
	.images = @"images",
	.menu = @"menu",
};

const struct RestaurantFetchedProperties RestaurantFetchedProperties = {
};

@implementation RestaurantID
@end

@implementation _Restaurant

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Restaurant" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Restaurant";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Restaurant" inManagedObjectContext:moc_];
}

- (RestaurantID*)objectID {
	return (RestaurantID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
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

	return keyPaths;
}




@dynamic address;






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
