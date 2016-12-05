#if defined _expmodachievements_included
  #endinput
#endif
#define _expmodachievements_included

forward achievement_enabled(id, achid, achlvl)

forward achievement_disabled(id, achid, achlvl)

native exp_register_achI(const name[], const desc[], lvl, award, need)

native exp_register_achII(const name[], const desc[], lvl, award, need)

native exp_register_achIII(const name[], const desc[], lvl, award, need)

native exp_set_achievement_progress(index, achievementid, achievementlvl, value)

native exp_get_achievement_progress(index, achievementid, achievementlvl)

native exp_get_achievement_status(index, achievementid, achievementlvl)

native exp_set_achievement_status(index, achievementid, achievementlvl, value)

native exp_get_achievement_name(ach_id, ach_lvl, desc[], len)

native exp_get_achievement_desc(ach_id, ach_lvl, desc[], len)

native exp_get_achievement_req_lvl(ach_id, ach_lvl)

native exp_get_achievement_award(ach_id, ach_lvl)

native exp_get_achievement_need(ach_id, ach_lvl)

native exp_get_achievements_number()
	
native exp_get_achievementid_by_name(ach_lvl, const name[])

native exp_get_achievementid_by_desc(ach_lvl, const desc[])
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/
