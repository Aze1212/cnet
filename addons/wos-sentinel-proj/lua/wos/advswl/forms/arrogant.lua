local FORM = {}

--The name of this form. Do not repeat names of forms!
FORM.Name = "Arrogant"

--Who does this form belong to? Options: FORM_SINGLE, FORM_DUAL, FORM_BOTH
FORM.Type = FORM_DUAL

--What user groups are able to use this form? And which stances?
FORM.UserGroups = { 
	["user"] = { 1, 2, 3 },
	["VIP"] = {1, 2, 3},
	["Junior Moderator"] = {1, 2, 3},
	["Moderator"] = {1, 2, 3},
	["Senior Moderator"] = {1, 2, 3},
	["Junior Event Planner"] = {1, 2, 3},
	["Event Planner"] = {1, 2, 3},
	["Senior Event Planner"] = {1, 2, 3},
	["Superadmin"] = {1, 2, 3},
} -- Added a ,3 and replaced Jedi with User REINAEIRY if all fails remove all but vip

FORM.Stances = {}
FORM.Stances[1] = {
	[ "idle" ] = "ryoku_idle_lower",
	[ "run" ] = "ryoku_run_lower",
	[ "light_left" ] = {
		Sequence = "ryoku_r_left_t1",
		Time = nil,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "ryoku_a_right_t1",
		Time = 0.9,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "judge_r_s3_t2",
		Time = 1.4,
		Rate = nil,
	},
	[ "air_left" ] = {
		Sequence = "ryoku_a_left_t1",
		Time = 1,
		Rate = 1.5,
	},
	[ "air_right" ] = {
		Sequence = "ryoku_a_right_t1",
		Time = 1,
		Rate = 1.5,
	},
	[ "air_forward" ] = {
		Sequence = "vanguard_a_s1_t1",
		Time = 0.6,
		Rate = 1.2,
	},
	[ "heavy" ] = {
		Sequence = "pure_r_left_t3",
		Time = 1.2,
		Rate = nil,
	},
	[ "heavy_charge" ] = "ryoku_b_s1_charge",
}

FORM.Stances[2] = {
	[ "idle" ] = "ryoku_idle_lower",
	[ "run" ] = "ryoku_run_lower",
	[ "light_left" ] = {
		Sequence = "h_left_t3",
		Time = 2,
		FlurryTime = 1.6,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "r_c6_t1",
		Time = 1.4,
		FlurryTime = 1.2,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "ryoku_r_c6_t3",
		Time = 1.5,
		FlurryTime = 1,
		Rate = nil,
	},
	[ "air_left" ] = {
		Sequence = "ryoku_a_left_t1",
		Time = 1,
		Rate = 1.5,
	},
	[ "air_right" ] = {
		Sequence = "ryoku_a_right_t1",
		Time = 1,
		Rate = 1.5,
	},
	[ "air_forward" ] = {
		Sequence = "vanguard_a_s1_t1",
		Time = 0.6,
		Rate = 1.2,
	},
	[ "heavy" ] = {
		Sequence = "ryoku_b_right_t3",
		Time = 1.8,
		Rate = nil,
	},
	[ "heavy_charge" ] = "ryoku_b_s1_charge",
}

FORM.Stances[3] = {
	[ "idle" ] = "ryoku_idle_lower",
	[ "run" ] = "ryoku_run_lower",
	[ "light_left" ] = {
		Sequence = "ryoku_r_c4_t1",
		Time = 1.2,
		Rate = nil,
	},
	[ "light_right" ] = {
		Sequence = "vanguard_h_right_t3",
		Time = 1.2,
		Rate = nil,
	},
	[ "light_forward" ] = {
		Sequence = "ryoku_r_c4_t3",
		Time = nil,
		Rate = nil,
	},
	[ "air_left" ] = {
		Sequence = "ryoku_a_left_t1",
		Time = 1,
		Rate = 1.5,
	},
	[ "air_right" ] = {
		Sequence = "ryoku_a_right_t1",
		Time = 1,
		Rate = 1.5,
	},
	[ "air_forward" ] = {
		Sequence = "vanguard_a_s1_t1",
		Time = 0.6,
		Rate = 1.2,
	},
	[ "heavy" ] = {
		Sequence = "pure_b_right_t3",
		Time = 1.5,
		Rate = nil,
	},
	[ "heavy_charge" ] = "ryoku_b_s1_charge",
}

wOS:RegisterNewForm( FORM )