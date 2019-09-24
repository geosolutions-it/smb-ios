//
//  Vehicle.m
//  SaveMyBike
//
//  Created by Pragma on 23/09/2019.
//  Copyright © 2019 STS. All rights reserved.
//

#import "Vehicle.h"

/*
 
 {
 "id" : "saveMyBike",
 "version" : 1,
 "vehicles":[
 {
 "id" : 0,
 "selected" : "false",
 "gpsDist" : 5,
 "gpsTime" : 5000
 },
 {
 "id" : 1,
 "selected" : "true",
 "gpsDist" : 10,
 "gpsTime" : 5000
 },
 {
 "id" : 2,
 "selected" : "false",
 "gpsDist" : 50,
 "gpsTime" : 5000
 },
 {
 "id" : 3,
 "selected" : "false",
 "gpsDist" : 50,
 "gpsTime" : 5000
 },
 {
 "id" : 4,
 "selected" : "false",
 "gpsDist" : 50,
 "gpsTime" : 5000
 },
 {
 "id" : 5,
 "selected" : "false",
 "gpsDist" : 100,
 "gpsTime" : 10000
 }
 ],
 "bikes":[
 {
 "id" : "123",
 "selected" : 1,
 "name" : "Bianchi",
 "state" : 0,
 "image" : ""
 },
 {
 "id" : "124",
 "selected" : 0,
 "name" : "De Rosa",
 "state" : 1,
 "image" : ""
 }
 ],
 "metric" : "true",
 "dataReadInterval" : 1000,
 "persistanceInterval" : 15000
 }

 
 */

@implementation Vehicle

+ (double)minimumGPSDistanceForVehicleType:(VehicleType)eType
{
	switch (eType) {
		VehicleTypeBike:
			return 10;
			break;
		VehicleTypeBus:
			return 50;
			break;
		VehicleTypeCar:
			return 50;
			break;
		VehicleTypeMotorcycle:
			return 50;
			break;
		VehicleTypeTrain:
			return 100;
			break;
		//VehicleTypeFoot:
		default:
			// fall down
			break;
	}
	return 5;
}

+ (long)minimumGPSTimeForVehicleType:(VehicleType)eType
{
	switch (eType) {
		VehicleTypeBike:
			return 5000;
			break;
		VehicleTypeBus:
			return 5000;
			break;
		VehicleTypeCar:
			return 5000;
			break;
		VehicleTypeMotorcycle:
			return 5000;
			break;
		VehicleTypeTrain:
			return 10000;
			break;
			//VehicleTypeFoot:
		default:
			// fall down
			break;
	}
	return 5000;
}

@end
