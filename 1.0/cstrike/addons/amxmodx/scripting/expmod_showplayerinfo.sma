/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <expmod>
#include <fun>


#define PLUGIN "ExpMod Player Info"
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4 & ExTaZa?!"

//Team show info style
new message1, cel

new team_show_mission		//show mission
new team_show_level		//show level
new team_show_health		//show health
new team_show_nick		//show nick
new team_show_exp		//show exp

//Team show info style

new enemy_show_mission		//show mission
new enemy_show_level		//show level
new enemy_show_health		//show health
new enemy_show_nick		//show nick
new enemy_show_exp		//show exp

new show_time

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_event("StatusValue", "Show", "be", "1=2", "2!0")
	//Team
	team_show_mission	= register_cvar("exp_playerinfo_show_team_mission", 	"1")
	team_show_level		= register_cvar("exp_playerinfo_show_team_level", 	"1")
	team_show_health	= register_cvar("exp_playerinfo_show_team_health", 	"1")
	team_show_nick		= register_cvar("exp_playerinfo_show_team_nick", 	"1")
	team_show_exp		= register_cvar("exp_playerinfo_show_team_exp", 	"1")
	//Time to show
	
	show_time 		= register_cvar("exp_playerinfo_show_time",		"2.5")
	
	//Enemy
	enemy_show_mission	= register_cvar("exp_playerinfo_show_enemy_mission", 	"1")
	enemy_show_level	= register_cvar("exp_playerinfo_show_enemy_level", 	"1")
	enemy_show_health	= register_cvar("exp_playerinfo_show_enemy_health", 	"1")
	enemy_show_nick		= register_cvar("exp_playerinfo_show_enemy_nick", 	"1")
	enemy_show_exp		= register_cvar("exp_playerinfo_show_enemy_exp", 	"1")
	
	message1 = CreateHudSyncObj()
	
	WczytajUstawienia()
}

public WczytajUstawienia()
{
	new tekst[64], len
	new cvar[64], wartosc[16], komenda[128]
	if(!file_exists("addons/amxmodx/configs/expmod.cfg"))
		write_file("addons/amxmodx/configs/expmod.cfg", "; Plik konfiguracyjny expmod", 0)
		
	for(new i = 0 ; read_file("addons/amxmodx/configs/expmod.cfg", i, tekst, 63, len); i ++)
	{
		if(tekst[0] == ';' || (tekst[0] == '/' && tekst[1] == '/') || !(equali(tekst, "exp_playerinfo", 14)))
			continue;
		
		parse(tekst, cvar, 63, wartosc, 15)
		if(equali(cvar, "exp_playerinfo_show_time"))
			formatex(komenda, 127, "%s %0.1f", cvar, str_to_float(wartosc))
		else
			formatex(komenda, 127, "%s %d", cvar, str_to_num(wartosc))
		
		server_cmd(komenda)
	}
}

public Show(id)
{
	cel = read_data(2)
	
	if(!is_user_alive(cel) || !is_user_connected(cel) || !is_user_alive(id) || !is_user_connected(id) || is_user_bot(id))
		return PLUGIN_CONTINUE
	
	if(get_user_team(cel) == get_user_team(id))
	{
		new nazwa_misji[64], len
		new nazwa_gracza[33]
		if(get_pcvar_num(team_show_nick) == 1)
			get_user_name(cel, nazwa_gracza, 32)
		if(get_pcvar_num(team_show_mission) == 1)
		{
			exp_get_mission_name(exp_get_user_mission(cel))
			read_file("addons/amxmodx/ExpMod/get_mission_name.txt", 1, nazwa_misji, 63, len)
		}
		//Pojedynczo 
		//Misje
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s", nazwa_misji)
		}
		//Poziom
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Poziom : %d", exp_get_user_level(cel))
		}
		//Zdrowie
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Zdrowie : %d", get_user_health(cel))
		}
		//Nick
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s", nazwa_gracza)
		}
		//Exp
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Exp : %d",exp_get_user_exp(cel))
		}
		//Podwojnie
		//Misja+Level
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s^nPoziom : %d", nazwa_misji, exp_get_user_level(cel))
			
		}
		//Misja+Zdrowie
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s^nZdrowie : %d", nazwa_misji, get_user_health(cel))
		}
		//Misja+Nick
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nMisja : %s", nazwa_gracza, nazwa_misji)
		}
		//Misja+Exp
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s^nExp : %d", nazwa_misji, exp_get_user_exp(cel))
		}
		//Level+Zdrowie
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Poziom : %d^nZdrowie : %d", exp_get_user_level(cel), get_user_health(cel))
		}
		//Level+Nick
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nPoziom : %d", nazwa_gracza, exp_get_user_level(cel))
		}
		//Level+Exp
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Poziom : %d^nExp : %d", exp_get_user_level(cel), exp_get_user_exp(cel))
		}
		//Zdrowie+Nick
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nZdrowie : %d", nazwa_gracza,get_user_health(cel))
		}
		//Zdrowie+Exp
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Zdrowie : %d^nExp : %d", get_user_health(cel), exp_get_user_exp(cel))
		}
		//Nick+Exp
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nExp : %d", nazwa_gracza, exp_get_user_exp(cel))
		}
		/*/////////////////////Potrojne\\\\\\\\\\\\\\\\\\\*/
		
		//Misja+Poziom+Zycie
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s^nPoziom : %d^nZdrowie : %d", nazwa_misji, exp_get_user_level(cel),get_user_health(cel))
		}
		//Misja+Poziom+Nick
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nMisja : %s^nPoziom : %d", nazwa_gracza,nazwa_misji,exp_get_user_level(cel))
		}
		//Misja+Poziom+Exp
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s^nPoziom : %d^nExp : %d", nazwa_misji,exp_get_user_level(cel), exp_get_user_exp(cel))
		}
		//Nick+Exp+Level
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nPoziom : %d^nExp : %d", nazwa_gracza,exp_get_user_level(cel), exp_get_user_exp(cel))
		}
		//Poziom+Zdrowie+Nick
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nPoziom : %d^nZdrowie : %d", nazwa_gracza,exp_get_user_level(cel), get_user_health(cel))
		}
		//Poziom+Zdrowie+Exp
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Poziom : %d^nZdrowie : %d^nExp : %d", exp_get_user_level(cel), get_user_health(cel), exp_get_user_exp(cel))
		}
		//Zdrowie+Exp+Misja
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "^nZdrowie : %d^nExp : %d^nMisja : %s", get_user_health(cel), exp_get_user_exp(cel), nazwa_misji)
		}
		//Misja+Nick+Exp
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nMisja : %s^nExp : %d", nazwa_gracza, nazwa_misji, exp_get_user_exp(cel))
		}
		/*/////////////////////POCZWORNE\\\\\\\\\\\\\\\\\\\\\*/
		
		//Misja+Poziom+Zdrowie+Nick
		
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 0)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nPoziom : %d^nZdrowie : %d^nMisja : %s", nazwa_gracza, exp_get_user_level(cel), get_user_health(cel), nazwa_misji)
		}
		//Exp+Poziom+Misja+nick
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 0 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nMisja : %s^nPoziom : %d^nExp : %d", nazwa_gracza, nazwa_misji, exp_get_user_level(cel), exp_get_user_exp(cel))
		}
		//Misja+Poziom+Zdrowie+Exp
		
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 0 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Poziom : %d^nExp : %d^nZdrowie : %d^nMisja : %s", exp_get_user_level(cel), exp_get_user_exp(cel), get_user_health(cel), nazwa_misji)
		}
		//Nick+Zdrowie+Exp+Poziom
		if(get_pcvar_num(team_show_mission) == 0 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nPoziom : %d^nExp : %d^nZdrowie : %d", nazwa_gracza, exp_get_user_level(cel), exp_get_user_exp(cel), get_user_health(cel))
		}
		
		//Nick+Misja+Zdrowie+Exp
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 0 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0, 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nExp : %d^nZdrowie : %d^nMisja : %s", nazwa_gracza, exp_get_user_exp(cel), get_user_health(cel), nazwa_misji)
		}
		
		//Nick+Misja+Poziom+Exp+Zdrowie
		if(get_pcvar_num(team_show_mission) == 1 && get_pcvar_num(team_show_level) == 1 && get_pcvar_num(team_show_health) == 1 && get_pcvar_num(team_show_nick) == 1 && get_pcvar_num(team_show_exp) == 1)
		{
			set_hudmessage(0 , 0, 255, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nMisja : %s^nPoziom : %d^nExp : %d^nZdrowie : %d", nazwa_gracza, nazwa_misji, exp_get_user_level(cel), exp_get_user_exp(cel), get_user_health(cel))
		}
	}
	else
	{
		
		new nazwa_misji[64], len
		new nazwa_gracza[33]
		if(get_pcvar_num(enemy_show_nick) == 1)
			get_user_name(cel, nazwa_gracza, 32)
		if(get_pcvar_num(enemy_show_mission) == 1)
		{
			exp_get_mission_name(exp_get_user_mission(cel))
			read_file("addons/amxmodx/ExpMod/get_mission_name.txt", 1, nazwa_misji, 63, len)
		}
		//Pojedynczo 
		//Misje
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s", nazwa_misji)
		}
		//Poziom
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Poziom : %d", exp_get_user_level(cel))
		}
		//Zdrowie
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Zdrowie : %d", get_user_health(cel))
		}
		//Nick
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s", nazwa_gracza)
		}
		//Exp
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Exp : %d",exp_get_user_exp(cel))
		}
		//Podwojnie
		//Misja+Level
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s^nPoziom : %d", nazwa_misji, exp_get_user_level(cel))
			
		}
		//Misja+Zdrowie
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s^nZdrowie : %d", nazwa_misji, get_user_health(cel))
		}
		//Misja+Nick
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nMisja : %s", nazwa_gracza, nazwa_misji)
		}
		//Misja+Exp
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s^nExp : %d", nazwa_misji, exp_get_user_exp(cel))
		}
		//Level+Zdrowie
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Poziom : %d^nZdrowie : %d", exp_get_user_level(cel), get_user_health(cel))
		}
		//Level+Nick
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nPoziom : %d", nazwa_gracza, exp_get_user_level(cel))
		}
		//Level+Exp
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Poziom : %d^nExp : %d", exp_get_user_level(cel), exp_get_user_exp(cel))
		}
		//Zdrowie+Nick
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nZdrowie : %d", nazwa_gracza,get_user_health(cel))
		}
		//Zdrowie+Exp
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Zdrowie : %d^nExp : %d", get_user_health(cel), exp_get_user_exp(cel))
		}
		//Nick+Exp
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nExp : %d", nazwa_gracza, exp_get_user_exp(cel))
		}
		/*/////////////////////Potrojne\\\\\\\\\\\\\\\\\\\*/
		
		//Misja+Poziom+Zycie
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s^nPoziom : %d^nZdrowie : %d", nazwa_misji, exp_get_user_level(cel),get_user_health(cel))
		}
		//Misja+Poziom+Nick
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nMisja : %s^nPoziom : %d", nazwa_gracza,nazwa_misji,exp_get_user_level(cel))
		}
		//Misja+Poziom+Exp
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Misja : %s^nPoziom : %d^nExp : %d", nazwa_misji,exp_get_user_level(cel), exp_get_user_exp(cel))
		}
		//Nick+Exp+Level
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nPoziom : %d^nExp : %d", nazwa_gracza,exp_get_user_level(cel), exp_get_user_exp(cel))
		}
		//Poziom+Zdrowie+Nick
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nPoziom : %d^nZdrowie : %d", nazwa_gracza,exp_get_user_level(cel), get_user_health(cel))
		}
		//Poziom+Zdrowie+Exp
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Poziom : %d^nZdrowie : %d^nExp : %d", exp_get_user_level(cel), get_user_health(cel), exp_get_user_exp(cel))
		}
		//Zdrowie+Exp+Misja
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "^nZdrowie : %d^nExp : %d^nMisja : %s", get_user_health(cel), exp_get_user_exp(cel), nazwa_misji)
		}
		//Misja+Nick+Exp
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nMisja : %s^nExp : %d", nazwa_gracza, nazwa_misji, exp_get_user_exp(cel))
		}
		/*/////////////////////POCZWORNE\\\\\\\\\\\\\\\\\\\\\*/
		
		//Misja+Poziom+Zdrowie+Nick
		
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 0)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nPoziom : %d^nZdrowie : %d^nMisja : %s", nazwa_gracza, exp_get_user_level(cel), get_user_health(cel), nazwa_misji)
		}
		//Exp+Poziom+Misja+nick
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 0 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nMisja : %s^nPoziom : %d^nExp : %d", nazwa_gracza, nazwa_misji, exp_get_user_level(cel), exp_get_user_exp(cel))
		}
		//Misja+Poziom+Zdrowie+Exp
		
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 0 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Poziom : %d^nExp : %d^nZdrowie : %d^nMisja : %s", exp_get_user_level(cel), exp_get_user_exp(cel), get_user_health(cel), nazwa_misji)
		}
		//Nick+Zdrowie+Exp+Poziom
		if(get_pcvar_num(enemy_show_mission) == 0 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nPoziom : %d^nExp : %d^nZdrowie : %d", nazwa_gracza, exp_get_user_level(cel), exp_get_user_exp(cel), get_user_health(cel))
		}
		
		//Nick+Misja+Zdrowie+Exp
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 0 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nExp : %d^nZdrowie : %d^nMisja : %s", nazwa_gracza, exp_get_user_exp(cel), get_user_health(cel), nazwa_misji)
		}
		/*//////////////////////////WSZYSTKIE\\\\\\\\\\\\\\\\\\\\\\*/
		//Nick+Misja+Poziom+Exp+Zdrowie
		if(get_pcvar_num(enemy_show_mission) == 1 && get_pcvar_num(enemy_show_level) == 1 && get_pcvar_num(enemy_show_health) == 1 && get_pcvar_num(enemy_show_nick) == 1 && get_pcvar_num(enemy_show_exp) == 1)
		{
			set_hudmessage(255 , 0, 0, -1.0, 0.55, 1, 6.0, get_pcvar_float(show_time))
			ShowSyncHudMsg(id, message1, "Nick : %s^nMisja : %s^nPoziom : %d^nExp : %d^nZdrowie : %d", nazwa_gracza, nazwa_misji, exp_get_user_level(cel), exp_get_user_exp(cel), get_user_health(cel))
		}
	}
	return PLUGIN_CONTINUE
}