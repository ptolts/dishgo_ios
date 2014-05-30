// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Option.m instead.

#import "_Option.h"

const struct OptionAttributes OptionAttributes = {
	.id = @"id",
	.name = @"name",
	.price = @"price",
	.price_according_to_size = @"price_according_to_size",
};

const struct OptionRelationships OptionRelationships = {
	.option_owner = @"option_owner",
	.size_prices = @"size_prices",
};

const struct OptionFetchedProperties OptionFetchedProperties = {
};

@implementation OptionID
@end

@implementation _Option

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Option";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Option" inManagedObjectContext:moc_];
}

- (OptionID*)objectID {
	return (OptionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"price_according_to_sizeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price_according_to_size"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic id;






@dynamic name;






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





@dynamic price_according_to_size;



- (BOOL)price_according_to_sizeValue {
	NSNumber *result = [self price_according_to_size];
	return [result boolValue];
}

- (void)setPrice_according_to_sizeValue:(BOOL)value_ {
	[self setPrice_according_to_size:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePrice_according_to_sizeValue {
	NSNumber *result = [self primitivePrice_according_to_size];
	return [result boolValue];
}

- (void)setPrimitivePrice_according_to_sizeValue:(BOOL)value_ {
	[self setPrimitivePrice_according_to_size:[NSNumber numberWithBool:value_]];
}





@dynamic option_owner;

	

@dynamic size_prices;

	
- (NSMutableSet*)size_pricesSet {
	[self willAccessValueForKey:@"size_prices"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"size_prices"];
  
	[self didAccessValueForKey:@"size_prices"];
	return result;
}
	






@end
