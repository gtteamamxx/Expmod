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

native exp_set_user_mission(index, mission_number, postep)

native exp_get_mission_name(mission_number, dest[], len)

native exp_get_mission_description(mission_number, dest[], len)

native exp_get_mission_price(mission_number)

native exp_get_mission_required_level(mission_number)

native exp_get_mission_numbers()

native exp_get_mission_need(mission_number)

native exp_check_user_locked_mission(index, mission_number)

native exp_unlock_or_lock_mission(index, mission_number, value = 0)

native exp_is_user_vip(index)

native exp_get_levelexp(level)

native exp_reset(index, points=0, ultra_points=0, monets=0)

native exp_get_user_mission_postep(index)
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/
