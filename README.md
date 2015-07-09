# OkCupid Matching
A quick implementation of OkCupid's matching algorithm


OkCupid is an online dating site has an interesting matching algorithm. The enclosed PDF for OkCupid's description of their algorithm.
The program reads a set of user profiles from stdin (represented in JSON; see included example input file) and writes the top 10 matches for each
user profile to stdout (also in JSON, see below), sorted in rank order.

## Input Format

  * The _importance_ field is in the range __[0,4]__ and is the index into an array that defines the weights as described in the OkCupid doc. For instance:
 ```c 
 private static final int[] IMPORTANCE_POINTS = new int[]{0, 1, 10, 50, 250};
 ```
 
  * Answers are always in the range __[0,3]__.
  
  * The size of the acceptable answer set is between 1 and 3; 0 and 4 are nonsensical.

## Output Format

```json
{
 "results": [
   {
     "profileId": 0,
     "matches": [
       {
         "profileId": 2,
         "score": 0.87       },
       {
         "profileId": 1,
         "score": 0.65
       },
     ]
   },
   {
     "profileId": 1,
     "matches": [
       {
         "profileId": 0,
         "score": 0.65
       },
       {
         "profileId": 2,
         "score": 0.5
       }
     ]
   }
 ]
}
```
