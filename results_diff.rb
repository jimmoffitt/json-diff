require_relative './lib/jsondiffer'
require 'json'


json1 = File.read('results/results_diff_1_results.json')
json2 = File.read('results/results_diff_2_results.json')

first = JSON.parse(json1)
second = JSON.parse(json2)

result = JsonDiffer.get_diff(first, second, 'audience')   
   
puts result
