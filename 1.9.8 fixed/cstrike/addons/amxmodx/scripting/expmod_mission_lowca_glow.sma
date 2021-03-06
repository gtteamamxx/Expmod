/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <expmod_mission>

#define PLUGIN "ExpMod Mission Lowca Glow"
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4"

new misja;
new enabled[33]

new nazwa[] = "Lowca Glow"
new opis[]  = "Zastrzel 150 wrogow strzalem w glowe"
new wymagany_lvl = 40
new nagroda = 7000
new ile_czego = 150

public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	misja = exp_register_mission(nazwa, opis, wymagany_lvl, nagroda, ile_czego)
	
	register_event("DeathMsg", "DeathMsg",	"a");
}

public mission_selected(id, misjaid)
	if(misja == misjaid)
		enabled[id] = 1;
public mission_completed(id, misjaid)
	if(misjaid == misja)
		enabled[id] = 0
public DeathMsg()
{
	new id = read_data(1);
	new id2 = read_data(2);
	new hs = read_data(3);
	if(!is_user_connected(id) || !is_user_alive(id) || !enabled[id] || get_user_team(id) == get_user_team(id2))
		return PLUGIN_CONTINUE
	if(enabled[id] && hs)
		exp_set_user_mission_progress(id, exp_get_user_mission_progress(id)+1)
	return PLUGIN_CONTINUE
}
