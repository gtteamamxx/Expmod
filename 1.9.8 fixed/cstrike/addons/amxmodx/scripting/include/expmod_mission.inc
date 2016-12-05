#if defined _expmod_m_included
  #endinput
#endif
#define _expmod_m_included

native exp_register_mission(const name[], const description[], required_level, award, need)

native exp_set_user_mission_progress(index, how_many)

native exp_get_user_mission(index)

native exp_set_user_mission(index, missionid, progress)

native exp_get_user_mission_progress(index)
	
native exp_get_mission_name(missionid, dest[], len)

native exp_get_mission_desc(missionid, dest[], len)

native exp_get_mission_need_level(missionid)

native exp_get_mission_award(missionid)

native exp_get_mission_need(missionid)

native exp_get_mission_status(index, missionid)

native exp_set_mission_status(index, missionid, value)

native exp_get_missionid_by_name(const name[])

native exp_get_missionid_by_desc(const desc[])

native exp_get_missions_numbers()

	
forward mission_selected(id, numer_misji)

forward mission_completed(id, numer_misji)

/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/
