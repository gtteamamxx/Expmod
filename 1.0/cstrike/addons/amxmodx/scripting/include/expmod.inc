#if defined _expmod_included
  #endinput
#endif
#define _expmod_included

native exp_get_user_level(index)

native exp_get_user_exp(index)

native exp_get_user_nextlevelexp(index)

native exp_get_user_previouslevelexp(index)

native exp_set_user_exp(index, exp)

native exp_set_user_level(index, level)

native exp_save_exp(index)

native exp_set_user_invisible(index, value = 255)

native exp_checklevel(id)

native exp_get_user_monets(index)

native exp_set_user_monets(index, ammount)

native exp_get_user_new_health(index)

native exp_has_mission(index)

native exp_get_user_mission(index)

native set_user_mission(index, mission_number)

native exp_get_mission_name(mission_number)

native exp_get_mission_description(mission_number)

native exp_get_mission_price(mission_number)

native exp_get_mission_required_level(mission_number)

native exp_get_mission_numbers()

native exp_get_mission_need(mission_number)

native exp_check_user_locked_mission(index, mission_number)

native exp_unlock_or_lock_mission(index, mission_number, value = 0)