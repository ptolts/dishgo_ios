// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Dishes.h instead.

#import <CoreData/CoreData.h>


extern const struct DishesAttributes {
	__unsafe_unretained NSString *description_text;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *position;
	__unsafe_unretained NSString *price;
} DishesAttributes;

extern const struct DishesRelationships {
	__unsafe_unretained NSString *images;
	__unsafe_unretained NSString *options;
	__unsafe_unretained NSString *sections;
} DishesRelationships;

extern const struct DishesFetchedProperties {
} DishesFetchedProperties;

@class Images;
@class Options;
@class Sections;







@interface DishesID : NSManagedObjectID {}
@end

@interface _Dishes : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DishesID*)objectID;





@property (nonatomic, strong) NSString* description_text;



//- (BOOL)validateDescription_text:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* id;



//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* position;



@property int16_t positionValue;
- (int16_t)positionValue;
- (void)setPositionValue:(int16_t)value_;

//- (BOOL)validatePosition:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price;



@property float priceValue;
- (float)priceValue;
- (void)setPriceValue:(float)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *images;

- (NSMutableOrderedSet*)imagesSet;




@property (nonatomic, strong) NSOrderedSet *options;

- (NSMutableOrderedSet*)optionsSet;




@property (nonatomic, strong) Sections *sections;

//- (BOOL)validateSections:(id*)value_ error:(NSError**)error_;





@end

@interface _Dishes (CoreDataGeneratedAccessors)

- (void)addImages:(NSOrderedSet*)value_;
- (void)removeImages:(NSOrderedSet*)value_;
- (void)addImagesObject:(Images*)value_;
- (void)removeImagesObject:(Images*)value_;

- (void)addOptions:(NSOrderedSet*)value_;
- (void)removeOptions:(NSOrderedSet*)value_;
- (void)addOptionsObject:(Options*)value_;
- (void)removeOptionsObject:(Options*)value_;

@end

@interface _Dishes (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDescription_text;
- (void)setPrimitiveDescription_text:(NSString*)value;




- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitivePosition;
- (void)setPrimitivePosition:(NSNumber*)value;

- (int16_t)primitivePositionValue;
- (void)setPrimitivePositionValue:(int16_t)value_;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (float)primitivePriceValue;
- (void)setPrimitivePriceValue:(float)value_;





- (NSMutableOrderedSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableOrderedSet*)value;



- (NSMutableOrderedSet*)primitiveOptions;
- (void)setPrimitiveOptions:(NSMutableOrderedSet*)value;



- (Sections*)primitiveSections;
- (void)setPrimitiveSections:(Sections*)value;


@end
