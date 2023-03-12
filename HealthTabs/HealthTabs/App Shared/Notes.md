
# Notes

- SwiftLint
- MVVM
- URLSession
- HealthKit
- Service Tests
- Combine

Package Dependencies:
- Kingfisher

## Check Before Release

1. Check min supported OS version
2. check all of the ToDo of the entire project
3. check pro and debug are false in feature flags


## ToDo


## Ideas

## Tips

### 1. Explicit/Implicit Dependency
Be aware of implicit dependencies like using
TabItem.health.color for background of a child view.
Child view needs the background as an Explicit Dependency.

### 2. Use Integration/Unit/Smoke Tests in the appropriate context.

### 3. Do not add the mock data to the release Target. And place the mock data
in Resources instead of the Model folder 

## Health Kit

- Setup HealthKit
    - Select the Target and enable the HealthKit capability
    - Check platform availability
    - Create an HKHealthStore, the entry-point of the HealthKit API
    - Ask For Authorization
    - Write Health Data
    - Fetch Health Data via Queries 

- Save Walking Distance
    - Request Write Access
    - Create the sample
    - Save the sample to HealthKit
- Display daily steps
    

## Authorization
- Authorization granted by type
- Read Permissions
- Write Permission
- Define 2 Keys in info.plist:
    - Privacy - Health Update Usage Description
    - Privacy - Health Share Usage Description


## HKSample

### A Sample has
- Type: Ex. stepCount, distanceCycling, ...
- Value: 628 m
- Time: Date/Time that occurred
- Metadata: Additional Info about sample Ex. outdoors/indoors, the weather outside,
    the device that recorded it, and app that wrote it
    

## Sample Types
- all have associated start and end time

### HKQuantitySample
Store a numerical value and unit associated with our data
Ex. distance we walk, headphone audio-level exposure
represents singular values

### HKCategorySample
Value you want to record comes from a predefined list and it does not have unit
represents singular values

### HKWorkout
summarizes multiple values and can carry multiple units, depending on the values that
it is summarizing
Ex 628 meters walked, 3 flights climbed, 105 calories burned

### There are more types available ...


## HKCharacteristic
samples like birth date and blood type are static and does not change over life

## HKObject
HKCharacteristic and all sample types are child of HKObject
- id of sample type or characteristic
- device that recorded the data
- app that wrote the data 
    
    
## Reading via Queries
Ex. HKSampleQuery, HKStatisticsQuery, HKStatisticsCollectionQuery, ...
- Construct a query
    - Type of data
    - Predict which filters and restricts results
- Execute query on HealthKitStore and get results in a Handler

## HKStatisticsQuery

a query that performs statistics on samples, specifically quantity samples.

## Aggregation Style of Samples (Type of Statistics):

### 1- Cumulative
Ex total number of steps taken during a workout,
Ex total amount of calories burned
Ex total amount of caffeine consumed today

### 2- Discrete
Ex average UV exposure of today
Ex Max body temprature from when some one was sick a couple of weeks ago
Average, Min, Max on Health Data

total amount of steps someone took this past week
### HKStatistics Object:
 - Start Date
 - Ednd Date
 - Sum Quantity

if we were to sum up all of someone's steps over all of their devices
it may have duplications


## HKStatisticsCollectionQuery

it is a query that performs stats on fixed time intervals that you specify. Ex daily cadance
anchor date: represents when our statistics starts being computed and
how our samples get bucketed
HKStatisticsCollection Object: is a collection of statistics
so for example for each day we get statistics with sum of our steps
 - Start Date
 - Ednd Date
 - Sum Quantity

## Receive ongoing updates
it can listens to the updates to the user's health data
Set update handler before executing the query. So our query will live in the background,
listening to any new statistics or new data coming into the health database.
so we have to stop when we are done with the data that we need.
- Construct the query
- Execute on the HealthStore
- Update our UI with the results

```swift
let query = HKStatisticsQuery(quantityType: distanceType,
                  quantitySamplePredicate: predicate) { query, stats, error in

}
```

