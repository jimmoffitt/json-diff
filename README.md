# json-diff
Generates the differences in two JSON files. Built to work with *numeric* values of keys in common.


## Inputs

### results #1:

{
  "gender": {
    "Female": "48.8",
    "Male": "50.6"
  },
  "country_metro": {
    "United States": {
      "Chicago IL, US": "2.3",
      "Colorado Springs-Pueblo CO, US": "2.6",
      "Dallas-Fort Worth TX, US": "2.5",
      "Denver CO, US": "33.2",
      "Los Angeles CA, US": "3.1",
      "Minneapolis-St. Paul MN, US": "1.7",
      "New York NY, US": "2.4"
    }
  },
  "language": {
    "English": "84.2",
    "Spanish": "2.3"
  }
}

### results #2:

{
  "gender": {
    "Female": "58.8",
    "Male": "40.6"
  },
  "country_metro": {
    "United States": {
      "Colorado Springs-Pueblo CO, US": "2.6",
      "Dallas-Fort Worth TX, US": "2.5",
      "Denver CO, US": "33.2",
      "Los Angeles CA, US": "3.1",
      "Minneapolis-St. Paul MN, US": "8.7",
      "New York NY, US": "2.4"
    }
  },
  "language": {
    "English": "80.2",
    "Spanish": "7.3"
  }
}

## Ouputs





## Code

require_relative './lib/json-compare'
require 'json'

if __FILE__ == $0 #This script code is executed when running this file.

   json1 = File.read('results/results_diff_1_results.json')
   json2 = File.read('results/results_diff_2_results.json')

   first = JSON.parse(json1)
   second = JSON.parse(json2)

   result = JsonCompare.get_diff(first, second, 'audience')
   
   puts result

end
