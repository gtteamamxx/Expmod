///////////////////////////////////////////////////////////////

#include <amxmodx>
#include <amxmisc>
#include <expmod>
#include <fun>
#include <cstrike>
#include <tutor>
#include <engine>
#include <csx>
#include <expmod_shop>
#include <nvault>
#include <hamsandwich>
#include <fakemeta>
#include <ColorChat>

#define PLUGIN "ExpMod Achievements"
#define VERSION "1.0"
#define AUTHOR "tomcionek15 & grs4"

///////////////////////////////////////////////////////////////

new plik_achI
new plik_achII
new plik_achIII;
new opis_achitem[33]
///////////////////////////////////////////////////////////////
new p_exp_tutor_sound
new p_exp_infostyle
/*
	p_exp_infostyle 	= 0 	// NIC
	p_exp_infostyle 	= 1 	// TUTOR
	p_exp_infostyle 	= 2 	// COLORCHAT
	p_exp_infostyle 	= 3 	// TUTOR + COLORCHAT
*/
new zabil_wroga[33] = 0;
new nazwa_gracza[33]

///////////////////////////////////////////////////////////////

new NazwyAchiI[][] = 
{
	"Mistrz Pistoletow I",		 //0
	"Mistrz Szotganow I", 		 //1
	"Mistrz SMG I", 			 //2
	"Mistrz Rifle I",		 //3
	"KrowoManiak I", 		 //4
	"Bomberman I", 			 //5
	"Saper I", 			 //6
	"Snajper I",			 //7
	"Nozownik I", 			 //8
	"HeadShot I", 			 //9
	"Strzelanie kleczac I", 	 	 //10
	"Killer I",			 //11
	"Strzelanie w powietrzu I",	 //12
	"Nalogowiec I"			 //13
}

new NazwyAchiII[][] =
{
	"Mistrz Pistoletow II",		 //0
	"Mistrz Szotganow II",		 //1 
	"Mistrz SMG II", 		 //2
	"Mistrz Rifle II", 		 //3
	"KrowoManiak II",		 //4 
	"Bomberman II",			 //5
	"Saper II",			 //6
	"Snajper II", 			 //7
	"Nozownik II",			 //8
	"HeadShot II",			 //9
	"Strzelanie kleczac II", 	 //10
	"Killer II",			 //11
	"Strzelanie w powietrzu II",	 //12
	"Nalogowiec II"			 //13
	
}
new NazwyAchiIII[][] = 
{
	"Mistrz Pistoletow III", 	 //0
	"Mistrz Szotganow III",		 //1
	"Mistrz SMG III",		 //2
	"Mistrz Rifle III",		 //3
	"KrowoManiak III",		 //4
	"Bomberman III",		 //5
	"Saper III",			 //6
	"Snajper III",			 //7
	"Nozownik III",			 //8
	"HeadShot III",			 //9
	"Strzelanie kleczac III", 	 //10
	"Killer III",			 //11
	"Strzelanie w powietrzu III",	 //12
	"Nalogowiec III"		 //13
	
}

///////////////////////////////////////////////////////////////

new OpisyAchiI[][] =
{
	"Zabij z pistoleta 150 wrogow",  //0
	"Zabij z szotgana 210 wrogow", 	 //1
	"Zabij z SMG 250 wrogow", 	 //2
	"Zabij z Rifle 300 wrogow", 	 //3
	"Zabij z M249 250 wrogow",  	 //4
	"Podloz 20 bomb",		 //5
	"Rozbroj 20 bomb",		 //6
	"Zabij 150 wrogow ze snajperki", //7
	"Zabij 120 wrogow z noza",	 //8
	"Zabij headshotem 300 wrogow",	 //9
	"Zabij kleczac 200 wrogow",	 //10
	"Zabij 500 wrogow",		 //11
	"Zabij w powietrzu 25 wrogow",	 //12
	"Zadaj w sumie 30tys. obrazen"	 //13
}

new OpisyAchiII[][] =
{
	"Zabij z pistoleta 400 wrogow",	 //0
	"Zabij z szotgana 500 wrogow",	 //1
	"Zabij z SMG 620 wrogow",	 //2
	"Zabij z Rifle 800 wrogow",	 //3
	"Zabij z M249 550 wrogow",	 //4
	"Podloz 45 bomb",		 //5
	"Rozbroj 45 bomb",		 //6
	"Zabij 350 wrogow ze snajperki", //7
	"Zabij 350 wrogow z noza",	 //8
	"Zaboj heashotem 650 wrogow",	 //9
	"Zabij kleczac 500 wrogow", 	 //10
	"Zabij 1200 wrogow",		 //11
	"Zabij w powietrzu 60 wrogow",	 //12
	"Zadaj w sumie 120tys. obrazen"	 //13
}

new OpisyAchiIII[][] = 
{
	"Zabij z pistoleta 900 wrogow",	 //0
	"Zabij z szotgana 900 wrogow",	 //1
	"Zabij z SMG 1000 wrogow",	 //2
	"Zabij z Rifle 1300 wrogow",	 //3
	"Zabij z M249 1000 wrogow",	 //4
	"Podloz 100 bomb",		 //5
	"Rozbroj 100 bomb",  		 //6
	"Zabij 600 wrogow ze snajperki", //7
	"Zabij 500 wrogow z noza",	 //8
	"Zabij headshotem 1000 wrogow",	 //9
	"Zabij kleczac 900 wrogow",	 //10
	"Zabij 3000 wrogow",		 //11
	"Zabij w powietrzu 100 wrogow",	 //12
	"Zadaj w sumie 300tys. obrazen"	 //13

}

///////////////////////////////////////////////////////////////
	
new NagrodyAchiI[] =
{
	3000, 				//0
	4000,				//1
	4500, 				//2
	5500, 				//3 
	4500,  				//4
	5000, 				//5
	5000, 				//6
	5000, 				//7
	7500, 				//8
	7000, 				//9
	6500, 				//10
	8000,				//11
	9000,				//12
	10000				//12
	
}
new NagrodyAchiII[] =
{
	6000, 				//0
	8000, 				//1
	9000, 				//2
	11000, 				//3
	9000, 				//4
	10000, 				//5
	10000, 				//6
	10000, 				//7
	15000, 				//8
	14000, 				//9
	13000, 				//10
	16000,				//11
	18000,				//12
	20000				//13
}

new NagrodyAchiIII[] = 
{
	9000, 				//0
	12000, 				//1
	13500, 				//2
	16500, 				//3
	13500, 				//4
	15000, 				//5
	15000, 				//6
	15000, 				//7
	22500, 				//8
	21000, 				//9
	18500, 				//10
	24000,				//11
	27000,				//12
	30000				//13
	
}

///////////////////////////////////////////////////////////////

new WymaganeLevelI[] =
{
	3, 				//0
	7, 				//1
	10, 				//2
	15, 				//3
	21, 				//4
	5, 				//5
	5, 				//6
	19, 				//7
	0, 				//8
	5, 				//9
	2,				//10
	0,				//11
	6,				//12
	0				//13
}
new WymaganeLevelII[] =
{
	20, 				//0
	26, 				//1
	33, 				//2
	47, 				//3
	51, 				//4
	20, 				//5
	20, 				//6
	49, 				//7
	16, 				//8
	40, 				//9
	50,				//10
	50,				//11
	40,				//12
	50				//13
}

new WymaganeLevelIII[] = 
{
	47, 				//0
	58, 				//1
	62, 				//2
	84, 				//3
	103, 				//4
	40, 				//5
	40, 				//6
	98, 				//7
	49, 				//8
	100, 				//9
	110,				//10
	120,				//11
	100,				//12
	148				//13
}

///////////////////////////////////////////////////////////////

new PotrzebyAchI[] =
{
	150,  				//0
	210, 				//1
	150,  				//2
	300, 				//3
	150,  				//4
	20,  				//5
	20, 				//6
	150, 				//7
	120, 				//8
	300, 				//9
	200,				//10
	500,				//11
	25,				//12
	30000				//13
}
new PotrzebyAchII[] =
{
	400, 				//0
	500, 				//1
	620, 				//2
	800, 				//3
	550, 				//4
	45, 				//5
	45, 				//6
	350, 				//7
	350, 				//8
	650, 				//9
	500, 				//10
	1200,				//11
	60,				//12
	120000				//13
}
new PotrzebyAchIII[] =
{
	900, 				//0
	900, 				//1
	1000, 				//2
	1300, 				//3
	1000, 				//4
	100, 				//5
	100, 				//6
	600, 				//7
	500, 				//8
	100, 				//9
	900, 				//10
	3000,				//11
	100,				//12
	300000				//13
}

///////////////////////////////////////////////////////////////

/*
	Statusy 
	0 = Zablokowany
	1 = Odblokowany
	2 = Ukonczony
*/

///////////////////////////////////////////////////////////////

new status_achI[33][sizeof NazwyAchiI]
new status_achII[33][sizeof NazwyAchiII]
new status_achIII[33][sizeof NazwyAchiIII]

new postep_achI[33][sizeof NazwyAchiI]
new postep_achII[33][sizeof NazwyAchiII]
new postep_achIII[33][sizeof NazwyAchiIII]

new liczba_ach = sizeof NazwyAchiI

///////////////////////////////////////////////////////////////

new ach_unlock1[]	= "sound/ExpMod/ach_unlock.wav"
new ach_unlock2[]	= "sound/ExpMod/ach_unlock1.wav"
new menu_on[] 	= "sound/ExpMod/menu_on.wav"
new klik1[]	= "sound/ExpMod/klik.wav"
new klik2[]	= "sound/ExpMod/klik2.wav"
new komunikat1[]= "sound/ExpMod/komunikat1.wav"
new komunikat2[]= "sound/ExpMod/komunikat2.wav"
new wyzwanie[]	= "sound/ExpMod/wyzwanie.wav"

public plugin_natives()
{
	register_native("exp_show_ach_menu", "WyborAchi", 1)
	register_native("exp_show_ach_menu_desc", "MenuOpisAchi", 1)
}

public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	tutorInit()
	
	register_event("DeathMsg", 		"DeathMsg", 	"a"	);
	register_event("Damage",	             "Damage",	"b","2!=0"   );
	
	register_clcmd("say /ach", 		"WyborAchi"		);
	register_clcmd("say /achievements", 	"WyborAchi"		);
	register_clcmd("say /achievement", 	"WyborAchi"		);
	register_clcmd("say /osiagniecia",	"WyborAchi"		);
	register_clcmd("say /opisach",		"MenuOpisAchi"		);
	
	
	p_exp_tutor_sound = 	register_cvar("exp_tutor_sounds", "1"	);
	p_exp_infostyle = 	register_cvar("exp_infostyle", 	"3"	);
	plik_achI 	= 	nvault_open(	"ExpMod_AchievementI"	);
	plik_achII 	= 	nvault_open(	"ExpMod_AchievementII"	);
	plik_achIII 	=	nvault_open(	"ExpMod_AchievementIII"	);
	
	register_forward(FM_CmdStart, 		"CmdStart"		);	
}

///////////////////////////////////////////////////////////////

public plugin_precache()
{
	tutorInit();
	
	precache_sound(ach_unlock1)
	precache_sound(ach_unlock2)
	precache_sound(menu_on)
	precache_sound(klik1)
	precache_sound(klik2)
	precache_sound(komunikat1)
	precache_sound(komunikat2)
	precache_sound(wyzwanie)
}

///////////////////////////////////////////////////////////////
	
public client_connect(id)
	WczytajWszystko(id);
	
public client_disconnect(id)
	ZapiszWszystko(id);

///////////////////////////////////////////////////////////////

public WyborAchi(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE;
		
	WczytajWszystko(id);
	client_cmd(id, "spk %s", menu_on)
	new opis[250];
	new menu = menu_create("Twoje Achievementy", "WyborAchi_Wybieranie");
	new menu_cb = menu_makecallback("WyborAchi_Cb");
	for(new i = 0 ; i < liczba_ach ; i++)
	{
		if(status_achI[id][i] == 0)
			formatex(opis, 249, "%s \r[Zablokowany]\y [%d lvl]", NazwyAchiI[i], WymaganeLevelI[i]);
		else if(status_achI[id][i] == 1)
			formatex(opis, 249, "%s \r[%d / %d]\y [%d exp]", NazwyAchiI[i], postep_achI[id][i], PotrzebyAchI[i], NagrodyAchiI[i]);
		else if(status_achI[id][i] == 2)
		{
			if(status_achII[id][i] == 0)
				formatex(opis, 249, "%s \r[Zablokowany]\y [%d lvl]", NazwyAchiII[i], WymaganeLevelII[i]);
			else if(status_achII[id][i] == 1)
				formatex(opis, 249, "%s \r[%d / %d]\y [%d exp]", NazwyAchiII[i], postep_achII[id][i], PotrzebyAchII[i], NagrodyAchiII[i]);
			else if(status_achII[id][i] == 2)
			{
				if(status_achIII[id][i] == 0)
					formatex(opis, 249, "%s \r[Zablokowany]\y [%d lvl]", NazwyAchiIII[i], WymaganeLevelIII[i]);
				else if(status_achIII[id][i] == 1)
					formatex(opis, 249, "%s \r[%d / %d]\y [%d exp]", NazwyAchiIII[i], postep_achIII[id][i], PotrzebyAchIII[i], NagrodyAchiIII[i]);
				else if(status_achIII[id][i] == 2)
					formatex(opis, 249, "%s \r[Ukonczony]", NazwyAchiIII[i])
			}
		}
		menu_additem(menu, opis, _, _, menu_cb);
	}
	
	menu_display(id, menu);
	
	return PLUGIN_CONTINUE;
}

public WyborAchi_Cb(id, menu, item)
	return ITEM_DISABLED;


public WyborAchi_Wybieranie(id, menu, item)
{
	if(item == MENU_EXIT || !is_user_connected(id))
	{
		menu_destroy(menu);
		return PLUGIN_CONTINUE;
	}
	return PLUGIN_CONTINUE;
}

///////////////////////////////////////////////////////////////

public SprawdzAch(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE;
	for(new i= 0; i < liczba_ach ; i++)
	{
		if(exp_get_user_level(id) >= WymaganeLevelI[i] && status_achI[id][i] == 0)
		{
				status_achI[id][i] = 1;
				switch(random_num(1,2))
				{
					case 1: client_cmd(id, "spk %s", ach_unlock1)
					case 2:	client_cmd(id, "spk %s", ach_unlock2)
				}
		}
		if(exp_get_user_level(id) >= WymaganeLevelII[i] && status_achII[id][i] == 0)
		{
				status_achII[id][i] = 1;
				switch(random_num(1,2))
				{
					case 1: client_cmd(id, "spk %s", ach_unlock1)
					case 2:	client_cmd(id, "spk %s", ach_unlock2)
				}
		}
				
		if(exp_get_user_level(id) >= WymaganeLevelIII[i] && status_achIII[id][i] == 0)
		{
				status_achIII[id][i] = 1;
				switch(random_num(1,2))
				{
					case 1: client_cmd(id, "spk %s", ach_unlock1)
					case 2:	client_cmd(id, "spk %s", ach_unlock2)
				}
		}
				
		if(postep_achI[id][i] >= PotrzebyAchI[i] && status_achI[id][i] == 1)
		{
			status_achI[id][i] = 2;
			postep_achII[id][i] = postep_achI[id][i];
		
			if(get_pcvar_num(p_exp_infostyle) == 1 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				tutorMake(id, TUTOR_GREEN, 5.0, "Achievmenty Poziom I^nZdobyles Osiagniecie %s^n%s^nNagroda : %d", NazwyAchiI[i],OpisyAchiI[i],NagrodyAchiI[i])
				if(get_pcvar_num(p_exp_tutor_sound) == 1)
				{
					switch(random_num(1,2))
					{
						case 1: client_cmd(id, "spk %s", komunikat1)
						case 2: client_cmd(id, "spk %s", komunikat2)
					}
				}
			}
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				ColorChat(id, GREEN, "[EXPMOD]^x01 Achievmenty Poziom^x04 I")
				ColorChat(id, GREEN, "[EXPMOD]^x01 Zdobyles Osiagniecie :^x04 %s", NazwyAchiI[i])
				ColorChat(id, GREEN, "[EXPMOD]^x01 %s", OpisyAchiI[i])
				ColorChat(id, GREEN, "[EXPMOD]^x01 Nagroda :^x04 %d", NagrodyAchiI[i])
			}
			client_cmd(id, "spk %s", wyzwanie)
			exp_set_user_exp(id, exp_get_user_exp(id)+NagrodyAchiI[i]);
			exp_checklevel(id);
		}
		if(postep_achII[id][i] >= PotrzebyAchII[i] && status_achI[id][i] == 2)
		{
			status_achII[id][i] = 2
			postep_achIII[id][i] = postep_achII[id][i]
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
				tutorMake(id, TUTOR_GREEN, 5.0, "Achievmenty Poziom II^nZdobyles Osiagniecie %s^n%s^nNagroda : %d", NazwyAchiII[i],OpisyAchiII[i],NagrodyAchiII[i])
			}
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				ColorChat(id, GREEN, "[EXPMOD]^x01 Achievmenty Poziom^x04 II")
				ColorChat(id, GREEN, "[EXPMOD]^x01 Zdobyles Osiagniecie :^x04 %s", NazwyAchiII[i])
				ColorChat(id, GREEN, "[EXPMOD]^x01 %s", OpisyAchiII[i])
				ColorChat(id, GREEN, "[EXPMOD]^x01 Nagroda :^x04 %d", NagrodyAchiII[i])
			}
			exp_set_user_exp(id, exp_get_user_exp(id)+NagrodyAchiII[i])
			exp_checklevel(id)
			client_cmd(id, "spk %s", wyzwanie)
		}
		if(postep_achIII[id][i] >= PotrzebyAchIII[i] && status_achII[id][i] == 2)
		{
			status_achIII[id][i] = 2
			postep_achIII[id][i] = 0
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
				tutorMake(id, TUTOR_GREEN, 5.0, "Achievmenty Poziom III^nZdobyles Osiagniecie %s^n%s^nNagroda : %d", NazwyAchiIII[i],OpisyAchiIII[i],NagrodyAchiIII[i])
			}
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				ColorChat(id, GREEN, "[EXPMOD]^x01 Achievmenty Poziom^x04 III")
				ColorChat(id, GREEN, "[EXPMOD]^x01 Zdobyles Osiagniecie :^x04 %s", NazwyAchiIII[i])
				ColorChat(id, GREEN, "[EXPMOD]^x01 %s", OpisyAchiIII[i])
				ColorChat(id, GREEN, "[EXPMOD]^x01 Nagroda :^x04 %d", NagrodyAchiIII[i])
			}
			
			client_cmd(id, "spk %s", wyzwanie)
			exp_set_user_exp(id, exp_get_user_exp(id)+NagrodyAchiIII[i])
			exp_checklevel(id)
		}
	}
	ZapiszWszystko(id)
	return PLUGIN_CONTINUE
}
public Damage(id)
{
	new atakujacy = get_user_attacker(id);
	new damage = read_data(2);
	if(!is_user_alive(atakujacy) || !is_user_connected(atakujacy))
		return PLUGIN_CONTINUE;
		
	if(get_user_team(id) != get_user_team(atakujacy))
	{
		if(status_achI[atakujacy][13] == 1)
			postep_achI[atakujacy][13]+=damage
			
		else if(status_achII[atakujacy][13] == 1)
			postep_achII[atakujacy][13]+=damage
			
		else if(status_achIII[atakujacy][13] == 1)
			postep_achIII[atakujacy][13]+=damage
		SprawdzAch(atakujacy)
	}
	
	return PLUGIN_CONTINUE
}
public MenuOpisAchi(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE;
		
	client_cmd(id, "spk %s", menu_on)
	
	new opis[256];
	
	new menu = menu_create("Wybierz Podzial: ", "MenuOpisAchi_Handler");
	for(new i = 0 ; i < sizeof NazwyAchiI ; i++)
	{
		formatex(opis, 255, "\y%s, \rII, \wIII", NazwyAchiI[i]);
		menu_additem(menu, opis);
	}
	menu_display(id, menu);
	return PLUGIN_CONTINUE;
}
public MenuOpisAchi_Handler(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	opis_achitem[id] = item
	new opis[128]
	new menu = menu_create("Co ?", "WybierzOpisAchi_Handler")
	for(new i = 0; i < 3;i++)
	{
		if(i == 0)
			formatex(opis, 127, "%s",NazwyAchiI[item])
		if(i == 1)
			formatex(opis, 127, "\y%s",NazwyAchiII[item])
		if(i == 2)
			formatex(opis, 127, "\r%s",NazwyAchiIII[item])
		menu_additem(menu, opis)
	}
	menu_additem(menu, "Wstecz")
	menu_display(id, menu)
	switch(random_num(1,2))
	{
		case 1:client_cmd(id, "spk %s", klik1)
		case 2:client_cmd(id, "spk %s", klik2)
	}
	return PLUGIN_CONTINUE
}
public WybierzOpisAchi_Handler(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	
	new opis[128]
	if(item == 0)
		formatex(opis, 127, "\yAchievement : \r%s^n\yZadanie : \r%s^n\yNagroda :\r %d\y expa^n\yWymagany Lvl : \r%d", NazwyAchiI[opis_achitem[id]], OpisyAchiI[opis_achitem[id]], NagrodyAchiI[opis_achitem[id]], WymaganeLevelI[opis_achitem[id]])
	if(item == 1)
		formatex(opis, 127, "\yAchievement : \r%s^n\yZadanie : \r%s^n\yNagroda :\r %d\y expa^n\yWymagany Lvl : \r%d", NazwyAchiII[opis_achitem[id]], OpisyAchiII[opis_achitem[id]], NagrodyAchiII[opis_achitem[id]], WymaganeLevelII[opis_achitem[id]])
	if(item == 2)
		formatex(opis, 127, "\yAchievement : \r%s^n\yZadanie : \r%s^n\yNagroda :\r %d\y expa^n\yWymagany Lvl : \r%d", NazwyAchiIII[opis_achitem[id]], OpisyAchiIII[opis_achitem[id]], NagrodyAchiIII[opis_achitem[id]], WymaganeLevelIII[opis_achitem[id]])
	if(item == 3)
		MenuOpisAchi(id)
	new menu = menu_create(opis, "WybierzOpisAch_Zakoncz")
	menu_additem(menu, "Wstecz")
	menu_display(id, menu)
	switch(random_num(1,2))
	{
		case 1:client_cmd(id, "spk %s", klik1)
		case 2:client_cmd(id, "spk %s", klik2)
	}
	return PLUGIN_CONTINUE
}
public WybierzOpisAch_Zakoncz(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	switch(random_num(1,2))
	{
		case 1:client_cmd(id, "spk %s", klik1)
		case 2:client_cmd(id, "spk %s", klik2)
	}
	if(item == 0)
		MenuOpisAchi(id)
	return PLUGIN_CONTINUE
}
///////////////////////////////////////////////////////////////

public DeathMsg()
{
	new atakujacy = read_data(1);
	new obronca = read_data(2);
	new hs = read_data(3)
	
	//new czy[33]
	if(!is_user_connected(atakujacy) || !is_user_connected(obronca))
		return PLUGIN_CONTINUE
	if(atakujacy != obronca && is_user_connected(atakujacy) && get_user_team(atakujacy) != get_user_team(obronca))
	{
		new bron = get_user_weapon(atakujacy)
		if(hs)
		{
			//HeadShot
			if(status_achI[atakujacy][9] == 1)
				postep_achI[atakujacy][9]++
				
			if(status_achII[atakujacy][9] == 1)
				postep_achII[atakujacy][9]++
				
			if(status_achIII[atakujacy][9] == 1)
				postep_achIII[atakujacy][9]++
		}
		//Pistolety
		if(status_achI[atakujacy][0] == 1 && (bron == CSW_GLOCK18 || bron == CSW_USP || bron == CSW_P228 || bron == CSW_DEAGLE || bron == CSW_FIVESEVEN || bron == CSW_ELITE))
			postep_achI[atakujacy][0]++

		else if(status_achII[atakujacy][0] == 1 && (bron == CSW_GLOCK18 || bron == CSW_USP || bron == CSW_P228 || bron == CSW_DEAGLE || bron == CSW_FIVESEVEN || bron == CSW_ELITE))
			postep_achII[atakujacy][0]++

		else if(status_achIII[atakujacy][0] == 1 && (bron == CSW_GLOCK18 || bron == CSW_USP || bron == CSW_P228 || bron == CSW_DEAGLE || bron == CSW_FIVESEVEN || bron == CSW_ELITE))
			postep_achIII[atakujacy][0]++

		//Shotgan
		if(status_achI[atakujacy][1] == 1 && (bron == CSW_XM1014 || bron == CSW_M3))
			postep_achI[atakujacy][1]++
			
		else if(status_achII[atakujacy][1] == 1 && (bron == CSW_XM1014 || bron == CSW_M3))
			postep_achII[atakujacy][1]++

		else if(status_achIII[atakujacy][1] == 1 && (bron == CSW_XM1014 || bron == CSW_M3))
			postep_achIII[atakujacy][1]++

		//SMG
		if(status_achI[atakujacy][2] == 1 && (bron == CSW_TMP || bron == CSW_MAC10 || bron == CSW_MP5NAVY || bron == CSW_UMP45 || bron == CSW_P90))
			postep_achI[atakujacy][2]++
		
		else if(status_achII[atakujacy][2] == 1 && (bron == CSW_TMP || bron == CSW_MAC10 || bron == CSW_MP5NAVY || bron == CSW_UMP45 || bron == CSW_P90))
			postep_achII[atakujacy][2]++

		else if(status_achIII[atakujacy][2] == 1 && (bron == CSW_TMP || bron == CSW_MAC10 || bron == CSW_MP5NAVY || bron == CSW_UMP45 || bron == CSW_P90))
			postep_achIII[atakujacy][2]++

		//Rifle ( karabiny )
		if(status_achI[atakujacy][3] == 1 && (bron == CSW_FAMAS || bron == CSW_GALIL || bron == CSW_AK47 || bron == CSW_M4A1 || bron == CSW_AUG || bron == CSW_SG552))
			postep_achI[atakujacy][3]++
			
		else if(status_achII[atakujacy][3] == 1 && (bron == CSW_FAMAS || bron == CSW_GALIL || bron == CSW_AK47 || bron == CSW_M4A1 || bron == CSW_AUG || bron ==  CSW_SG552))
			postep_achII[atakujacy][3]++

		else if(status_achIII[atakujacy][3] == 1 && (bron == CSW_FAMAS || bron == CSW_GALIL || bron == CSW_AK47 || bron == CSW_M4A1 || bron == CSW_AUG || bron ==  CSW_SG552))
			postep_achIII[atakujacy][3]++
			
		// KrowoManiak
		if(status_achI[atakujacy][4] == 1 && bron == CSW_M249)
			postep_achI[atakujacy][4]++

		else if(status_achII[atakujacy][4] == 1 && bron == CSW_M249)
			postep_achII[atakujacy][4]++

		else if(status_achIII[atakujacy][4] == 1 && bron == CSW_M249)
			postep_achIII[atakujacy][4]++
		//Snajper
		if(status_achI[atakujacy][7] == 1 && (bron == CSW_AWP || bron == CSW_SCOUT || bron == CSW_G3SG1 || bron == CSW_SG550))
			postep_achI[atakujacy][7]++
			
		else if(status_achII[atakujacy][7] == 1 && (bron == CSW_AWP || bron == CSW_SCOUT || bron == CSW_G3SG1 || bron == CSW_SG550))
			postep_achII[atakujacy][7]++
			
		else if(status_achIII[atakujacy][7] == 1 && (bron == CSW_AWP || bron == CSW_SCOUT || bron == CSW_G3SG1 || bron == CSW_SG550))
			postep_achIII[atakujacy][7]++
		//Nozownik
		if(status_achI[atakujacy][8] == 1 && bron == CSW_KNIFE)
			postep_achI[atakujacy][8]++
			
		else if(status_achII[atakujacy][8] == 1 && bron == CSW_KNIFE)
			postep_achII[atakujacy][8]++
			
		else if(status_achIII[atakujacy][8] == 1 && bron == CSW_KNIFE)
			postep_achIII[atakujacy][8]++
			
		//Killer
		if(status_achI[atakujacy][11] == 1)
			postep_achI[atakujacy][11]++
			
		else if(status_achII[atakujacy][11] == 1)
			postep_achII[atakujacy][11]++
			
		else if(status_achIII[atakujacy][11] == 1)
			postep_achIII[atakujacy][11]++
		
		//Zabijanie Kleczac
		zabil_wroga[atakujacy] = 1
		
	}
	
	SprawdzAch(atakujacy)
	SprawdzAch(obronca)
	
	ZapiszWszystko(atakujacy)
	ZapiszWszystko(obronca)
	
	return PLUGIN_CONTINUE
}

///////////////////////////////////////////////////////////////

public bomb_planted(podkladajacy)
{
	if(!is_user_connected(podkladajacy))
		return PLUGIN_CONTINUE
	if(status_achI[podkladajacy][5] == 1)
		postep_achI[podkladajacy][5]++
		
	else if(status_achII[podkladajacy][5] == 1)
		postep_achII[podkladajacy][5]++
		
	else if(status_achIII[podkladajacy][5] == 1)
		postep_achIII[podkladajacy][5]++
	
	SprawdzAch(podkladajacy)
	return PLUGIN_CONTINUE
	
}

public bomb_defused(rozbrajajacy)
{
	if(!is_user_connected(rozbrajajacy))
		return PLUGIN_CONTINUE
	if(status_achI[rozbrajajacy][6] == 1)
		postep_achI[rozbrajajacy][6]++

	else if(status_achII[rozbrajajacy][6] == 1)
		postep_achII[rozbrajajacy][6]++
		
	else if(status_achIII[rozbrajajacy][6] == 1)
		postep_achIII[rozbrajajacy][6]++	

	SprawdzAch(rozbrajajacy)
	return PLUGIN_CONTINUE
}

///////////////////////////////////////////////////////////////

public ZapiszAchI(id)
{
	get_user_name(id, nazwa_gracza, 32)
	new dane[256], klucz[64]
	formatex(klucz, 63, "%s-expaI", nazwa_gracza)
	formatex(dane, 255, "%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#^n", status_achI[id][0], status_achI[id][1],
	status_achI[id][2], status_achI[id][3], status_achI[id][4], status_achI[id][5], status_achI[id][6], status_achI[id][7], 
	status_achI[id][8], status_achI[id][9], status_achI[id][10], status_achI[id][11], status_achI[id][12], status_achI[id][13],postep_achI[id][0], postep_achI[id][1], postep_achI[id][2], postep_achI[id][3], postep_achI[id][4],
	postep_achI[id][5], postep_achI[id][6], postep_achI[id][7], postep_achI[id][8], postep_achI[id][9], postep_achI[id][10], postep_achI[id][11], postep_achI[id][12], postep_achI[id][13])
	
	nvault_set(plik_achI, klucz, dane)
}

public ZapiszAchII(id)
{
	get_user_name(id, nazwa_gracza, 32)
	new dane[256], klucz[64]
	formatex(klucz, 63, "%s-expaII", nazwa_gracza)
	formatex(dane, 255, "%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#^n", status_achII[id][0], status_achII[id][1],
	status_achII[id][2], status_achII[id][3], status_achII[id][4], status_achII[id][5], status_achII[id][6], status_achII[id][7], status_achII[id][8], status_achII[id][9], status_achII[id][10], status_achII[id][11], status_achII[id][12],
	status_achII[id][13],postep_achII[id][0], postep_achII[id][1], postep_achII[id][2], postep_achII[id][3], postep_achII[id][4], postep_achII[id][5], postep_achII[id][6], postep_achII[id][7], postep_achII[id][8],
	postep_achII[id][9], postep_achII[id][10], postep_achII[id][11], postep_achII[id][12], postep_achII[id][13])
	
	nvault_set(plik_achII, klucz, dane)
}

public ZapiszAchIII(id)
{
	get_user_name(id, nazwa_gracza, 32)
	new dane[256], klucz[64]
	formatex(klucz, 63, "%s-expaIII", nazwa_gracza)
	formatex(dane, 255, "%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#^n", status_achIII[id][0], status_achIII[id][1],
	status_achIII[id][2], status_achIII[id][3], status_achIII[id][4], status_achIII[id][5], status_achIII[id][6], status_achIII[id][7], status_achIII[id][8], 
	status_achIII[id][9], status_achIII[id][10], status_achIII[id][11], status_achIII[id][12], status_achIII[id][13],
	postep_achIII[id][0], postep_achIII[id][1], postep_achIII[id][2], postep_achIII[id][3], postep_achIII[id][4], postep_achIII[id][5], 
	postep_achIII[id][6], postep_achIII[id][7], postep_achIII[id][8], postep_achIII[id][9], postep_achIII[id][10], postep_achIII[id][11], postep_achIII[id][12],
	postep_achIII[id][13])
	
	nvault_set(plik_achIII, klucz, dane)
}

///////////////////////////////////////////////////////////////

public WczytajAchI(id)
{
	get_user_name(id, nazwa_gracza, 32)
	new dane[256], klucz[64]
	
	formatex(klucz, 63, "%s-expaI", nazwa_gracza)
	
	formatex(dane, 255, "%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#^n", status_achI[id][0], status_achI[id][1],
	status_achI[id][2], status_achI[id][3], status_achI[id][4], status_achI[id][5], status_achI[id][6], status_achI[id][7], 
	status_achI[id][8], status_achI[id][9], status_achI[id][10], status_achI[id][11], status_achI[id][12], status_achI[id][13],postep_achI[id][0], postep_achI[id][1], postep_achI[id][2], postep_achI[id][3], postep_achI[id][4],
	postep_achI[id][5], postep_achI[id][6], postep_achI[id][7], postep_achI[id][8], postep_achI[id][9], postep_achI[id][10], postep_achI[id][11], postep_achI[id][12], postep_achI[id][13])
	
	nvault_get(plik_achI, klucz, dane, 255)
	
	replace_all(dane, 255, "#", " ")
	
	new sg[sizeof NazwyAchiI][15]
	new pg[sizeof NazwyAchiI][15]
	
	parse(dane, sg[0], 15, sg[1], 15, sg[2], 15, sg[3], 15, sg[4], 15, sg[5], 15, sg[6], 15, sg[7], 15, sg[8], 15, sg[9], 15, sg[10], 15, sg[11], 15, sg[12], 15, sg[13], 15,
	pg[0], 15, pg[1], 15, pg[2], 15, pg[3], 15, pg[4], 15, pg[5], 15, pg[6], 15, pg[7], 15, pg[8], 15, pg[9] ,15, pg[10], 15, pg[11], 15, pg[12], 15, pg[13], 15)
	
	for(new i = 0 ; i < sizeof NazwyAchiI ; i++)
	{
		status_achI[id][i] = str_to_num(sg[i])
		postep_achI[id][i] = str_to_num(pg[i])
	}
	
}
public WczytajAchII(id)
{
	get_user_name(id, nazwa_gracza, 32)
	new dane[256], klucz[64]
	
	formatex(klucz, 63, "%s-expaII", nazwa_gracza)
	
	formatex(dane, 255, "%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#^n", status_achII[id][0], status_achII[id][1],
	status_achII[id][2], status_achII[id][3], status_achII[id][4], status_achII[id][5], status_achII[id][6], status_achII[id][7], status_achII[id][8], status_achII[id][9], status_achII[id][10], status_achII[id][11], status_achII[id][12],
	status_achII[id][13],postep_achII[id][0], postep_achII[id][1], postep_achII[id][2], postep_achII[id][3], postep_achII[id][4], postep_achII[id][5], postep_achII[id][6], postep_achII[id][7], postep_achII[id][8],
	postep_achII[id][9], postep_achII[id][10], postep_achII[id][11], postep_achII[id][12], postep_achII[id][13])
	
	nvault_get(plik_achII, klucz, dane, 255)
	
	replace_all(dane, 255, "#", " ")
	
	new sg[sizeof NazwyAchiII][15]
	new pg[sizeof NazwyAchiII][15]
	
	parse(dane, sg[0], 15, sg[1], 15, sg[2], 15, sg[3], 15, sg[4], 15, sg[5], 15, sg[6], 15, sg[7], 15, sg[8], 15, sg[9], 15, sg[10], 15, sg[11], 15, sg[12], 15, sg[13], 15,
	pg[0], 15, pg[1], 15, pg[2], 15, pg[3], 15, pg[4], 15, pg[5], 15, pg[6], 15, pg[7], 15, pg[8], 15, pg[9] ,15, pg[10], 15, pg[11], 15, pg[12], 15, pg[13], 15)
	
	for(new i = 0 ; i < sizeof NazwyAchiII ; i++)
	{
		status_achII[id][i] = str_to_num(sg[i])
		postep_achII[id][i] = str_to_num(pg[i])
	}
}
public WczytajAchIII(id)
{
	get_user_name(id, nazwa_gracza, 32)
	new dane[256], klucz[64]
	
	formatex(klucz, 63, "%s-expaIII", nazwa_gracza)
	
	formatex(dane, 255, "%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#%i#^n", status_achIII[id][0], status_achIII[id][1],
	status_achIII[id][2], status_achIII[id][3], status_achIII[id][4], status_achIII[id][5], status_achIII[id][6], status_achIII[id][7], status_achIII[id][8], 
	status_achIII[id][9], status_achIII[id][10], status_achIII[id][11], status_achIII[id][12], status_achIII[id][13],
	postep_achIII[id][0], postep_achIII[id][1], postep_achIII[id][2], postep_achIII[id][3], postep_achIII[id][4], postep_achIII[id][5], 
	postep_achIII[id][6], postep_achIII[id][7], postep_achIII[id][8], postep_achIII[id][9], postep_achIII[id][10], postep_achIII[id][11], postep_achIII[id][12],
	postep_achIII[id][13])
	
	
	nvault_get(plik_achIII, klucz, dane, 255)
	
	replace_all(dane, 255, "#", " ")
	new sg[sizeof NazwyAchiIII][15]
	new pg[sizeof NazwyAchiIII][15]
	parse(dane, sg[0], 15, sg[1], 15, sg[2], 15, sg[3], 15, sg[4], 15, sg[5], 15, sg[6], 15, sg[7], 15, sg[8], 15, sg[9], 15, sg[10], 15, sg[11], 15, sg[12], 15, sg[13], 15,
	pg[0], 15, pg[1], 15, pg[2], 15, pg[3], 15, pg[4], 15, pg[5], 15, pg[6], 15, pg[7], 15, pg[8], 15, pg[9] ,15, pg[10], 15, pg[11], 15, pg[12], 15, pg[13], 15)
	
	for(new i = 0 ; i < sizeof NazwyAchiIII ; i++)
	{
		status_achIII[id][i] = str_to_num(sg[i])
		postep_achIII[id][i] = str_to_num(pg[i])
	}
		
}

///////////////////////////////////////////////////////////////

public WczytajWszystko(id)
{
	WczytajAchI(id)
	WczytajAchII(id)
	WczytajAchIII(id)
}
public ZapiszWszystko(id)
{
	ZapiszAchI(id)
	ZapiszAchII(id)
	ZapiszAchIII(id)
}

///////////////////////////////////////////////////////////////

public CmdStart(id, uc_handle)
{
	if(!is_user_alive(id) || !is_user_connected(id))
		return FMRES_IGNORED;
	
	new button = get_uc(uc_handle, UC_Buttons);
	//new oldbutton = get_user_oldbutton(id);
	new flags = get_entity_flags(id);
	if(zabil_wroga[id])
	{
		//Zabicia kleczac
		
		if((flags & FL_ONGROUND) && (button & IN_DUCK))
		{
			if(status_achI[id][10] == 1)
				postep_achI[id][10]++
	
			if(status_achII[id][10] == 1)
				postep_achII[id][10]++
	
			if(status_achIII[id][10] == 1)
				postep_achIII[id][10]++
		}
		//Zabicia w powietrzu
		if(!(flags & FL_ONGROUND))
		{
			if(status_achI[id][12] 	== 1)
				postep_achI[id][12]++
	
			if(status_achII[id][12] == 1)
				postep_achII[id][12]++
	
			if(status_achIII[id][12] == 1)
				postep_achIII[id][12]++
		}
			
		zabil_wroga[id] = 0
	}
	
	ZapiszWszystko(id)
	SprawdzAch(id)
	
	return FMRES_IGNORED;
}

///////////////////////////////////////////////////////////////