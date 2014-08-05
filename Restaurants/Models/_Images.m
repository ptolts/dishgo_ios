// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Images.m instead.

#import "_Images.h"

const struct ImagesAttributes ImagesAttributes = {
	.id = @"id",
	.url = @"url",
};

const struct ImagesRelationships ImagesRelationships = {
	.dishes = @"dishes",
	.relationship = @"relationship",
};

const struct ImagesFetchedProperties ImagesFetchedProperties = {
};

@implementation ImagesID
@end

@implementation _Images

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Images" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Images";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Images" inManagedObjectContext:moc_];
}

- (ImagesID*)objectID {
	return (ImagesID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic id;






@dynamic url;






@dynamic dishes;

	

@dynamic relationship;

	






@end
