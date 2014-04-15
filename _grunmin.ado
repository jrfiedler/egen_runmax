*! version 1.0.0  15apr2014
program define _grunmin
	version 9

	gettoken type 0 : 0
	gettoken vn   0 : 0
	gettoken eqs  0 : 0
	
	syntax varname(numeric) [if] [in] [, by(string) sort(varlist)]
	
	marksample touse
	
	// Get data type needed to contain values. The values
	// will be inserted in Mata, and Mata does not promote.
	local old_type : type `varlist'
	if ("`type'" == "double") {
		local need_type = "double"
	}
	else if ("`old_type'" != "float" & "`old_type'" != "double") {
		if ("`type'" == "float") {
			local need_type = "float"
		}
		else if ("`type'" == "byte") {
			local need_type = "`old_type'"
		}
		else if ("`old_type'" == "byte" | "`old_type'" == "int") {
			// at this point `type' is int or long (or str)
			local need_type = "`type'"
		}
		else {
			local need_type = "`old_type'"
		}
	}
	else {
		tempname max_min
		mata: max_min("`varlist'", "`touse'", "`max_min'")
		if (`max_min'[1,1] >= -1.fffffeX+7e & `max_min'[1,2] <= +1.fffffeX+7e) {
			local need_type = "float"
		}
		else {
			local need_type = "double"
		}
	}
	
	if ("`sort'" != "") {
		sort `sort'
	}
	
	// temporarily put -by- variable group nums in vn
	if ("`by'" == "") {
		qui gen `need_type' `vn' = .
		qui replace `vn' = 1 if `touse'
	}
	else {
		qui egen `need_type' `vn' = group(`by') if `touse'
		qui replace `touse' = 0 if `vn' == .
	}
	
	mata: input_mins("`varlist'", "`vn'", "`touse'")
end

mata
	void input_mins(string scalar input_name,
	                string scalar output_name,
                    string scalar touse_name)
	{
		real scalar N, group_num, n_groups, max_i
		real colvector group_mins, seen
		real colvector input, output
		
		st_view(input, ., input_name, touse_name)
		st_view(output, ., output_name, touse_name)
	
		N = length(input)
		n_groups = colmax(output)
		group_mins = J(n_groups, 1, .)
		seen = J(n_groups, 1, 0)
		
		for (i = 1; i <= N; i++) {
			group_num = output[i]
			if (!seen[group_num]) {
				min_i = input[i]
				seen[group_num] = 1
			}
			else {
				min_i = min((group_mins[group_num], input[i]))
			}
			output[i] = min_i
			group_mins[group_num] = min_i
		}
	}
	
	void max_min(string scalar input_name,
	             string scalar touse_name,
				 string scalar matname)
	{
		real vector input
		
		st_view(input, ., input_name, touse_name)
		
		st_matrix(matname, (min(input), max(input)))
	}
end
