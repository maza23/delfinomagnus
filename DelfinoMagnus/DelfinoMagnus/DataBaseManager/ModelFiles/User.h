//
//  User.h
//  DelfinoMagnus
//
//  Created by Avadesh Kumar on 5/8/14.
//  Copyright (c) 2014 Delfino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * regId;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * apellido;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * actividad;
@property (nonatomic, retain) NSString * empresa;
@property (nonatomic, retain) NSString * direccion;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * image_file;
@property (nonatomic, retain) NSString * image_width;
@property (nonatomic, retain) NSString * image_height;
@property (nonatomic, retain) NSString * fechamodif;
@property (nonatomic, retain) NSString * urlimgs;

@end
