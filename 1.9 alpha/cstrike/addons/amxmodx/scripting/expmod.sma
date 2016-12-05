///////////////////////////////////////////////////////

#include <amxmodx>
#include <engine>
#include <amxmisc>
#include <savev>
#include <fakemeta>
#include <colorchat>
#include <hamsandwich>
#include <cstrike>
#include <fun>
#include <csx>
#include <tutor>
#include <expmod_mission>

///////////////////////////////////////////////////////

#define PLUGIN "ExpMod"
#define VERSION "1.9 Alpha"
#define AUTHOR "tomcionek15 & grs4"

///////////////////////////////////////////////////////

#define MAX_PUNKTOW 		150 							// Levele / 4, na jeden skill 
#define MAX_ULTRA_PUNKTOW 	5							// (Levele/10)/4 Na jeden skill
#define PUNKTY_ZA_LEVEL		3							// Punkty za poziom

///////////////////Ultra Punkty ///////////////////////

#define MNOZNIK_NIEWIDZIALNOSCI 48							// * 5 - 255 Niewidzialny na maxa
#define MNOZNIK_OBRAZEN 	7 							// * 5 - Dodatkowe Obrazenia
#define MNOZNIK_SKOKOW		1 							// * 5 - Dodatkowe Skoki w powietrzu za 1 u. pkt.
#define MNOZNIK_LONGJUMPA  	15							// * 5 +170

////////////////////////PUNKTY/////////////////////////

#define MNOZNIK_ZYCIA 		3 							// * 150 // Dodatkowe HP
#define MNOZNIK_SZYBKOSCI 	0.65 							// * 150+250 - Maksymalna predkosc 
#define MNOZNIK_GRAWITACJI 	2.5							// * 150 / 800 
#define MNOZNIK_KASY 		35 							// * 150 = 5250

#define ADMIN_MENU_FLAG 	ADMIN_IMMUNITY						// Flaga Admin Menu = Admin Immunity
#define VIP_FLAG 		ADMIN_LEVEL_H						// Flaga "t" - Dla VIPA

#define SCOREATTRIB_DEAD	(1 << 0) 
#define SCOREATTRIB_VIP		(1 << 2)

#define SCIEZKA_PLIKU		"addons/amxmodx/configs/expmod.cfg"			//Glowny plik konfiguracyjny expmoda

///////////////////////////////////////////////////////
//                  POZIOMY                          //
///////////////////////////////////////////////////////

new g_MsgScoreAttrib = 0;
new const POZIOM[] = 
{
	200,800,1800,3200,5000,7200,9800,12800,16200,20000,24200,28800,33800,39200, 		//0   - 14
	45000,51200,57800,64800,72200,80000,88200,96800,105800,115200,125000,135200,		//15  - 27 
	145800,156800,168200,180000,192200,204800,217800,231200,245000,259200,273800,		//28  - 39
	288800,304200,320000,336200,352800,369800,387200,405000,423200,441800,460800,		//40  - 51
	480200,500000,520200,540800,561800,583200,605000,627200,649800,672800,696200,		//52  - 62
	720000,744200,768800,793800,819200,845000,871200,897800,924800,952200,980000,		//63  - 73
	1008200,1036800,1065800,1095200,1125000,1155200,1185800,1216800,1248200,1280000,	//74  - 84
	1312200,1344800,1377800,1411200,1445000,1479200,1513800,1548800,1584200,1620000,	//85  - 95
	1656200,1692800,1729800,1767200,1805000,1843200,1881800,1920800,1960200,2000000,	//96  - 106
	2040200,2080800,2121800,2163200,2205000,2247200,2289800,2332800,2376200,2420000,	//107 - 117
	2464200,2508800,2553800,2599200,2645000,2691200,2737800,2784800,2832200,2880000,	//118 - 128
	2928200,2976800,3025800,3075200,3125000,3175200,3225800,3276800,3328200,3380000,	//129 - 139
	3432200,3484800,3537800,3591200,3645000,3699200,3753800,3808800,3864200,3920000,	//140 - 150
	3976200,4032800,4089800,4147200,4205000,4263200,4321800,4380800,4440200,4500000,	//151 - 161
	4560200,4620800,4681800,4743200,4805000,4867200,4929800,4992800,5056200,5120000,	//162 - 172
	5184200,5248800,5313800,5379200,5445000,5511200,5577800,5644800,5712200,5780000,	//173 - 183
	5848200,5916800,5985800,6055200,6125000,6195200,6265800,6336800,6408200,6480000,	//184 - 194
	6552200,6624800,6697800,6771200,6845000,6919200,6993800,7068800,7144200,7220000,	//195 - 20... - Jest 200 lvl ... xd
	7296200,7372800,7449800,7527200,7605000,7683200,7761800,7840800,7920200,8070200, 1073741824 //-107[...]  ¿eby nie by³o bugów ;)
	
}


///////////////////////////////////////////////////////

///////////////////////////////////////////////////////

new poziom_gracza[33]
new doswiadczenie_gracza[33]
new punkty_gracza[33]
new ultra_punkty_gracza[33]
new monety_gracza[33]

///////////////////////////////////////////////////////

new zycie_gracza[33], nowe_zycie_gracza[33]
new niewidzialnosc_gracza[33], nowa_niewidzialnosc_gracza[33]
new obrazenia_gracza[33], nowe_obrazenia_gracza[33]
new szybkosc_gracza[33], Float:nowa_szybkosc_gracza[33]
new grawitacja_gracza[33], Float:nowa_grawitacja_gracza[33]
new kasa_gracza[33], nowa_kasa_gracza[33]
new skoki_gracza[33], nowe_skoki_gracza[33]
new longjump_gracza[33], nowy_longujmp_gracza[33], longjump_czas[33], longjump_s_czas[33]

///////////////////////////////////////////////////////

new nazwa_gracza[33];

new plik[] = "ExpMod.txt";

//USER

new p_exp_zabojstwo			//Kill Exp
new p_exp_headshot			//KIll hs Exp
new p_exp_podlozenie_paki		//PP Exp
new p_exp_rozbrojenie_paki		//RP EXP
new p_exp_uratowanie_hosta
new p_exp_infostyle
/*
p_exp_infostyle 	= 0 	// NIC
p_exp_infostyle 	= 1 	// TUTOR
p_exp_infostyle 	= 2 	// COLORCHAT
p_exp_infostyle 	= 3 	// TUTOR + COLORCHAT
*/
new p_exp_tutor_sound			// 1 = Sound | 0 = Nothing
new p_exp_wygrana_runda			// Exp Win Round
new p_exp_boty				// Include Bots ?  1 or 0

// VIP

new p_exp_vip_extra_hp			//Vip extra Hp
new p_exp_vip_extra_speed		//Vip extra speed
new p_exp_vip_extra_gravity		//Vip extra Gravity
new p_exp_vip_extra_monets		//Vip extra monets
new p_exp_vip_extra_exp			//Vip extra exp
new p_exp_vip_extra_hs_exp		//Vip extra hs exp
new p_exp_vip_new_round_info		//Vip Info on new round
new p_exp_vip_new_round_infostyle 

/*Vip Info on new round style 
0 = nothing | 
1 = tutor | 
2 = ColorChat | 
3 = Tutor + Colorchat*/

//ADMIN

new adminek[33]
new id_am // id admin menu

new bool:first_round
new bool:ft = true 			// Freeze Time

new folder_expmod[64]			// addons/amxmodx/ExpMod
new folder_amxx[64] 			// addons/amxmodx/
new plik_expmod_staty[64] 		// addons/amxmodx/ExpMod/expmod_staty.txt
///////////////////////////////////////////////////////

//new Message1				//Sync Hud Obj 1
new Message2				//Sync Hud Obj 2
new Message3				//Sync Hud Obj 3
new Message4				//Sync Hud Obj 4
//new Message5				//Sync Hdu Obj 5

new menu_on[] 		= "ExpMod/menu_on.wav"
new level_up[]		= "ExpMod/levelup.wav"
new level_up2[]		= "ExpMod/levelup2.wav"
new wyzwanie[]		= "ExpMod/wyzwanie.wav"
new komunikat1[]	= "ExpMod/komunikat1.wav"
new komunikat2[]	= "ExpMod/komunikat2.wav"
new odmowa[]		= "ExpMod/odmowa.wav"
new klik[]		= "ExpMod/klik.wav"
new klik2[]		= "ExpMod/klik2.wav"
new pstryk[]		= "ExpMod/pstryk.wav"
new warning[]		= "ExpMod/warning.wav"
new szum[]		= "ExpMod/szum.wav"
new pisk[]		= "ExpMod/pisk.wav"

/*
^
|
Sciezki do dzwiekow
*/
/////////////////////////////////////////////////////
//////////////////////NATYWY/////////////////////////
/////////////////////////////////////////////////////

public plugin_natives()
{
	register_native("exp_get_user_level", 		"get_user_level", 		1);
	register_native("exp_get_levelexp", 		"get_levelexp", 		1);
	register_native("exp_get_user_exp", 		"get_user_exp",			1);
	register_native("exp_get_user_nextlevelexp", 	"get_user_nextlevelexp",	1);
	register_native("exp_get_user_previouslevelexp","get_user_previouslevelexp",	1);
	register_native("exp_set_user_exp", 		"set_user_exp", 		1);
	register_native("exp_set_user_level", 		"set_user_level", 		1);
	register_native("exp_save_exp", 		"ZapiszExp", 			1);
	register_native("exp_set_user_invisible", 	"set_user_invisible", 		1);
	register_native("exp_checklevel", 		"SprawdzExp", 			1);
	register_native("exp_get_user_monets", 		"get_user_monets", 		1);
	register_native("exp_set_user_monets", 		"set_user_monets", 		1);
	register_native("exp_get_user_new_health",	"get_user_new_health", 		1);
	register_native("exp_reset",			"Zresetuj",			1);
	register_native("exp_is_user_vip",		"is_user_vip",			1);

}

///////////////////////////////////////////////////////

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	tutorInit()
	///////////////////////////////////////////////////////
	
	
	register_event("DeathMsg", 	"DeathMsg",		"a");
	register_event("CurWeapon",	"CurWeapon",	"be", 	"1=1");
	register_event("HLTV", 		"RundaHLTV",	"a",	"1=0",	"2=0");
	//register_event("Damage",	"Damage",		"b",	"2!=0");
	register_event("SendAudio", 	"WygraTT", 		"a", 	"2&%!MRAD_terwin");
	register_event("SendAudio", 	"WygraCT", 		"a", 	"2&%!MRAD_ctwin");
	
	///////////////////////////////////////////////////////
	
	register_logevent("RundaLogEvent",2, 		"1=Round_Start");
	register_logevent("KoniecRundyLogEvent", 2, 	"1=Round_End");
	register_logevent("UratowanieHosta",3,		"2=Rescued_A_Hostage")
	
	///////////////////////////////////////////////////////
	
	RegisterHam(Ham_Spawn,		"player",	"OdrodzenieGracza", 1);
	RegisterHam(Ham_TakeDamage, 	"player",	"TakeDamage");
	
	g_MsgScoreAttrib = get_user_msgid("ScoreAttrib");
	register_message(g_MsgScoreAttrib, "messageScoreAttrib");
	
	///////////////////////////USER////////////////////////
	
	register_forward(FM_CmdStart, 	"CmdStart");
	
	p_exp_zabojstwo 		= register_cvar("exp_kill_exp", 		"250");
	p_exp_headshot 			= register_cvar("exp_killhs_exp", 		"100");
	p_exp_podlozenie_paki 		= register_cvar("exp_planted_bomb", 		"350");
	p_exp_rozbrojenie_paki		= register_cvar("exp_defuse_bomb", 		"350");
	p_exp_uratowanie_hosta		= register_cvar("exp_hostage_rescued",		"250");
	p_exp_infostyle 		= register_cvar("exp_infostyle",		"3");
	p_exp_wygrana_runda 		= register_cvar("exp_win_round", 		"200");
	p_exp_boty 			= register_cvar("exp_include_bots", 		"0");
	p_exp_tutor_sound		= register_cvar("exp_tutor_sounds",		"1");
	
	////////////////////////////VIP/////////////////////////
	
	p_exp_vip_extra_hp		= register_cvar("exp_vip_extra_hp",		"75");
	p_exp_vip_extra_speed		= register_cvar("exp_vip_extra_speed",	 	"50.0");
	p_exp_vip_extra_gravity		= register_cvar("exp_vip_extra_gravity", 	"150");
	p_exp_vip_extra_monets		= register_cvar("exp_vip_extra_monets",	 	"1");
	p_exp_vip_extra_exp		= register_cvar("exp_vip_extra_kill_exp", 	"100");
	p_exp_vip_extra_hs_exp		= register_cvar("exp_vip_extra_killhs_exp",	"60");
	p_exp_vip_new_round_info	= register_cvar("exp_vip_info_new_round",	"1");
	p_exp_vip_new_round_infostyle	= register_cvar("exp_vip_info_new_round_style",	"2");
	
	///////////////////////////ADMIN////////////////////////
	
	register_clcmd("ustaw_lvl","ustaw_lvl");
	register_clcmd("ustaw_exp","ustaw_exp");
	register_clcmd("dodaj_lvl","dodaj_lvl");
	register_clcmd("dodaj_exp","dodaj_exp");
	register_clcmd("dodaj_monety","dodaj_monety");
	register_clcmd("ustaw_monety","ustaw_monety");
	
	////////////////////////////////////////////////////////
	
	first_round = true
	
	///////////////////////////////////////////////////////
	
	register_clcmd("say /lvl", 		"Poziom");
	register_clcmd("say /level", 		"Poziom");
	register_clcmd("say /poziom", 		"Poziom");
	
	
	register_clcmd("say /exp", 		"Exp");
	register_clcmd("say /dos", 		"Exp");
	register_clcmd("say /doswiadczenie", 	"Exp");
	
	register_clcmd("say /przydziel", 	"MenuPrzydzielPunkty");
	register_clcmd("say /dodajpunkty", 	"MenuPrzydzielPunkty");
	register_clcmd("say /dodajupunkty", 	"MenuPrzydzielUltraPunkty");
	register_clcmd("say /punkty", 		"Punkty");
	register_clcmd("say /upunkty", 		"UPunkty");
	register_clcmd("say /menu", 		"MenuWybor");
	register_clcmd("menu", 			"MenuWybor");
	
	register_clcmd("say /reset", 		"MenuResetWybor");
	register_clcmd("say /resetuj", 		"MenuResetWybor");
	register_clcmd("say /staty",		"MotdStatystyki");	
	register_clcmd("say /statystyki",	"MotdStatystyki");
	
	register_clcmd("say /reloadcfg", 	"WczytajUstawienia", ADMIN_RCON);
	///////////////////////////////////////////////////////
	
	set_task(0.5, 	"Pokaz", 	123,	 _,	 _, 	"b");
	set_task(180.0, "ZapiszExp", 	_,	 _, 	_, 	"b");
	///////////////////////////////////////////////////////
	
	//Message1= CreateHudSyncObj();
	Message2 = CreateHudSyncObj();
	Message3 = CreateHudSyncObj();
	Message4 = CreateHudSyncObj();
	
	get_basedir(folder_amxx, 63)
	
	formatex(folder_expmod, 	63, "%s/ExpMod", folder_amxx);
	formatex(plik_expmod_staty, 	63, "%s/motd_statytsyki", folder_expmod);
	
	if(!file_exists(folder_expmod))
		mkdir(folder_expmod)
		
	WczytajUstawienia()
}

///////////////////////////////////////////////////////

public Poziom(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE;
	
	if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
		ColorChat(id, GREEN, "[EXPMOD]^x01 Masz^x04 %d / 200^x01 poziom", poziom_gracza[id]);
	
	if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
	{
		if(get_pcvar_num(p_exp_tutor_sound) == 1)
		{
			switch(random_num(1,2))
			{
				case 1: client_cmd(id, "spk %s", komunikat1)
					case 2: client_cmd(id, "spk %s", komunikat2)
				}
		}
		tutorMake(id, TUTOR_GREEN, 5.0, "Masz %d / 200 poziom", poziom_gracza[id]);
	}
	return PLUGIN_CONTINUE;
}

public Exp(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE;
	
	if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
		ColorChat(id, GREEN, "[EXPMOD]^x01 Masz^x04 %d / %d (+%d)^x01 expa.", doswiadczenie_gracza[id], POZIOM[poziom_gracza[id]+1], (POZIOM[poziom_gracza[id]+1]-doswiadczenie_gracza[id]));
	
	if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
	{
		if(get_pcvar_num(p_exp_tutor_sound) == 1)
		{
			switch(random_num(1,2))
			{
				case 1: client_cmd(id, "spk %s", komunikat1)
					case 2: client_cmd(id, "spk %s", komunikat2)
				}
		}
		tutorMake(id, TUTOR_GREEN, 5.0, "Masz %d / %d (+%d) expa", doswiadczenie_gracza[id], POZIOM[poziom_gracza[id]+1], (POZIOM[poziom_gracza[id]+1]-doswiadczenie_gracza[id]));
	}
	return PLUGIN_CONTINUE;
}

public WczytajUstawienia()
{
	new tekst[64], len
	new cvar[64], wartosc[16], komenda[128]
	if(!file_exists(SCIEZKA_PLIKU))
		return PLUGIN_CONTINUE
	for(new i = 0 ; read_file(SCIEZKA_PLIKU, i, tekst, 63, len); i ++)
	{
		if(tekst[0] == ';' || (tekst[0] == '/' && tekst[1] == '/'))
			continue;
		
		parse(tekst, cvar, 63, wartosc, 15)
		if(equali(cvar, "exp_playerinfo_show_time"))
			formatex(komenda, 127, "%s %0.1f%", cvar, str_to_float(wartosc))
		else
			formatex(komenda, 127, "%s %d", cvar, str_to_num(wartosc))
		
		server_cmd(komenda)
	}
	return PLUGIN_CONTINUE
}

///////////////////////////////////////////////////////

public plugin_precache()
{
	tutorPrecache()
	
	precache_sound(menu_on)
	precache_sound(wyzwanie)
	precache_sound(level_up)
	precache_sound(level_up2)
	precache_sound(komunikat1)
	precache_sound(komunikat2)
	precache_sound(odmowa)
	precache_sound(klik)
	precache_sound(klik2)
	precache_sound(pstryk)
	precache_sound(warning)
	precache_sound(szum)
	precache_sound(pisk)
}

///////////////////////////////////////////////////////

///////////////////////////////////////////////////////

public WygraTT()
{
	for(new i = 1;i < 33; i++)
	{
		if(!is_user_connected(i) || first_round == true || get_pcvar_num(p_exp_wygrana_runda) <= 0)
			return PLUGIN_CONTINUE;
		if(get_user_team(i) == 1 && first_round == false)
		{
			doswiadczenie_gracza[i] += get_pcvar_num(p_exp_wygrana_runda);
			SprawdzExp(i);
			ColorChat(i, GREEN, "[EXPMOD]^x01 Dostales^x04 %d^x01 expa za wygrana runde",get_pcvar_num(p_exp_wygrana_runda));
		}
	}
	return PLUGIN_CONTINUE;
}

public WygraCT()
{ 
	for(new i = 1; i < 33; i++)
	{
		if(!is_user_connected(i) || first_round == true || get_pcvar_num(p_exp_wygrana_runda) <= 0)
			return PLUGIN_CONTINUE;
		
		if(get_user_team(i) == 2 && first_round == false)
		{
			doswiadczenie_gracza[i]+=get_pcvar_num(p_exp_wygrana_runda);
			SprawdzExp(i);
			ColorChat(i, GREEN, "[EXPMOD]^x01 Dostales^x04 %d^x01 expa za wygrana runde",get_pcvar_num(p_exp_wygrana_runda));
		}
	}
	return PLUGIN_CONTINUE
}

///////////////////////////////////////////////////////

public Punkty(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE;
	if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
		ColorChat(id, GREEN, "[EXPMOD]^x01 Masz^x04 %d^x01 punktow", punkty_gracza[id]);
	
	if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
	{
		if(get_pcvar_num(p_exp_tutor_sound) == 1)
		{
			switch(random_num(1,2))
			{
				case 1: client_cmd(id, "spk %s", komunikat1)
					case 2: client_cmd(id, "spk %s", komunikat2)
				}
		}
		tutorMake(id, TUTOR_GREEN, 5.0, "Masz %d punktow", punkty_gracza[id]);
	}
	return PLUGIN_CONTINUE;
}

public UPunkty(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE;
	if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
		ColorChat(id, GREEN, "[EXPMOD]^x01 Masz^x04 %d^x01 Ultra Punktow", ultra_punkty_gracza[id]);
	
	if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
	{
		tutorMake(id, TUTOR_GREEN, 5.0, "Masz %d Ultra Punktow", ultra_punkty_gracza[id]);
		if(get_pcvar_num(p_exp_tutor_sound) == 1)
		{
			switch(random_num(1,2))
			{
				case 1: client_cmd(id, "spk %s", komunikat1)
					case 2: client_cmd(id, "spk %s", komunikat2)
				}
		}
	}
	return PLUGIN_CONTINUE;
}


public RundaLogEvent()
{
	ft = false
	
}

///////////////////////////////////////////////////////	

public KoniecRundyLogEvent()
{
	if(first_round == true)
		first_round = false
	for(new i = 1 ; i < 33 ; i++)
	{
		
		if(!is_user_connected(i))
			return PLUGIN_CONTINUE
		if(get_user_team(i))
		{
			doswiadczenie_gracza[i]+= get_pcvar_num(p_exp_wygrana_runda)
			SprawdzExp(i)
		}
		
	}
	return PLUGIN_CONTINUE
}

///////////////////////////////////////////////////////

public RundaHLTV()
{
	ft = true
}

///////////////////////////////////////////////////////

public CurWeapon(id)
{
	if(ft || !is_user_connected(id))
		return PLUGIN_CONTINUE;
	
	if(get_user_flags(id) & VIP_FLAG)
		set_user_maxspeed(id, nowa_szybkosc_gracza[id]+250.0+get_pcvar_float(p_exp_vip_extra_speed))
	else
		set_user_maxspeed(id, nowa_szybkosc_gracza[id]+250.0)
	
	//new bron= read_data(2);
	return PLUGIN_CONTINUE;
}

///////////////////////////////////////////////////////
/*
public Damage(id)
{
	new idattacker = get_user_attacker(id);
	new damage = read_data(2);
	if(!is_user_alive(idattacker) || !is_user_connected(idattacker))
		return PLUGIN_CONTINUE;

	SprawdzExp(idattacker)
	
	return PLUGIN_CONTINUE
}*/
///////////////////////////////////////////////////////

public MenuResetWybor(id)
{
	if(poziom_gracza[id] == 0)
	{
		if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			ColorChat(id, GREEN, "[EXPMOD]^x01 Nie masz czego zresetowac.")
		
		if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
		{
			if(get_pcvar_num(p_exp_tutor_sound) == 1)
			{
				switch(random_num(1,2))
				{
					case 1: client_cmd(id, "spk %s", komunikat1)
						case 2: client_cmd(id, "spk %s", komunikat2)
						
				}
			}
			tutorMake(id, TUTOR_YELLOW, 5.0, "Nie masz czego zresetowac")
		}
		
		return PLUGIN_CONTINUE
	}
	client_cmd(id, "spk %s", menu_on)
	new tytul[128]
	
	formatex(tytul, 127, "Co chcesz zresetowac ?")
	new menu_reset_wybor = menu_create(tytul, "MenuResetWybor_Wybieranie")
	new menu_reset_wybor_cb = menu_makecallback("MenuResetWybor_Cb")
	menu_additem(menu_reset_wybor, "Punkty.", _, _, menu_reset_wybor_cb)
	menu_additem(menu_reset_wybor, "Ultra Punkty.", _, _, menu_reset_wybor_cb)
	
	menu_setprop(menu_reset_wybor, MPROP_NUMBER_COLOR, "\r")
	menu_setprop(menu_reset_wybor, MPROP_EXITNAME, "Wyjscie");
	menu_display(id, menu_reset_wybor)
	
	return PLUGIN_CONTINUE
}

public MenuResetWybor_Cb(id, menu_reset_wybor, item_reset_wybor)
{
	if((item_reset_wybor == 0 && poziom_gracza[id] == 0) || (item_reset_wybor == 1 && poziom_gracza[id] < 10))
		return ITEM_DISABLED
	return ITEM_ENABLED
}

public MenuResetWybor_Wybieranie(id, menu_reset_wybor, item_reset_wybor)
{
	if(item_reset_wybor == MENU_EXIT)
	{
		menu_destroy(menu_reset_wybor)
		return PLUGIN_CONTINUE
	}
	
	switch(item_reset_wybor)
	{
		case 0: MenuResetPunkty(id)
			case 1: MenuResetUltraPunkty(id)
		}
	
	switch(random_num(1,2))
	{
		case 1:client_cmd(id, "spk %s", klik)
			case 2:client_cmd(id, "spk %s", klik2)
		}
	
	return PLUGIN_CONTINUE
}

public MenuResetUltraPunkty(id)
{
	client_cmd(id, "spk %s", menu_on)
	new upr[200]
	formatex(upr, 199, "\rZamierzasz zresetowac \rUltra Punkty^n\yResetujac je tracisz \r2000 expa\y^nWiesz co robisz?")
	new menu_reset_ultrapunkty = menu_create(upr, "MenuResetUltraPunkty_Wybieranie")
	menu_additem(menu_reset_ultrapunkty, "\yTak, wiem co robie")
	
	menu_setprop(menu_reset_ultrapunkty, MPROP_NUMBER_COLOR, "\r")
	menu_setprop(menu_reset_ultrapunkty, MPROP_EXITNAME, "Wyjscie");
	
	menu_display(id, menu_reset_ultrapunkty)
}

public MenuResetUltraPunkty_Wybieranie(id, menu_reset_ultrapunkty, item_reset_ultrapunkty)
{
	if(item_reset_ultrapunkty == MENU_EXIT)
	{
		menu_destroy(menu_reset_ultrapunkty)
		return PLUGIN_CONTINUE
	}
	if(item_reset_ultrapunkty == 0)
	{
		Zresetuj(id, 0, 1, 0)
		if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
		{
			ColorChat(id, GREEN, "[EXPMOD]^x01 Wlasnie zrestowales swoje ^x01Ultra Punkty.")
			ColorChat(id, GREEN, "[EXPMOD]^x01 Aktualnie masz :^x04 %i^x01 Ultra Punktow.", ultra_punkty_gracza[id])
		}
		if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
		{
			if(get_pcvar_num(p_exp_tutor_sound) == 1)
			{
				switch(random_num(1,2))
				{
					case 1: client_cmd(id, "spk %s", komunikat1)
						case 2: client_cmd(id, "spk %s", komunikat2)
						
				}
			}
			
			tutorMake(id, TUTOR_GREEN, 10.0, "Wlasnie zrestowales swoje Ultra Punkty^nAktualnie masz : %i Ultra Punktow.", ultra_punkty_gracza[id])
		}
		set_user_exp(id, get_user_exp(id)-2000)
		
		MenuWybor(id)
	}
	switch(random_num(1,2))
	{
		case 1:client_cmd(id, "spk %s", klik)
			case 2:client_cmd(id, "spk %s", klik2)
		}
	
	return PLUGIN_CONTINUE
}

public MenuResetPunkty(id)
{
	client_cmd(id, "spk %s", menu_on)
	Zresetuj(id, 1, 0, 0)
	if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
	{
		ColorChat(id, GREEN, "[EXPMOD]^x01 Wlasnie zrestowales swoje ^x01Punkty.")
		ColorChat(id, GREEN, "[EXPMOD]^x01 Aktualnie masz :^x04 %i ^x01Punktow.", punkty_gracza[id])
	}
	
	if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
	{
		if(get_pcvar_num(p_exp_tutor_sound) == 1)
		{
			switch(random_num(1,2))
			{
				case 1: client_cmd(id, "spk %s", komunikat1)
					case 2: client_cmd(id, "spk %s", komunikat2)
					
			}
		}
		tutorMake(id, TUTOR_GREEN, 10.0, "Wlasnie zrestowales swoje Punkty^nAktualnie masz : %i Punktow.", punkty_gracza[id])
	}
	
	MenuWybor(id)
}

///////////////////////////////////////////////////////

public client_connect(id)
{
	WczytajExp(id)
	
	client_cmd(id, "bind ^"v^" ^"menu^"")
	
	if(get_user_flags(id) & VIP_FLAG)
	{
		get_user_name(id, nazwa_gracza, 32)
		if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			ColorChat(0, GREEN, "[EXPMOD: VIP]^x01 Na serwer wchodzi^x04 VIP^x01 : ^x04%s", nazwa_gracza)
		
		if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
		{
			if(get_pcvar_num(p_exp_tutor_sound) == 1)
			{
				switch(random_num(1,2))
				{
					case 1: client_cmd(id, "spk %s", komunikat1)
						case 2: client_cmd(id, "spk %s", komunikat2)
						
				}
			}
			
			tutorMake(0, TUTOR_YELLOW, 7.0, "Na serwer wchodzi VIP : %s^nWitamy na serwerze!", nazwa_gracza)
		}
	}
}

///////////////////////////////////////////////////////

public client_disconnect(id)
{
	ZapiszExp(id)
	client_cmd(id, "unbind ^"v^"")
	
	if(get_user_flags(id) & VIP_FLAG)
	{
		get_user_name(id, nazwa_gracza, 32)
		if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			ColorChat(0, GREEN, "[EXPMOD: VIP]^x01 Z serwera wyszedl^x04 VIP^x01 : ^x04%s", nazwa_gracza)
		
		if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
		{
			if(get_pcvar_num(p_exp_tutor_sound) == 1)
			{
				switch(random_num(1,2))
				{
					case 1: client_cmd(id, "spk %s", komunikat1)
						case 2: client_cmd(id, "spk %s", komunikat2)
						
				}
			}
			tutorMake(0, TUTOR_YELLOW, 7.0, "Z serwera wyszedl VIP : %s^nZegnamy!", nazwa_gracza)
		}
		
	}
}


///////////////////////////////////////////////////////

public OdrodzenieGracza(id)
{
	if(is_user_alive(id) && is_user_connected(id))
	{
		if(punkty_gracza[id] > 0 || ultra_punkty_gracza[id] > 0)
			MenuWybor(id)
		if(get_pcvar_num(p_exp_vip_new_round_info) == 1)
		{
			if(get_user_flags(id) & VIP_FLAG)
			{
				if(get_pcvar_num(p_exp_vip_new_round_infostyle) == 3 || get_pcvar_num(p_exp_vip_new_round_infostyle) == 1)
				{
					if(get_pcvar_num(p_exp_tutor_sound) == 1)
					{
						switch(random_num(1,2))
						{
							case 1:client_cmd(id, "spk %s", komunikat2)
							case 2:client_cmd(id, "spk %s", komunikat1)
						}
					}
					tutorMake(id, TUTOR_YELLOW, 5.0, "Jestes VIP'EM^nDostajesz : +%d HP | -%d GRAV^n+%0.1f% SPEED", get_pcvar_num(p_exp_vip_extra_hp),get_pcvar_num(p_exp_vip_extra_gravity),get_pcvar_float(p_exp_vip_extra_speed))
				}
				if(get_pcvar_num(p_exp_vip_new_round_infostyle) == 2 || get_pcvar_num(p_exp_vip_new_round_infostyle) == 3)
				{
					ColorChat(id, GREEN, "[EXPMOD]^x01 Jestes ^x04VIP'EM^x01!")
					ColorChat(id, GREEN, "[EXPMOD]^x01 Dostajesz dodatkowe : ^x04+%d ^x01HP | ^x04-%d ^x01GRAV | ^x04+%0.1f ^x01SPEED",get_pcvar_num(p_exp_vip_extra_hp),get_pcvar_num(p_exp_vip_extra_gravity),get_pcvar_float(p_exp_vip_extra_speed))
				}
			}
		}
		set_user_invisible(id, (255-nowa_niewidzialnosc_gracza[id]))
		
		if((cs_get_user_money(id)+nowa_kasa_gracza[id]) > 16000)
			cs_set_user_money(id, 16000)
		else	
			cs_set_user_money(id, cs_get_user_money(id)+nowa_kasa_gracza[id])
			
		if(get_user_flags(id) & VIP_FLAG)
		{
			set_user_health(id, get_user_health(id)+nowe_zycie_gracza[id]+get_pcvar_num(p_exp_vip_extra_hp))
			set_user_gravity(id, ((800-nowa_grawitacja_gracza[id])-get_pcvar_num(p_exp_vip_extra_gravity))/800)
		}
		else 
		{
			set_user_gravity(id, (800-nowa_grawitacja_gracza[id])/800)
			set_user_health(id, get_user_health(id)+nowe_zycie_gracza[id])
		}
		
		if((get_user_health(id)%256) == 0)
			set_user_health(id, get_user_health(id)+1);
			
			
	}
	else
		return PLUGIN_CONTINUE
	return PLUGIN_CONTINUE
}

///////////////////////////////////////////////////////

public MenuWybor(id)
{		
	new wybor[64];
	client_cmd(id, "spk %s", menu_on)
	formatex(wybor, 63, "\wMasz \r%d\w pkt. i \r%d\w ultra pkt^nMasz \r%i\w monet.", punkty_gracza[id], ultra_punkty_gracza[id], monety_gracza[id])
	
	new menu_wybor = menu_create(wybor, "MenuWybor_Wybieranie")
	new menu_wybor_cb = menu_makecallback("MenuWybor_CallBack")
	
	menu_additem(menu_wybor, "Przydziel Punkty", _, _, menu_wybor_cb)
	menu_additem(menu_wybor, "Przydziel Ultra Punkty", _, _, menu_wybor_cb)
	menu_additem(menu_wybor, "Statystyki")
	menu_additem(menu_wybor, "Reset",_, _, menu_wybor_cb)
	menu_additem(menu_wybor, "Sklep")
	menu_additem(menu_wybor, "Misje")
	menu_additem(menu_wybor, "Informacje o Misjach")
	menu_additem(menu_wybor, "Anuluj Misje")
	menu_additem(menu_wybor, "Achievementy")
	menu_additem(menu_wybor, "Informacje o Achievementach")
	menu_additem(menu_wybor, "Menu Admina", _, ADMIN_MENU_FLAG)
	
	
	menu_setprop(menu_wybor, MPROP_NUMBER_COLOR, "\r");
	menu_setprop(menu_wybor, MPROP_EXITNAME, "Wyjscie");
	menu_display(id, menu_wybor)
	if(get_pcvar_num(p_exp_boty) == 1)
	{
		if(is_user_bot(id))
		{
			if(punkty_gracza[id] > 0)
				MenuPrzydzielPunkty(id)
			else if(punkty_gracza[id] <= 0 && ultra_punkty_gracza[id] > 0)
				MenuPrzydzielUltraPunkty(id)
		}
	}
}

public MenuWybor_CallBack(id, menu_wybor, item_wybor)
{
	if((item_wybor == 0 && punkty_gracza[id] <= 0) || (item_wybor == 1 && ultra_punkty_gracza[id] <= 0))
		return ITEM_DISABLED
	
	if(item_wybor == 3 && poziom_gracza[id] == 0)
		return ITEM_DISABLED
	
	if(item_wybor == 7 && exp_get_user_mission(id) == 0)
		return ITEM_DISABLED
		
	if(item_wybor == 10 && !(get_user_flags(id) & ADMIN_MENU_FLAG))
		return ITEM_DISABLED
	
	return ITEM_ENABLED
}

public MenuWybor_Wybieranie(id, menu_wybor, item_wybor)
{
	if(item_wybor == MENU_EXIT)
	{
		menu_destroy(menu_wybor)
		return PLUGIN_CONTINUE
	}
	
	switch(item_wybor)
	{
		case 0: MenuPrzydzielPunkty(id)
			
		case 1: MenuPrzydzielUltraPunkty(id)
			
		case 2: MotdStatystyki(id)
			
		case 3: MenuResetWybor(id)
			
		case 4: client_cmd(id, "say /sklep")
		
		case 5: client_cmd(id, "say /misja")
		
		case 6: client_cmd(id, "say /opisy")
		
		case 7: client_cmd(id, "say /anuluj")
			
		case 8: client_cmd(id, "say /ach")
			
		case 9: client_cmd(id, "say /achievementy")
			
		case 10: MenuAdmin(id)
		
		}
	
	switch(random_num(1,2))
	{
		case 1:client_cmd(id, "spk %s", klik)
			case 2:client_cmd(id, "spk %s", klik2)
		}
	return PLUGIN_CONTINUE
}	

public MotdStatystyki(id)
{
	new txt1[250], txt2[250], txt3[250], txt4[250], txt5[250], txt6[300], txt7[320]
	
	new punkty = (zycie_gracza[id]+szybkosc_gracza[id]+grawitacja_gracza[id]+kasa_gracza[id]+punkty_gracza[id])
	new ultrapunkty = (niewidzialnosc_gracza[id]+obrazenia_gracza[id]+skoki_gracza[id]+longjump_gracza[id]+ultra_punkty_gracza[id])
	new ileMa = floatround(nowa_szybkosc_gracza[id]), ilePotrzeba = 105, ilePotrzebaBylo = 0;
	new Float:nszybkosc = 0.0;
	
	new ile_ma = floatround(nowa_grawitacja_gracza[id]),ile_potrzeba = 800, ile_potrzeba_bylo = 0;
	new Float:ngrawitacja = 0.0;
	
	new ileMa1 = nowa_niewidzialnosc_gracza[id], ilePotrzeba1 = 255, ilePotrzebaBylo1 = 0;
	new Float:nniewidzialnosc = 0.0;
	
	nniewidzialnosc = (float((ileMa1 - ilePotrzebaBylo1)) / float((ilePotrzeba1 - ilePotrzebaBylo1))) * 100.0;
	nszybkosc = (float((ileMa - ilePotrzebaBylo)) / float((ilePotrzeba - ilePotrzebaBylo))) * 100.0;
	ngrawitacja = (float((ile_ma - ile_potrzeba_bylo)) / float((ile_potrzeba - ile_potrzeba_bylo))) * 100.0;
	
	format(txt1, 249, "<body bgcolor=^"#000000^"><p align=^"center^"><font size=^"5^"><b>STATYSTYKI :</b></font></p align><font color=^"purple^"><font size=^"5^"><b>W sumie zebrales %d / %d expa.<p>", get_user_exp(id), get_user_nextlevelexp(id))
	format(txt2, 249, "<font color=^"brown^">Do nastepnego poziomu brakuje ci %d expa<p><font color=^"yellow^">Masz %d / 200 poziom i %d Monet.<p><font color=^"blue^">W sumie zebrales %d Punktow i %d Ultra Punktow", (get_user_nextlevelexp(id)-get_user_exp(id)), poziom_gracza[id], monety_gracza[id], punkty, ultrapunkty)
	format(txt3, 249, "<font color=^"pink^"><p align=^"center^"><font size=^"5^"><b>PUNKTY</b></font></p align><font size=^"4^"><font color=^"#CBCBCB^">Zycie :<font color=^"red^">  %i  ( Zwieksza zycie o %i ) ", zycie_gracza[id], nowe_zycie_gracza[id])
	format(txt4, 249, "<p><font size=^"4^"><font color=^"#CBCBCB^">Szybkosc :<font color=^"red^">  %i ( Biegasz szybciej o %0.1f%% )<p><font size=^"4^"><font color=^"#CBCBCB^">Grawitacja :<font color=^"red^">  %i ( Skaczesz wyzej o %0.1f%% )", szybkosc_gracza[id], nszybkosc,grawitacja_gracza[id], ngrawitacja)
	format(txt5, 249, "<p><font size=^"4^"><font color=^"#CBCBCB^">Kasa :<font color=^"red^">  %i ( Co runde dostajesz o $%d wiecej Kasy )<font color=^"pink^"><p align=^"center^"><font size=^"5^"><b>ULTRA PUNKTY</b></font></p align>", kasa_gracza[id], nowa_kasa_gracza[id])
	format(txt6, 299, "<p><font size=^"4^"><font color=^"#CBCBCB^">Niewidzialnosc :<font color=^"red^">  %i ( Jestes niewidzialny w %0.1f%% )<p><font size=^"4^"><font color=^"#CBCBCB^">Obrazenia :<font color=^"red^">  %i ( Zadajesz o %d dodatkowych obrazen )", niewidzialnosc_gracza[id], nniewidzialnosc, obrazenia_gracza[id], nowe_obrazenia_gracza[id])
	format(txt7, 319, "<p><font size=^"4^"><font color=^"#CBCBCB^">Skoki : <font color=^"red^">  %i ( Mozesz podskoczyc %d razy w powietrzu )<p><font size=^"4^"><font color=^"#CBCBCB^">LongJump :<font color=^"red^">  %i ( Skaczesz na odleglosc %d m. co %d s. )", skoki_gracza[id], nowe_skoki_gracza[id], longjump_gracza[id], nowy_longujmp_gracza[id], longjump_s_czas[id])

	write_file(plik_expmod_staty,txt1, 1)
	write_file(plik_expmod_staty,txt2, 2)
	write_file(plik_expmod_staty,txt3, 3)
	write_file(plik_expmod_staty,txt4, 4)
	write_file(plik_expmod_staty,txt5, 5)
	write_file(plik_expmod_staty,txt6, 6)
	write_file(plik_expmod_staty,txt7, 7)
	
	show_motd(id, plik_expmod_staty)
}
///////////////////////////////////////////////////////

public MenuPrzydzielUltraPunkty(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE
	
	client_cmd(id, "spk %s", menu_on)
	new uprzydziel[128], niewidzialnosc[128], obrazenia[128], skoki[128], longjump[150]
	
	new ileMa = nowa_niewidzialnosc_gracza[id], ilePotrzeba = 255, ilePotrzebaBylo = 0;
	new Float:fProcent = 0.0;
	
	fProcent = (float((ileMa - ilePotrzebaBylo)) / float((ilePotrzeba - ilePotrzebaBylo))) * 100.0;
	
	formatex(uprzydziel, 127, "\yTwoje Ultra Punkty : \r%d ^n\dResetujac \yUltra Punkty\d tracisz 2000 expa.", ultra_punkty_gracza[id])
	formatex(niewidzialnosc, 127, "Niewidzialnosc : \r%i \w( Jestes niewidzialny w :\r %0.1f%%\w )", niewidzialnosc_gracza[id], fProcent)
	formatex(obrazenia, 127, "Obrazenia : \r%d \w( Zadajesz\r %d \wdod. obrazen )", obrazenia_gracza[id], nowe_obrazenia_gracza[id])
	formatex(skoki, 127, "Skoki : \r%d \w( Dodatkowe skoki w powietrzu :\y %i\w )", skoki_gracza[id], nowe_skoki_gracza[id])
	formatex(longjump, 149, "Longjump : \r%d \w( Skaczesz na odleglosc :\y %i m.\w co \r%i\w s. ) \dCTRL+SPACE", longjump_gracza[id], nowy_longujmp_gracza[id], longjump_s_czas[id])
	
	new menu_upunkty = menu_create(uprzydziel, "MenuPrzydzielUltraPunkty_Wb")
	new menu_upunkty_cb = menu_makecallback("MenuPrzydzielUltraPunkty_CB")
	menu_additem(menu_upunkty, niewidzialnosc, _, _, menu_upunkty_cb)
	menu_additem(menu_upunkty, obrazenia, _, _, menu_upunkty_cb)
	menu_additem(menu_upunkty, skoki , _, _, menu_upunkty_cb)
	menu_additem(menu_upunkty, longjump , _, _, menu_upunkty_cb)
	
	menu_setprop(menu_upunkty, MPROP_NUMBER_COLOR,"\r");
	menu_setprop(menu_upunkty, MPROP_EXITNAME,"Wyjscie");
	menu_display(id, menu_upunkty)
	if(get_pcvar_num(p_exp_boty) == 1)
	{
		if(is_user_bot(id))
		{
			MenuPrzydzielUltraPunkty_Wb(id, menu_upunkty, random_num(0, 3))
		}
	}
	return PLUGIN_CONTINUE
}

public MenuPrzydzielUltraPunkty_CB(id, menu_upunkty, item_upunkty)
{
	if((item_upunkty == 0 && niewidzialnosc_gracza[id] >= MAX_ULTRA_PUNKTOW) || (item_upunkty == 1 && obrazenia_gracza[id] >= MAX_ULTRA_PUNKTOW) || (item_upunkty == 2 && skoki_gracza[id] >= MAX_ULTRA_PUNKTOW) || (item_upunkty == 3 && longjump_gracza[id] >= MAX_ULTRA_PUNKTOW))
		return ITEM_DISABLED
	return ITEM_ENABLED
}
public MenuPrzydzielUltraPunkty_Wb(id, menu_upunkty, item_upunkty)
{
	if(item_upunkty == MENU_EXIT || !is_user_connected(id))
	{
		if(punkty_gracza[id] > 0)
			MenuWybor(id)
		
		menu_destroy(menu_upunkty)
		return PLUGIN_CONTINUE
	} 
	
	switch(item_upunkty)
	{
		case 0:
		{
			ultra_punkty_gracza[id]--
			niewidzialnosc_gracza[id]++
			nowa_niewidzialnosc_gracza[id] = niewidzialnosc_gracza[id]*MNOZNIK_NIEWIDZIALNOSCI
		}
		case 1:
		{
			ultra_punkty_gracza[id]--
			obrazenia_gracza[id]++
			nowe_obrazenia_gracza[id] = obrazenia_gracza[id]*MNOZNIK_OBRAZEN
		}
		case 2:
		{
			ultra_punkty_gracza[id]--
			skoki_gracza[id]++
			nowe_skoki_gracza[id] = skoki_gracza[id]*MNOZNIK_SKOKOW
		}
		case 3:
		{
			ultra_punkty_gracza[id]--
			longjump_gracza[id]++
			nowy_longujmp_gracza[id] = longjump_gracza[id]*MNOZNIK_LONGJUMPA
			longjump_s_czas[id] = (14-longjump_gracza[id]*2)
		}
	}
	switch(random_num(1,2))
	{
		case 1:client_cmd(id, "spk %s", klik)
			case 2:client_cmd(id, "spk %s", klik2)
		}
	
	
	if(ultra_punkty_gracza[id] > 0)
		MenuPrzydzielUltraPunkty(id)
	else if(punkty_gracza[id] > 0 )
		MenuWybor(id)
	
	return PLUGIN_CONTINUE
}

///////////////////////////////////////////////////////


public MenuPrzydzielPunkty(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE
	
	client_cmd(id, "spk %s", menu_on)
	
	new przydziel[33], hp[64], szybkosc[64], grawitacja[64], kasa[64]
	
	new ileMa = floatround(nowa_szybkosc_gracza[id]), ilePotrzeba = 105, ilePotrzebaBylo = 0;
	new Float:fProcent = 0.0;
	
	new ile_ma = floatround(nowa_grawitacja_gracza[id])
	new ile_potrzeba = 800
	new ile_potrzeba_bylo = 0;
	new Float:procent = 0.0;
	
	fProcent = (float((ileMa - ilePotrzebaBylo)) / float((ilePotrzeba - ilePotrzebaBylo))) * 100.0;
	procent = (float((ile_ma - ile_potrzeba_bylo)) / float((ile_potrzeba - ile_potrzeba_bylo))) * 100.0;
	
	formatex(przydziel, 32, "\yTwoje punkty : \r%d \w-", punkty_gracza[id])
	formatex(hp, 63, "Zycie : \r%i \w( Zwieksza zycie o \y%i\w )", zycie_gracza[id], nowe_zycie_gracza[id])
	formatex(szybkosc, 63, "Szybkosc : \r%i \w( Biegasz szybciej o \y%0.1f%% \w)", szybkosc_gracza[id], fProcent)
	formatex(grawitacja, 63, "Grawitacja : \r%i \w( Skaczesz wyzej o \y%0.1f%% \w)", grawitacja_gracza[id], procent)
	formatex(kasa, 63, "Kasa : \r%i \w( Co runde dostajesz \y$%i \w)", kasa_gracza[id], nowa_kasa_gracza[id])
	
	new menu_punkty_cb = menu_makecallback("MenuPrzydzielPunkty_CallBack")
	
	new menu_punkty = menu_create(przydziel, "MenuPrzydzielPunkty_Wybieranie")
	menu_additem(menu_punkty, hp, _, _, menu_punkty_cb)
	menu_additem(menu_punkty, szybkosc, _, _, menu_punkty_cb)
	menu_additem(menu_punkty, grawitacja, _, _, menu_punkty_cb)
	menu_additem(menu_punkty, kasa, _, _, menu_punkty_cb)
	menu_additem(menu_punkty, "Dodaj \r5\w punktow w \yZycie", _, _, menu_punkty_cb)
	menu_additem(menu_punkty, "Dodaj \r5\w punktow w \ySzybkosc", _, _, menu_punkty_cb)
	menu_additem(menu_punkty, "Dodaj \r5\w punktow w \yGrawitacje", _, _, menu_punkty_cb)
	menu_additem(menu_punkty, "Dodaj \r5\w punktow w \yKase", _, _, menu_punkty_cb)
	
	menu_setprop(menu_punkty, MPROP_NUMBER_COLOR,"\r");
	menu_setprop(menu_punkty, MPROP_EXITNAME,"Wyjscie");
	menu_display(id, menu_punkty)
	if(get_pcvar_num(p_exp_boty) == 1)
	{
		if(is_user_bot(id))
		{
			if(punkty_gracza[id] > 0)
				MenuPrzydzielPunkty_Wybieranie(id, menu_punkty, random_num(0, 3))
			else if(punkty_gracza[id] <= 0 && ultra_punkty_gracza[id] > 0)
				MenuPrzydzielUltraPunkty(id)
		}
	}
	return PLUGIN_CONTINUE
}

public MenuPrzydzielPunkty_CallBack(id, menu_punkty, item_punkty)
{
	if((item_punkty == 0 && zycie_gracza[id] >= MAX_PUNKTOW) || (item_punkty == 1 && szybkosc_gracza[id] >= MAX_PUNKTOW) || (item_punkty == 2 && grawitacja_gracza[id] >= MAX_PUNKTOW) || (item_punkty == 3 && kasa_gracza[id] >= MAX_PUNKTOW))
	{
		return ITEM_DISABLED
	}
	if((item_punkty == 4 && zycie_gracza[id]+5 >= MAX_PUNKTOW) ||(item_punkty == 5 && szybkosc_gracza[id]+5 >= MAX_PUNKTOW) ||(item_punkty == 6 && grawitacja_gracza[id]+5 >= MAX_PUNKTOW) ||(item_punkty == 7 && kasa_gracza[id]+5 >= MAX_PUNKTOW))
		return ITEM_DISABLED
	for(new i = 4 ; i < 8 ;i++)
	{
		if(item_punkty == i && punkty_gracza[id] < 5)
			return ITEM_DISABLED
	}
	
	return ITEM_ENABLED
	
}

///////////////////////////////////////////////////////

public plugin_cfg()
	server_cmd("sv_maxspeed 9999")

///////////////////////////////////////////////////////

public CmdStart(id, uc_handle)
{
	if(!is_user_alive(id) || !is_user_connected(id))
		return FMRES_IGNORED;
	
	new button = get_uc(uc_handle, UC_Buttons);
	new oldbutton = get_user_oldbutton(id);
	new flags = get_entity_flags(id);
	
	// Skoki
	
	if(skoki_gracza[id] > 0)
	{
		if(is_user_bot(id) && get_pcvar_num(p_exp_boty) == 1 && (button & IN_JUMP))
			set_task(0.4, "BotySkocz")
		
		if((button & IN_JUMP) && !(flags & FL_ONGROUND) && !(oldbutton & IN_JUMP) && nowe_skoki_gracza[id] > 0)
		{
			nowe_skoki_gracza[id]--;
			if(nowe_skoki_gracza[id] > 0)
				client_print(id, print_center, "Mozesz skoczyc jeszcze %d raz/y", nowe_skoki_gracza[id])
			
			new Float:velocity[3];
			entity_get_vector(id,EV_VEC_velocity,velocity);
			velocity[2] = random_float(265.0,285.0);
			entity_set_vector(id,EV_VEC_velocity,velocity);
		}
		else if(flags & FL_ONGROUND)
		{	
			nowe_skoki_gracza[id] = skoki_gracza[id]*MNOZNIK_SKOKOW
		}
	}
	
	//Long Jump
	
	if(longjump_gracza[id] > 0 && (button & IN_JUMP) && (button & IN_DUCK) && get_gametime() > (longjump_czas[id]+float((longjump_s_czas[id]))) && !ft)
	{
		longjump_czas[id] = floatround(get_gametime())
		client_print(id, print_center, "Uzyles LongJumpa. Odczekaj %ds", longjump_s_czas[id])
		new Float:velocity[3]
		VelocityByAim(id, 700, velocity);
		velocity[2] = (162.5+float(nowy_longujmp_gracza[id]))
		entity_set_vector(id, EV_VEC_velocity, velocity);
	}
	
	return FMRES_IGNORED;
}

public BotySkocz(id)
{
	if(is_user_bot(id))
	{
		client_cmd(id, "-jump")
		client_cmd(id, "+jump")
	}
}
///////////////////////////////////////////////////////


public MenuPrzydzielPunkty_Wybieranie(id, menu_punkty, item_punkty)
{				
	if(item_punkty == MENU_EXIT || !is_user_connected(id))
	{
		if(ultra_punkty_gracza[id] > 0)
			MenuPrzydzielUltraPunkty(id)
		
		menu_destroy(menu_punkty)
		return PLUGIN_CONTINUE
	}
	
	switch(item_punkty)
	{
		case 0:
		{
			punkty_gracza[id]--
			zycie_gracza[id]++
			nowe_zycie_gracza[id] = zycie_gracza[id]*MNOZNIK_ZYCIA
		}
		case 1:
		{
			punkty_gracza[id]--
			szybkosc_gracza[id]++
			nowa_szybkosc_gracza[id] = szybkosc_gracza[id]*MNOZNIK_SZYBKOSCI
		}
		case 2:
		{
			punkty_gracza[id]--
			grawitacja_gracza[id]++
			nowa_grawitacja_gracza[id] = grawitacja_gracza[id]*MNOZNIK_GRAWITACJI
		}
		case 3:
		{
			punkty_gracza[id]--
			kasa_gracza[id]++
			nowa_kasa_gracza[id] = kasa_gracza[id]*MNOZNIK_KASY
		}
		case 4:
		{
			punkty_gracza[id]-=5
			zycie_gracza[id]+=5
			nowe_zycie_gracza[id] = zycie_gracza[id]*MNOZNIK_ZYCIA
		}
		case 5:
		{
			punkty_gracza[id]-=5
			szybkosc_gracza[id]+=5
			nowa_szybkosc_gracza[id] = szybkosc_gracza[id]*MNOZNIK_SZYBKOSCI
		}
		case 6:
		{
			punkty_gracza[id]-=5
			grawitacja_gracza[id]+=5
			nowa_grawitacja_gracza[id] = grawitacja_gracza[id]*MNOZNIK_GRAWITACJI
		}
		case 7:
		{
			punkty_gracza[id]-=5
			kasa_gracza[id]+=5
			nowa_kasa_gracza[id] = kasa_gracza[id]*MNOZNIK_KASY
		}
	}
	
	switch(random_num(1,2))
	{
		case 1:client_cmd(id, "spk %s", klik)
			case 2:client_cmd(id, "spk %s", klik2)
		}
	
	if(punkty_gracza[id] > 0)
		MenuPrzydzielPunkty(id)
	else if(ultra_punkty_gracza[id] > 0 )
		MenuWybor(id)
	
	return PLUGIN_CONTINUE
}

///////////////////////////////////////////////////////

public TakeDamage(this, idinflictor, idattacker, Float:damage, damagebits)
{
	if(!is_user_alive(this) || !is_user_connected(this) || !is_user_connected(idattacker))
		return HAM_IGNORED
	
	//new zycie = get_user_health(this);
	//new bron = get_user_weapon(idattacker);
	
	
	if(obrazenia_gracza[idattacker] > 0)
		damage+=nowe_obrazenia_gracza[idattacker]
	
	SetHamParamFloat(4, damage);
	return HAM_IGNORED;
}


public MenuAdmin(id)
{
	new menu = menu_create("Witaj adminie, wybierz gracza", "MenuAdmin1")
	new nick[33]
	for(new i = 1; i < 33;i++)
	{
		if(!is_user_connected(i) || is_user_hltv(i))
			continue;
		get_user_name(i, nick, 32)
		menu_additem(menu, nick)
	}
	menu_display(id, menu)
}

public MenuAdmin1(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	item++
	
	switch(random_num(1,2))
	{
		case 1:client_cmd(id, "spk %s", klik)
		case 2:client_cmd(id, "spk %s", klik2)
	}
	
	id_am = item;
	
	new title[256], nick[33], misja[64]
	
	exp_get_mission_name(exp_get_user_mission(id_am), misja, 63)
	get_user_name(id_am, nick, 32)
	
	formatex(title, 256, "Gracz:^n\r%s^n\yPoziom: \r%d \yExp:\r %d^n\yMonety: \r%d^n\yMisja:\r %s^nCo chcesz zrobic?",nick, poziom_gracza[id_am], doswiadczenie_gracza[id_am], monety_gracza[id_am], misja)
	
	new menus = menu_create(title, "MenuAdmin2")
	
	menu_additem(menus, "Dodac Poziom")
	menu_additem(menus, "Dodac Exp")
	menu_additem(menus, "Dodac Monety")
	menu_additem(menus, "Ustawic Poziom")
	menu_additem(menus, "Ustawic Exp")
	menu_additem(menus, "Ustawic Monety")
	menu_additem(menus, "Zardzadzac Misjami")
	menu_additem(menus, "->Przeladuj Config Servera")
	
	menu_display(id, menus)
	
	return PLUGIN_CONTINUE
}
public MenuAdmin2(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	switch(item)
	{
		case 0:MenuAdminDodajPoziom(id)
		
		case 1:MenuAdminDodajExp(id)
		
		case 2:MenuAdminDodajMonety(id)
		
		case 3:MenuAdminUstawPoziom(id)
		
		case 4:MenuAdminUstawExp(id)
		
		case 5:MenuAdminUstawMonety(id)
		
		case 6:MenuAdminZarzadzajMisjami(id)
		
		case 7:
		{
			WczytajUstawienia()
			ColorChat(id, GREEN, "[EXPMOD]^x01 Config Zostal Pomyslnie Przeladowany !")
		}
	}
	return PLUGIN_CONTINUE
}
new id_misji;
public MenuAdminZarzadzajMisjami(id)
{
	new menu = menu_create("Wybierz misje", "MenuAdminZarzadzajMisjami1"), misja[64]
	
	for(new i = 1; i <= exp_get_missions_numbers(); i++)
	{
		exp_get_mission_name(i, misja, 63)
		menu_additem(menu, misja)
	}
	menu_display(id, menu)
}
public MenuAdminZarzadzajMisjami1(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	item++
	id_misji = item;
	new misja[64], title[128], nick[33]
	
	get_user_name(id_am, nick, 32)
	exp_get_mission_name(item, misja, 63)
	
	formatex(title, 128, "Co chcesz zrobic z misja:^n\r%s\w, dla gracza:^n\r%s^n\y?", misja, nick)
	new menu = menu_create(title, "MenuAdminZarzadzajMisjami2");
	
	new menu_cb = menu_makecallback("MenuAdminZarzadzajMisjamiCb");
	
	menu_additem(menu, "Ustawic", _, _, menu_cb)
	menu_additem(menu, "Odblokowac", _, _, menu_cb)
	menu_additem(menu, "Anulowac", _, _, menu_cb)
	menu_additem(menu, "Zablokowac", _, _, menu_cb)
	menu_additem(menu, "Anulowac i Zablokowac", _, _, menu_cb)
	
	menu_display(id, menu)
	return PLUGIN_CONTINUE
}
public MenuAdminZarzadzajMisjamiCb(id, menu, item)
{
	if(item == 0 && exp_get_user_mission(id_am) == id_misji)
		return ITEM_DISABLED
	if(item == 1 && exp_get_mission_status(id_am, id_misji) == 0)
		return ITEM_DISABLED
	if(item == 2 && exp_get_user_mission(id_am) != id_misji)
		return ITEM_DISABLED
	if(item == 3 && exp_get_mission_status(id_am, id_misji) == 1)
		return ITEM_DISABLED
	if(item == 4 && exp_get_user_mission(id_am) != id_misji)
		return ITEM_DISABLED
	
	return ITEM_ENABLED
}
public MenuAdminZarzadzajMisjami2(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	new nick[33], misja[64]
	get_user_name(id, adminek, 32)
	get_user_name(id_am, nick, 32)
	exp_get_mission_name(id_misji, misja, 63)
	
	if(item == 0)
	{
		exp_set_user_mission(id_am, id_misji, 0)
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Admin^x04 %s^x01 Ustawil Misje^x04 %s^x01 graczowi^x04 %s", adminek, misja, nick)
	}
	if(item == 1)
	{
		exp_set_mission_status(id_am, id_misji, 0)
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Admin^x04 %s^x01 Odblokowal Misje^x04 %s^x01 graczowi^x04 %s", adminek, misja, nick)
	}
	if(item == 2)
	{
		exp_set_user_mission(id_am, 0, 0)
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Admin^x04 %s^x01 Anulowal Misje^x04 %s^x01 graczowi^x04 %s", adminek, misja, nick)
	}
	if(item == 3)
	{
		exp_set_mission_status(id_am, id_misji, 1)
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Admin^x04 %s^x01 Zablokowal Misje^x04 %s^x01 graczowi^x04 %s", adminek, misja, nick)
	}
	if(item == 4)
	{
		exp_set_mission_status(id_am, id_misji, 1)
		exp_set_user_mission(id_am, 0, 0)
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Admin^x04 %s^x01 Anulowal I Zablokowal Misje^x04 %s^x01 graczowi^x04 %s", adminek, misja, nick)
	}
	return PLUGIN_CONTINUE
}
public MenuAdminDodajPoziom(id)
{
	get_user_name(id, adminek, 32)
	client_cmd(id, "messagemode dodaj_lvl");
}

public dodaj_lvl()
{
	new gracz[33]
	get_user_name(id_am, gracz, 32)
	
	new liczba_lvl[10]
	read_args(liczba_lvl, 9)
	remove_quotes(liczba_lvl)
	
	
	if(str_to_num(liczba_lvl) > 200) 
	{
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Wprowadzono za duza wartosc!")
		return PLUGIN_CONTINUE
	}
	if(str_to_num(liczba_lvl) < 1) 
	{
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Wprowadzono za mala wartosc!")
		return PLUGIN_CONTINUE
	}
	
	poziom_gracza[id_am] += str_to_num(liczba_lvl)
	
	doswiadczenie_gracza[id_am] = POZIOM[poziom_gracza[id_am]]
	
	Zresetuj(id_am, 1, 1, 1)
	SprawdzExp(id_am)
	
	if(str_to_num(liczba_lvl) == 1)
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 dodal^x04 %d^x03 poziom^x01 graczowi ^x04%s", adminek, str_to_num(liczba_lvl), gracz)
	else if(str_to_num(liczba_lvl) > 1 && str_to_num(liczba_lvl) < 5)
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 dodal^x04 %d^x03 poziomy^x01 graczowi ^x04%s", adminek, str_to_num(liczba_lvl), gracz)
	else
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 dodal^x04 %d^x03 poziomow^x01 graczowi ^x04%s", adminek, str_to_num(liczba_lvl), gracz)
	
	return PLUGIN_CONTINUE
}

public MenuAdminDodajExp(id)
{
	get_user_name(id, adminek, 32)
	console_cmd(id, "messagemode dodaj_exp");
}

public dodaj_exp()
{
	new gracz[33]
	get_user_name(id_am, gracz, 32)
	
	new liczba_exp[10]
	read_args(liczba_exp, 9)
	remove_quotes(liczba_exp)
	
	if(doswiadczenie_gracza[id_am]+str_to_num(liczba_exp) > POZIOM[199])
	{
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Wprowadzono za duzo wartosc!")
		return PLUGIN_CONTINUE
	}
	else if(str_to_num(liczba_exp) <= 0)
	{
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Wprowadzono za malo wartosc!")
		return PLUGIN_CONTINUE
	}
		
	doswiadczenie_gracza[id_am] += str_to_num(liczba_exp)
	
	Zresetuj(id_am, 1, 1, 1)
	SprawdzExp(id_am)
	
	if(str_to_num(liczba_exp) == 1)
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 dodal ^x04%d^x03 exp ^x01graczowi ^x04%s", adminek, str_to_num(liczba_exp), gracz)
	else
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 dodal ^x04%d^x03 expa ^x01graczowi ^x04%s", adminek, str_to_num(liczba_exp), gracz)
	
	return PLUGIN_CONTINUE
}
public MenuAdminDodajMonety(id)
{
	get_user_name(id, adminek, 32)
	console_cmd(id, "messagemode dodaj_monety");
}

public dodaj_monety()
{
	new gracz[33]
	get_user_name(id_am, gracz, 32)
	
	new liczba_monet[10]
	read_args(liczba_monet, 9)
	remove_quotes(liczba_monet)
	
	if(str_to_num(liczba_monet) < 0)
	{
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Wprowadzono za mala wartosc!")
		return PLUGIN_CONTINUE
	}
	
	monety_gracza[id_am] += str_to_num(liczba_monet)
	
	SprawdzExp(id_am)
	
	if(str_to_num(liczba_monet) == 1)
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 dodal ^x04%d^x03 monete ^x01graczowi ^x04%s", adminek, str_to_num(liczba_monet), gracz)
	else if(str_to_num(liczba_monet) > 1 && str_to_num(liczba_monet) < 5)
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 dodal ^x04%d^x03 monety ^x01graczowi ^x04%s", adminek, str_to_num(liczba_monet), gracz)
	else
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 dodal ^x04%d^x03 monet ^x01graczowi ^x04%s", adminek, str_to_num(liczba_monet), gracz)
	
	return PLUGIN_CONTINUE
}

public MenuAdminUstawMonety(id)
{
	get_user_name(id, adminek, 32)
	console_cmd(id, "messagemode ustaw_monety");
}
public ustaw_monety()
{
	new gracz[33]
	get_user_name(id_am, gracz, 32)
	
	new liczba_monet[10]
	read_args(liczba_monet, 9)
	remove_quotes(liczba_monet)
	
	if(str_to_num(liczba_monet) < 0)
	{
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Wprowadzono za mala wartosc!")
		return PLUGIN_CONTINUE
	}
	
	monety_gracza[id_am] = str_to_num(liczba_monet)
	
	if(str_to_num(liczba_monet) == 1)
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 ustawil^x04 %d^x03 monete^x01 graczowi ^x04%s", adminek, str_to_num(liczba_monet), gracz)
	else
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 ustawil^x04 %d^x03 monet^x01 graczowi ^x04%s", adminek, str_to_num(liczba_monet), gracz)
	
	return PLUGIN_CONTINUE
}

public MenuAdminUstawExp(id)
{
	get_user_name(id, adminek, 32)
	console_cmd(id, "messagemode ustaw_exp");
}

public ustaw_exp()
{
	new gracz[33]
	get_user_name(id_am, gracz, 32)
	
	new liczba_exp[15]
	read_args(liczba_exp, 14)
	remove_quotes(liczba_exp)
	
	if(str_to_num(liczba_exp) > POZIOM[199]) 
	{
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Wprowadzono za duza wartosc!")
		return PLUGIN_CONTINUE
	}
	if(str_to_num(liczba_exp) < 1) 
	{
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Wprowadzono za mala wartosc!")
		return PLUGIN_CONTINUE
	}
	
	doswiadczenie_gracza[id_am] = str_to_num(liczba_exp)
	
	Zresetuj(id_am, 1, 1, 1)
	if(str_to_num(liczba_exp) == 1)
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 ustawil^x04 %d^x03 exp^x01 graczowi ^x04%s", adminek, str_to_num(liczba_exp), gracz)
	else
		ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 ustawil^x04 %d^x03 expa^x01 graczowi ^x04%s", adminek, str_to_num(liczba_exp), gracz)
	
	SprawdzExp(id_am)
	return PLUGIN_CONTINUE
}
public MenuAdminUstawPoziom(id)
{

	get_user_name(id, adminek, 32)
	console_cmd(id, "messagemode ustaw_lvl");

}
public ustaw_lvl()
{	
	new lvl[10]
	read_args(lvl, 9)
	remove_quotes(lvl)
	
	new gracz[33]
	get_user_name(id_am, gracz, 32)
	
	new str = str_to_num(lvl)
	
	if(str > 199) 
	{
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Wprowadzono za duza wartosc!")
		return PLUGIN_CONTINUE
	}
	if(str < 1) 
	{
		ColorChat(get_user_index(adminek), GREEN, "[EXPMOD]^x01 Wprowadzono za mala wartosc!")
		return PLUGIN_CONTINUE
	}
	poziom_gracza[id_am] = str_to_num(lvl)
	doswiadczenie_gracza[id_am] = POZIOM[poziom_gracza[id_am]]
	
	Zresetuj(id_am, 1, 1, 1)
	ColorChat(0, GREEN, "[EXPMOD]^x01 Admin^x04 %s^x03 ustawil^x04 %d^x03 poziom^x01 graczowi ^x04%s", adminek, str, gracz)
	
	return PLUGIN_CONTINUE
}
///////////////////////////////////////////////////////

public Zresetuj(index, punkty, upunkty, monety)
{
	if(punkty)
	{
		punkty_gracza[index] = poziom_gracza[index]*PUNKTY_ZA_LEVEL
		
		zycie_gracza[index] = 0
		nowe_zycie_gracza[index] = 0
		
		szybkosc_gracza[index] = 0
		nowa_szybkosc_gracza[index] = 0.0
		
		grawitacja_gracza[index] = 0
		nowa_grawitacja_gracza[index] = 0.0
		
		kasa_gracza[index] = 0
		nowa_kasa_gracza[index] = 0
	}
	if(upunkty)
	{
		ultra_punkty_gracza[index] = floatround(float(poziom_gracza[index]/10), floatround_floor)
		niewidzialnosc_gracza[index] = 0
		nowa_niewidzialnosc_gracza[index] = 0
		
		obrazenia_gracza[index] = 0
		nowe_obrazenia_gracza[index] = 0
		
		skoki_gracza[index] = 0
		nowe_skoki_gracza[index] = 0
		
		longjump_gracza[index] = 0
		nowy_longujmp_gracza[index] = 0
		longjump_s_czas[index] = 0
	}
	if(monety)
		monety_gracza[index] = 0
}

public DeathMsg()
{
	new atakujacy = read_data(1);
	new obronca = read_data(2);
	new hs = read_data(3)
	new czy[33]
	if(!is_user_connected(atakujacy) || !is_user_connected(obronca))
		return PLUGIN_CONTINUE
	if(atakujacy != obronca && is_user_connected(atakujacy) && get_user_team(atakujacy) != get_user_team(obronca))
	{
		if(hs > 0)
		{
			czy[atakujacy]++
		}
		
		///////////////////////PO HEADSHOCIE////////////////////////
		
		if(czy[atakujacy] != 1)
		{
			if(get_user_flags(atakujacy) & VIP_FLAG)
			{
				doswiadczenie_gracza[atakujacy]+=get_pcvar_num(p_exp_zabojstwo)+get_pcvar_num(p_exp_vip_extra_exp)
				
				set_hudmessage(255, 255, 255, -1.0, 0.62, 0, 6.0, 2.0)
				show_hudmessage(atakujacy,  "+%d exp", get_pcvar_num(p_exp_zabojstwo)+get_pcvar_num(p_exp_vip_extra_exp))
			}
			else
			{
				doswiadczenie_gracza[atakujacy]+=get_pcvar_num(p_exp_zabojstwo)
				set_hudmessage(255, 255, 255, -1.0, 0.62, 0, 6.0, 2.0)
				show_hudmessage(atakujacy,  "+%d exp", get_pcvar_num(p_exp_zabojstwo))
			}
			
			//if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
			//tutorMake(atakujacy, TUTOR_RED, 1.5, "Zabiles wroga")
			
		}
		else if(czy[atakujacy] == 1)
		{
			if(get_user_flags(atakujacy) & VIP_FLAG)
			{
				set_hudmessage(255, 255, 255, -1.0, 0.62, 0, 6.0, 2.0)
				show_hudmessage(atakujacy,  "+%d exp^nHEADSHOT", get_pcvar_num(p_exp_zabojstwo)+get_pcvar_num(p_exp_headshot)+get_pcvar_num(p_exp_vip_extra_hs_exp))
				
				doswiadczenie_gracza[atakujacy]+=(get_pcvar_num(p_exp_zabojstwo)+get_pcvar_num(p_exp_headshot)+get_pcvar_num(p_exp_vip_extra_hs_exp))
			}
			else
			{
				set_hudmessage(255, 255, 255, -1.0, 0.62, 0, 6.0, 2.0)
				show_hudmessage(atakujacy,  "+%d exp^nHEADSHOT", get_pcvar_num(p_exp_zabojstwo)+get_pcvar_num(p_exp_headshot))
				doswiadczenie_gracza[atakujacy]+=(get_pcvar_num(p_exp_zabojstwo)+get_pcvar_num(p_exp_headshot))
			}
			
			czy[atakujacy] = 0
			
			//if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
			//tutorMake(atakujacy, TUTOR_RED, 1.5, "Zabiles wroga Headshotem")
		}
		
		if(get_user_flags(atakujacy) & VIP_FLAG)
			monety_gracza[atakujacy]+=(1+get_pcvar_num(p_exp_vip_extra_monets))
		else
			monety_gracza[atakujacy]++
		
		SprawdzExp(atakujacy)
		ZapiszExp(atakujacy)
		
		if(punkty_gracza[obronca] > 0 || ultra_punkty_gracza[obronca] > 0)
			MenuWybor(obronca)
		
		ZapiszExp(obronca)
	}
	return PLUGIN_CONTINUE
	
}

///////////////////////////////////////////////////////

public ZapiszExp(id)
{
	get_user_name(id, nazwa_gracza, 32)
	new dane[256]
	formatex(dane, 255, "%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#", doswiadczenie_gracza[id], poziom_gracza[id], punkty_gracza[id],
	ultra_punkty_gracza[id], zycie_gracza[id], nowe_zycie_gracza[id], niewidzialnosc_gracza[id], nowa_niewidzialnosc_gracza[id], obrazenia_gracza[id],
	nowe_obrazenia_gracza[id], szybkosc_gracza[id], floatround(nowa_szybkosc_gracza[id]), grawitacja_gracza[id], floatround(nowa_grawitacja_gracza[id]),
	kasa_gracza[id], nowa_kasa_gracza[id], skoki_gracza[id], nowe_skoki_gracza[id], longjump_gracza[id], nowy_longujmp_gracza[id], longjump_s_czas[id], monety_gracza[id])
	
	ZapiszDane(plik, nazwa_gracza, dane)
}


///////////////////////////////////////////////////////

public WczytajExp(id)
{
	get_user_name(id, nazwa_gracza, 32)
	new dane[512]
	
	WczytajDane(plik, nazwa_gracza, dane, 511)
	
	replace_all(dane, 255, "#", " ")
	
	new dg[16], pg[16], pkt[16], upkt[16], hp[16], nhp[16], ng[16], 
	nng[16], og[16], nog[16], sg[16], nsg[16], gg[16], ngg[16], kg[16], 
	nkg[16], skokig[16], noweskg[16], lg[16], nlg[16], lgsc[16], mg[16]
	
	parse(dane, dg, 15, pg, 15, pkt, 15, upkt, 15, hp, 15, nhp, 15, ng, 15, nng, 15, og, 15, 
	nog, 15, sg, 15, nsg, 15, gg, 15, ngg, 15, kg , 15, nkg, 15, skokig, 15, noweskg, 15, lg,
	15, nlg, 15, lgsc, 15, mg, 15)
	
	doswiadczenie_gracza[id] = str_to_num(dg)
	poziom_gracza[id] = str_to_num(pg)
	
	punkty_gracza[id] = str_to_num(pkt)
	ultra_punkty_gracza[id] = str_to_num(upkt)
	
	monety_gracza[id] = str_to_num(mg)
	
	zycie_gracza[id] = str_to_num(hp)
	nowe_zycie_gracza[id] = str_to_num(nhp)
	
	niewidzialnosc_gracza[id] = str_to_num(ng)
	nowa_niewidzialnosc_gracza[id] = str_to_num(nng)
	
	obrazenia_gracza[id] = str_to_num(og)
	nowe_obrazenia_gracza[id] = str_to_num(nog)
	
	szybkosc_gracza[id] = str_to_num(sg)
	nowa_szybkosc_gracza[id] = float(str_to_num(nsg))
	
	grawitacja_gracza[id] = str_to_num(gg)
	nowa_grawitacja_gracza[id] = float(str_to_num(ngg))
	
	kasa_gracza[id] = str_to_num(kg)
	nowa_kasa_gracza[id] = str_to_num(nkg)
	
	skoki_gracza[id] = str_to_num(skokig)
	nowe_skoki_gracza[id] = str_to_num(noweskg)
	
	longjump_gracza[id] = str_to_num(lg)
	nowy_longujmp_gracza[id] = str_to_num(nlg)
	longjump_s_czas[id] = str_to_num(lgsc)
}

///////////////////////////////////////////////////////

public SprawdzExp(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE
	while(doswiadczenie_gracza[id] >= POZIOM[poziom_gracza[id]+1])
	{
		punkty_gracza[id]+=PUNKTY_ZA_LEVEL
		poziom_gracza[id]++
		if(get_user_flags(id) & VIP_FLAG)
			monety_gracza[id]+= (1+get_pcvar_num(p_exp_vip_extra_monets))
		else 
			monety_gracza[id]++
		
		switch(random_num(1,2))
		{
			case 1: client_cmd(id, "spk %s", level_up);
				case 2: client_cmd(id, "spk %s", level_up2);
			}
		
		set_hudmessage(255, 255, 255, -1.0, 0.4, 0, 6.0, 2.0)
		ShowSyncHudMsg(id, Message2,  "Awansowales do %d poziomu", get_user_level(id))
		
		if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
		{
			ColorChat(id, GREEN, "[EXPMOD]^x01 Awansowales do^x04 %d^x01 poziomu.", get_user_level(id))
			ColorChat(id, GREEN, "[EXPMOD]^x01 Dostales dodatkowa^x04 1^x01 monete za wbicie poziomu.")
		}
		
		if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
		{
			if(get_pcvar_num(p_exp_tutor_sound) == 1)
			{
				switch(random_num(1,2))
				{
					case 1: client_cmd(id, "spk %s", komunikat1)
						case 2: client_cmd(id, "spk %s", komunikat2)
					}
			}
			tutorMake(id, TUTOR_YELLOW, 5.0, "Awansowales do poziomu %d^nOtrzymujesz dodatkowo 1 monete", poziom_gracza[id])
		}
		if((get_user_level(id) % 10) == 0)
			ultra_punkty_gracza[id]++
		
		get_user_name(id, nazwa_gracza, 32)
		if((poziom_gracza[id] % 50) == 0)
		{
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
				ColorChat(id, GREEN, "[EXPMOD]^x01 Gracz ^x04%s^x01 awansowal do poziomu ^x04%d - Gratulujemy!", nazwa_gracza, poziom_gracza[id])
			
			if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				if(get_pcvar_num(p_exp_tutor_sound) == 1)
				{
					switch(random_num(1,2))
					{
						case 1: client_cmd(id, "spk %s", komunikat1)
							case 2: client_cmd(id, "spk %s", komunikat2)
						}
				}
				tutorMake(0, TUTOR_YELLOW, 5.0, "Gracz %s awansowal do poziomu %d^nGratulujemy!", nazwa_gracza, poziom_gracza[id])
			}
		}
		
		if(is_user_bot(id) && get_pcvar_num(p_exp_boty) == 1)
			client_cmd(id, "say /przydziel")
		
		MenuWybor(id)
		ZapiszExp(id)
	}
	return PLUGIN_CONTINUE
}

///////////////////////////////////////////////////////

public Pokaz(id)
{
	
	for(new i = 1 ; i < 33 ; i++)
	{
		
		if(!is_user_alive(i) && is_user_connected(i) && !is_user_bot(i))
		{
			new cel = entity_get_int(i, EV_INT_iuser2)
			
			if(!cel)
				return PLUGIN_CONTINUE
			
			new ileMa2 = doswiadczenie_gracza[cel]
			new ilePotrzeba2 = POZIOM[poziom_gracza[cel]+1]
			new ilePotrzebaBylo2
			if(poziom_gracza[cel] > 0)
				ilePotrzebaBylo2 = get_user_previouslevelexp(cel)
			else if(poziom_gracza[cel] <= 0)
				ilePotrzebaBylo2 = 0
				
			new Float:dos_cel = 0.0
			
			dos_cel = (float((ileMa2 - ilePotrzebaBylo2)) / float((ilePotrzeba2 - ilePotrzebaBylo2))) * 100.0;
			
			set_hudmessage(255, 255, 255, 0.56, 0.62, 0, 6.0, 0.5)
			ShowSyncHudMsg(i, Message4, "EXP : %i / %i | %0.1f%%^nPoziom : %i  ^nZdrowie : %i", doswiadczenie_gracza[cel], POZIOM[poziom_gracza[cel]+1], dos_cel, poziom_gracza[cel], get_user_health(cel))
			
			set_hudmessage(127, 40, 255, 0.70, 0.81, 0, 6.0, 0.5)
			ShowSyncHudMsg(i, Message3, "^n%d -> %d <- %d^n", poziom_gracza[cel]-1, poziom_gracza[cel], poziom_gracza[cel]+1)
			
		}
		else if(is_user_alive(i) && is_user_connected(i) && !is_user_bot(i))
		{
			new ileMa3 = doswiadczenie_gracza[i]
			new ilePotrzeba3 = POZIOM[poziom_gracza[i]+1]
			new ilePotrzebaBylo3
			
			if(poziom_gracza[i] > 0)
				ilePotrzebaBylo3 = POZIOM[poziom_gracza[i]-1]
			else if(poziom_gracza[i] <= 0)
				ilePotrzebaBylo3 = 0
				
			new Float:dos = 0.0
			
			dos = (float((ileMa3 - ilePotrzebaBylo3)) / float((ilePotrzeba3 - ilePotrzebaBylo3))) * 100.0;
			
			set_hudmessage(255, 255, 56, 0.0, 0.18, 0, 6.0, 0.5)
			ShowSyncHudMsg(i, Message4, "[EXP : %i / %i | %0.1f%%]^n[Poziom : %i]^n[Zdrowie : %i]^n[Monety : %i]", doswiadczenie_gracza[i], POZIOM[poziom_gracza[i]+1], dos,  poziom_gracza[i], get_user_health(i), monety_gracza[i])
			
			set_hudmessage(127, 40, 255, -1.0, 0.01, 0, 6.0, 0.5)
			ShowSyncHudMsg(i, Message3, "^n%d -> %d <- %d^n", poziom_gracza[i]-1, poziom_gracza[i], poziom_gracza[i]+1)
			
		}
	}
	return PLUGIN_CONTINUE
}


///////////////////////////////////////////////////////

public bomb_planted(podkladajacy)
{
	if(!is_user_alive(podkladajacy) || !is_user_connected(podkladajacy))
		return PLUGIN_CONTINUE
	
	if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
		ColorChat(podkladajacy, GREEN, "[EXPMOD]^x01 Dostales^x04 %d^x01 expa za podlozenie bomby", get_pcvar_num(p_exp_podlozenie_paki))
	
	if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
		tutorMake(podkladajacy, TUTOR_GREEN, 5.0, "Dostales %d expa za podlozenie bomby", get_pcvar_num(p_exp_podlozenie_paki))
	
	if(get_user_flags(podkladajacy) & VIP_FLAG)
		doswiadczenie_gracza[podkladajacy]+=get_pcvar_num(p_exp_podlozenie_paki)+get_pcvar_num(p_exp_vip_extra_exp)
	else
		doswiadczenie_gracza[podkladajacy]+=get_pcvar_num(p_exp_podlozenie_paki)
	
	
	return PLUGIN_CONTINUE
}

///////////////////////////////////////////////////////

public bomb_defused(rozbrajajacy)
{
	if(!is_user_alive(rozbrajajacy) || !is_user_connected(rozbrajajacy))
		return PLUGIN_CONTINUE

	if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
		ColorChat(rozbrajajacy, GREEN, "[EXPMOD]^x01 Dostales^x04 %d^x01 expa za rozbrojenie bomby", get_pcvar_num(p_exp_rozbrojenie_paki))
	
	if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
	{
		if(get_pcvar_num(p_exp_tutor_sound) == 1)
		{
			switch(random_num(1,2))
			{
				case 1: client_cmd(rozbrajajacy, "spk %s", komunikat1)
					case 2: client_cmd(rozbrajajacy, "spk %s", komunikat2)
				}
		}
		tutorMake(rozbrajajacy, TUTOR_GREEN, 5.0, "Dostales %d expa za rozbrojenie bomby", get_pcvar_num(p_exp_rozbrojenie_paki))
	}
	if(get_user_flags(rozbrajajacy) & VIP_FLAG)
		doswiadczenie_gracza[rozbrajajacy]+=get_pcvar_num(p_exp_rozbrojenie_paki)+get_pcvar_num(p_exp_vip_extra_exp)
	else
		doswiadczenie_gracza[rozbrajajacy]+=get_pcvar_num(p_exp_rozbrojenie_paki)
	return PLUGIN_CONTINUE
}
public UratowanieHosta()
{

	new id = get_loguser_index()
	
	if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
		ColorChat(id, GREEN, "[EXPMOD]^x01 Dostales^x04 %d^x01 expa za uratowanie hosta", get_pcvar_num(p_exp_uratowanie_hosta))
		
	if(get_user_flags(id) & VIP_FLAG)
		set_user_exp(id, get_user_exp(id)+get_pcvar_num(p_exp_uratowanie_hosta)+get_pcvar_num(p_exp_vip_extra_exp))
	else
		set_user_exp(id, get_user_exp(id)+get_pcvar_num(p_exp_uratowanie_hosta)	)
			
	if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
	{
		if(get_pcvar_num(p_exp_tutor_sound) == 1)
		{
			switch(random_num(1,2))
			{
				case 1: client_cmd(id, "spk %s", komunikat1)
					case 2: client_cmd(id, "spk %s", komunikat2)
				}
		}
		tutorMake(id, TUTOR_GREEN, 5.0, "Dostales %d expa za uratowanie hosta", get_pcvar_num(p_exp_uratowanie_hosta))
	}
	
}
///////////////////////////////////////////////////////

public messageScoreAttrib(iMsgID, iDest, iReceiver) 
{   
	new iPlayer = get_msg_arg_int(1);
	
	if(is_user_connected(iPlayer) && (get_user_flags(iPlayer) & VIP_FLAG))   
		set_msg_arg_int(2, ARG_BYTE, is_user_alive(iPlayer) ? SCOREATTRIB_VIP : SCOREATTRIB_DEAD);
}

///////////////////////////////////////////////////////
///////////////////////NATYWY//////////////////////////
///////////////////////////////////////////////////////

public get_user_level(index)
{
	if(poziom_gracza[index]-1 < 0)
		return 0
	
	return poziom_gracza[index]
}
public get_levelexp(level)
	return POZIOM[level]
public get_user_exp(index)
	return doswiadczenie_gracza[index]

public get_user_nextlevelexp(index)
	return POZIOM[poziom_gracza[index]+1]

public get_user_previouslevelexp(index)
{
	if(poziom_gracza[index]-1  < 0)
		return 0
	return POZIOM[poziom_gracza[index]-1]
}

public set_user_level(index, level)
	poziom_gracza[index] = level


public set_user_exp(index, exp)
	doswiadczenie_gracza[index] = exp

///////////////////////////////////////////////////////

public set_user_invisible(index, value)
	set_user_rendering(index, kRenderFxGlowShell, 0, 0, 0, kRenderTransAlpha, value)

public get_user_monets(index)
	return monety_gracza[index]

public get_user_new_health(index)
	return nowe_zycie_gracza[index]

//public get_user_new_speed(index)
//return nowa_szybkosc_gracza[index]

//public get_user_new_gravity(index)
//return nowa_grawitacja_gracza[index]

//public get_user_new_cash(index)
//return nowa_kasa_gracza[index]

public set_user_monets(index, ammount)
	return monety_gracza[index] = ammount

stock get_loguser_index() 
{
	new loguser[80], name[32]
	read_logargv(0, loguser, 79)
	parse_loguser(loguser, name, 31)
	
	return get_user_index(name)
}

public is_user_vip(index)
{
	if(get_user_flags(index) & VIP_FLAG)
		return 1;
	
	return 0
}
