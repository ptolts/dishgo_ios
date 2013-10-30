// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Option.m instead.

#import "_Option.h"

const struct OptionAttributes OptionAttributes = {
	.id = @"id",
	.name = @"name",
	.price = @"price",
};

const struct OptionRelationships OptionRelationships = {
	.option_owner = @"option_owner",
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





@dynamic option_owner;

	






@end
