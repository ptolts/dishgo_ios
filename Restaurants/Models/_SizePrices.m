// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SizePrices.m instead.

#import "_SizePrices.h"

const struct SizePricesAttributes SizePricesAttributes = {
	.id = @"id",
	.price = @"price",
	.related_to_size = @"related_to_size",
};

const struct SizePricesRelationships SizePricesRelationships = {
	.option = @"option",
	.size_option = @"size_option",
};

const struct SizePricesFetchedProperties SizePricesFetchedProperties = {
};

@implementation SizePricesID
@end

@implementation _SizePrices

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SizePrices" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SizePrices";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SizePrices" inManagedObjectContext:moc_];
}

- (SizePricesID*)objectID {
	return (SizePricesID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic id;






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





@dynamic related_to_size;






@dynamic option;

	

@dynamic size_option;

	






@end
