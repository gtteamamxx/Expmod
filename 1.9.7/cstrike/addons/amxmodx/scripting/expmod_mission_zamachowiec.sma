/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <expmod_mission>
#include <csx>

#define PLUGIN "ExpMod Mission Zamachowiec"
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4"

new misja;
new enabled[33];

new nazwa[] = "Zamachowiec"
new opis[]  = "Podloz 15 bomb"
new wymagany_lvl = 9
new nagroda = 1500
new ile_czego = 15   

public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	misja = exp_register_mission(nazwa, opis, wymagany_lvl, nagroda, ile_czego)
}

public mission_selected(id, misjaid)
	if(misja == misjaid)
		enabled[id] = 1;
public mission_completed(id, misjaid)
	if(misjaid == misja)
		enabled[id] = 0
public bomb_planted(id)
{
	if(enabled[id])
		exp_set_user_mission_progress(id, exp_get_user_mission_progress(id)+1)
}
