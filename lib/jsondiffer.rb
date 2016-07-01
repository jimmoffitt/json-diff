#Based on https://github.com/a2design-inc/json-compare
#Updated to generate numeric differences (seond - first) for keys with numeric values, and added a 'same' collection.

class JsonDiffer

   attr_accessor :excluded_keys

   def is_boolean(obj)
	  !!obj == obj
   end

   def numeric?(string)
	  Float(string) != nil rescue false
   end

   def compare_elements(first, second)
	  diff = {}
	  if first.kind_of? Hash
		 if second.kind_of? Array
			diff_hash = compare_hash_array(first, second)
		 else
			diff_hash = compare_hashes(first, second)
		 end
		 diff = diff_hash if diff_hash.count > 0
	  elsif (!is_boolean(first) || !is_boolean(second)) && first.class != second.class
		 diff = second
	  elsif first.kind_of? Array
		 diff_arr = compare_arrays(first, second)
		 diff = diff_arr if diff_arr.count > 0
	  else
		 if numeric?(first) and numeric?(second)

			diff = Float(second) - Float(first)

		 else
			string_diff = compare_strings(first, second)
			diff = string_diff unless string_diff.nil?
		 end

	  end
	  diff
   end

   def compare_hashes(first_hash, second_hash)
	  first_hash = first_hash == nil ? {} : first_hash
	  second_hash = second_hash == nil ? {} : second_hash
	  keys = (first_hash.keys + second_hash.keys).uniq
	  result = get_diffs_struct
	  keys.each do |k|
		 if !first_hash.has_key? k
			result[:append][k] = second_hash[k]
		 elsif !second_hash.has_key? k
			result[:remove][k] = first_hash[k]
		 else
			diff = compare_elements(first_hash[k], second_hash[k])
			if diff.respond_to? "empty?"
			   result[:update][k] = diff unless diff.empty?
			else

			   if diff != 0.0
				  result[:update][k] = diff # some classes have no empty? method
			   else
				  result[:same][k] = diff # some classes have no empty? method
			   end
			end
		 end
	  end
	  filter_results(result)
   end

   def compare_arrays(first_array, second_array)
	  old_array_length = first_array.count
	  new_array_length = second_array.count
	  inters = [first_array.count, second_array.count].min

	  result = get_diffs_struct

	  (0..inters).map do |n|
		 res = compare_elements(first_array[n], second_array[n])
		 result[:update][n] = res unless (res.nil? || (res.respond_to?(:empty?) && res.empty?))
	  end

	  # the rest of the larger array
	  if inters == old_array_length
		 (inters..new_array_length).each do |n|
			result[:append][n] = second_array[n]
		 end
	  else
		 (inters..old_array_length).each do |n|
			result[:remove][n] = first_array[n]
		 end
	  end

	  filter_results(result)
   end

   def compare_hash_array(first_hash, second_array)
	  result = get_diffs_struct

	  (0..second_array.count).map do |n|
		 next if second_array[n].nil?
		 if n == 0
			res = compare_elements(first_hash, second_array[0])
			result[:update][n] = res unless res.empty?
		 else
			result[:append][n] = second_array[n]
		 end
	  end

	  filter_results(result)
   end

   def compare_strings(first_string, second_string)
	  (first_string != second_string) ? second_string.to_s : ""
   end

   # Returns diffs-hash with bare structure
   def get_diffs_struct
	  {:append => {}, :remove => {}, :update => {}, :same => {}}
   end

   def filter_results(result)
	  return {} if result.nil?
	  out_result = {}
	  result.each_key do |change_type|
		 next if result[change_type].nil?
		 temp_hash = {}
		 result[change_type].each_key do |key|
			next if result[change_type][key].nil?
			next if @excluded_keys.include? key
			temp_hash[key] = result[change_type][key]
		 end
		 out_result[change_type] = temp_hash if temp_hash.count > 0
	  end
	  out_result
   end

   def self.get_diff(first, second, exclusion = [])
	  comparer = JsonDiffer.new
	  comparer.excluded_keys = exclusion
	  comparer.compare_elements(first, second)
   end

end
