/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <expmod>
#include <fun>
#include <cstrike>
#include <tutor>
#include <engine>
#include <hamsandwich>
#include <ColorChat>

#define PLUGIN "ExpMod Shop"
#define VERSION "1.1"
#define AUTHOR "tomcionek15 & grs4"

new const maxAmmo[31] = {0,52,0,90,1,32,1,100,90,1,120,100,100,90,90,90,100,120,30,120,200,32,90,120,90,2,35,90,90,0,100};
new p_exp_tutor_sound
new p_exp_infostyle
/*
	p_exp_infostyle 	= 0 	// NIC
	p_exp_infostyle 	= 1 	// TUTOR
	p_exp_infostyle 	= 2 	// COLORCHAT
	p_exp_infostyle 	= 3 	// TUTOR + COLORCHAT
*/
new NazwySklep[][] = {
	"Maxymalne Leczenie",
	"Amunicja",
	"Zestaw Happy Meal",
	"2000 Exp",
	"5000 Exp",
	"Odblokowanie Misji",
	"Szczesliwy numerek"
}

new CenySklep[] = {
	25,
	10,
	35,
	35,
	70,
	200,
	10
}
new OpisySklep[][] = {
	"Leczy cie do Maximum HP",
	"Dostajesz amunicje do aktualnej broni",
	"W zaleznosci od druzyny: M4A1+Deagle+Granaty | AK47+Deagle+Granaty",
	"Dostajesz dodatkowo 2000 expa",
	"Dostajesz dodatkowo 5000 expa",
	"Odblokowywujesz wybrana wykonana misje",
	"Miliony nagrod do wygrania"
}

new wybierany_przedmiot[33]
new wybierana_misja[33]
new kupil_lotto[33]

new menu_on[] 	= "ExpMod/menu_on.wav"
new klik1[]	= "ExpMod/klik.wav"
new klik2[]	= "ExpMod/klik2.wav"
new komunikat1[]= "ExpMod/komunikat1.wav"
new komunikat2[]= "ExpMod/komunikat2.wav"

public plugin_natives()
{
	register_native("exp_show_shop_menu", "MenuSklep", 1)
}
public plugin_init()
 {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	tutorInit()
	
	register_clcmd("say /sklep", 		"MenuSklep"	)
	register_clcmd("say /shop", 		"MenuSklep"	)
	
	p_exp_tutor_sound = 	register_cvar("exp_tutor_sounds", "1"	);
	p_exp_infostyle = 	register_cvar("exp_infostyle", 	"3"	);
	
	register_logevent("NowaRunda",	2, 	"1=Round_Start"	)
}
public plugin_precache()
{
	tutorPrecache()
	precache_sound(menu_on)
	precache_sound(klik1)
	precache_sound(klik2)
	precache_sound(komunikat1)
	precache_sound(komunikat2)
}
public MenuSklep(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE
	new tytul[120], przedmioty[120]
	
	formatex(tytul, 119, "Masz %d monet co kupujesz ?", exp_get_user_monets(id))
	
	new menu_sklep 		= menu_create(tytul, "MenuSklep_Wybieranie")
	new menu_sklep_cb 	= menu_makecallback("MenuSklep_CallBack")
	
	for(new i = 0 ; i < sizeof NazwySklep ; i++)
	{
		formatex(przedmioty, 119, "%s \r[%d monet]", NazwySklep[i], CenySklep[i])
		menu_additem(menu_sklep, przedmioty, _, _, menu_sklep_cb)
	}
	
	menu_display(id, menu_sklep)
	return PLUGIN_CONTINUE
}

public MenuSklep_CallBack(id, menu, item)
{
	if((item == 0 && get_user_health(id) >= (100+exp_get_user_new_health(id))) || item == 0 && exp_get_user_monets(id) < CenySklep[0] || item == 0 && !is_user_alive(id))
		return ITEM_DISABLED
		
	for(new i = 1 ; i < sizeof NazwySklep; i++)
	{
		if(item == i && exp_get_user_monets(id) < CenySklep[i])
			return ITEM_DISABLED
	}
	if(item == 6 && kupil_lotto[id])
		return ITEM_DISABLED
		
	return ITEM_ENABLED
}

	
	
public MenuSklep_Wybieranie(id, menu, item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	new opis[256]
	for(new i = 0 ; i < sizeof NazwySklep ; i++)
	{
		if(item == i)
		{
			wybierany_przedmiot[id] = i
			formatex(opis, 255, "\yPrzedmiot : \w%s^n\yOpis : \w%s^n\yCena : \w%d monet^n\rWybierasz?", NazwySklep[i], OpisySklep[i], CenySklep[i])
		}
	}
	new menu_potwierdz = menu_create(opis, "PotwierdzKupnoSklep")
	menu_additem(menu_potwierdz, "Tak")
	menu_additem(menu_potwierdz, "Nie")
	menu_display(id, menu_potwierdz)
	
	return PLUGIN_CONTINUE
}
public PotwierdzKupnoSklep(id, menu, item)
{
	if(item == MENU_EXIT || !is_user_connected(id))
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	if(item == 0)
	{
		switch(wybierany_przedmiot[id])
		{
			case 0: 
			{
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
					tutorMake(id, TUTOR_GREEN, 4.0, "Kupiles : %s", NazwySklep[wybierany_przedmiot[id]])
				}
				if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
				{
					ColorChat(id, GREEN, "[EXPMOD]^x01 Kupiles : ^x04%s", NazwySklep[wybierany_przedmiot[id]])
				}
				set_user_health(id, 100+exp_get_user_new_health(id))
				exp_set_user_monets(id, exp_get_user_monets(id)-CenySklep[0])
			}
			case 1:
			{
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
					tutorMake(id, TUTOR_GREEN, 4.0, "Kupiles : %s", NazwySklep[wybierany_przedmiot[id]])
				}
				if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
				{
					ColorChat(id, GREEN, "[EXPMOD]^x01 Kupiles : ^x04%s", NazwySklep[wybierany_przedmiot[id]])
				}
				exp_set_user_monets(id, exp_get_user_monets(id)-CenySklep[1])
				new weapons[32];
				new weaponsnum;
				get_user_weapons(id, weapons, weaponsnum);
				
				for(new i=0; i<weaponsnum; i++)
					if(is_user_alive(id))
						if(maxAmmo[weapons[i]] > 0)
							cs_set_user_bpammo(id, weapons[i], maxAmmo[weapons[i]]);
			}
			case 2:
			{
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
					tutorMake(id, TUTOR_GREEN, 4.0, "Kupiles : %s", NazwySklep[wybierany_przedmiot[id]])
				}
				if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
				{
					ColorChat(id, GREEN, "[EXPMOD]^x01 Kupiles : ^x04%s", NazwySklep[wybierany_przedmiot[id]])
				}
				exp_set_user_monets(id, exp_get_user_monets(id)-CenySklep[2])
				if(get_user_team(id) == 1)
				{
					give_item(id, "weapon_ak47")
					cs_set_user_bpammo(id, CSW_AK47, 90)
					give_item(id, "weapon_deagle")
					cs_set_user_bpammo(id, CSW_DEAGLE, 35)
					give_item(id, "weapon_hegrenade")
					give_item(id, "weapon_smokegrenade")
					give_item(id, "weapon_flashbang")
					give_item(id, "weapon_flashbang")
				}
				else if(get_user_team(id) == 2)
				{
					give_item(id, "weapon_m4a1")
					cs_set_user_bpammo(id, CSW_M4A1, 90)
					give_item(id, "weapon_deagle")
					cs_set_user_bpammo(id, CSW_DEAGLE, 35)
					give_item(id, "weapon_hegrenade")
					give_item(id, "weapon_smokegrenade")
					give_item(id, "weapon_flashbang")
					give_item(id, "weapon_flashbang")
				}
			}
			case 3:
			{
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
					tutorMake(id, TUTOR_GREEN, 4.0, "Kupiles : %s", NazwySklep[wybierany_przedmiot[id]])
				}
				if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
				{
					ColorChat(id, GREEN, "[EXPMOD]^x01 Kupiles : ^x04%s", NazwySklep[wybierany_przedmiot[id]])
				}
				exp_set_user_monets(id, exp_get_user_monets(id)-CenySklep[3])
				exp_set_user_exp(id, exp_get_user_exp(id)+2000)
				exp_checklevel(id)
			}
			case 4:
			{
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
					tutorMake(id, TUTOR_GREEN, 4.0, "Kupiles : %s", NazwySklep[wybierany_przedmiot[id]])
				}
				if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
				{
					ColorChat(id, GREEN, "[EXPMOD]^x01 Kupiles : ^x04%s", NazwySklep[wybierany_przedmiot[id]])
				}
				exp_set_user_monets(id, exp_get_user_monets(id)-CenySklep[4])
				exp_set_user_exp(id, exp_get_user_exp(id)+5000)
				exp_checklevel(id)
			}
			case 5:
			{
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
					tutorMake(id, TUTOR_GREEN, 4.0, "Wybrales : %s^nPo odblokowaniu misji monety zostana odtracone", NazwySklep[wybierany_przedmiot[id]])
				}
				if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
				{
					ColorChat(id, GREEN, "[EXPMOD]^x01 Wybrales : ^x04%s", NazwySklep[wybierany_przedmiot[id]])
					ColorChat(id, GREEN, "[EXPMOD]^x01 Po odblokowaniu ^x04monety^x01 zostana odtracone")
				}
				MenuOdblokuj(id)
			}
			case 6:
			{
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
					tutorMake(id, TUTOR_GREEN, 4.0, "Kupiles : %s^nPoczekaj cierpliwie na wyniki losowania", NazwySklep[wybierany_przedmiot[id]])
				}
				if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
				{
					ColorChat(id, GREEN, "[EXPMOD]^x01 Kupiles : ^x04%s", NazwySklep[wybierany_przedmiot[id]])
					ColorChat(id, GREEN, "[EXPMOD]^x01 Poczekaj cierpliwie na ^x03wyniki losowania")
				}
				exp_set_user_monets(id, exp_get_user_monets(id)-CenySklep[6])
				set_task(10.0, "Losowanie", id)
			}
		}
	}
	else if(item == 1)
		MenuSklep(id)
	return PLUGIN_CONTINUE
}
new ids[33]
public MenuOdblokuj(id)
{
	
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE
	new ma = 0
	new nazwa_misji[64]
	new info[256]
	new menu 	= menu_create("Ktora misje chcesz odblokowac?", "MenuOdblokuj_Wybieranie")
	for(new i = 0 ; i < exp_get_mission_numbers() ; i++)
	{
		if(exp_check_user_locked_mission(id, i) == 1)
		{
			exp_get_mission_name(i, nazwa_misji, 63)
			formatex(info, 255, "%s \y[\r%d \wlvl\y]", nazwa_misji, exp_get_mission_required_level(i))
			menu_additem(menu, info)
			ids[++ma] = i
		}
	}
	menu_display(id, menu)
	return PLUGIN_CONTINUE
}

public MenuOdblokuj_Wybieranie(id, menu, item)
{
	if(item == MENU_EXIT || !is_user_connected(id))
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	
	new nazwa_misji[64]
	new opis_misji[64]
	new opis[256]
	++item 
	wybierana_misja[id] = ids[item]
	exp_get_mission_name(wybierana_misja[id], nazwa_misji, 63)
	exp_get_mission_description(wybierana_misja[id], opis_misji, 63)
	
	
	formatex(opis, 255, "Misja : %s^nOpis : %s^nOdblokowac ta misje ?", nazwa_misji, opis_misji)
	
	new menu = menu_create(opis, "OdblokowanieMisjiWykonac")
	
	menu_additem(menu, "Tak")
	menu_additem(menu, "Nie")
	
	menu_display(id, menu)
	
	return PLUGIN_CONTINUE
}
public OdblokowanieMisjiWykonac(id, menu, item)
{
	if(item == MENU_EXIT || !is_user_connected(id))
	{
		menu_destroy(menu)
		return PLUGIN_CONTINUE
	}
	new nazwa_misji[64]
	exp_get_mission_name(wybierana_misja[id], nazwa_misji, 63)
	
	if(item == 0)
	{
		exp_set_user_monets(id, exp_get_user_monets(id)-CenySklep[5])
		exp_unlock_or_lock_mission(id, wybierana_misja[id], 0)
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
			tutorMake(id, TUTOR_GREEN, 4.0, "Odblokowales misje : %s", nazwa_misji)
		}
		if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
		{
			ColorChat(id, GREEN, "[EXPMOD]^x01 Odblokowales misje : ^x03%s", nazwa_misji)
		}
	}
	else if(item == 1)
	{
		MenuOdblokuj(id)
	}
	return PLUGIN_CONTINUE			
}
/*
public TakeDamage(this, idinflictor, idattacker, Float:damage, damagebits)
{
	if(!is_user_alive(this) || !is_user_connected(this) || !is_user_connected(idattacker))
		return HAM_IGNORED
		
	//new zycie = get_user_health(this);
	//new bron = get_user_weapon(idattacker);
	
	
	if(ironman[idattacker])
		damage+=50

	SetHamParamFloat(4, damage);
	return HAM_IGNORED;
}*/

public Losowanie(id)
{
	if(!is_user_connected(id))
		return PLUGIN_CONTINUE
	kupil_lotto[id] = 1
	switch(random_num(1, 10))
	{
		case 1:
		{
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
				tutorMake(id, TUTOR_GREEN, 4.0, "Wygrales w lotku 5 monet")
			}
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				ColorChat(id, GREEN, "[EXPMOD]^x01 Wygrales w lotku ^x045^x01 monet")
			}
			exp_set_user_monets(id, exp_get_user_monets(id)+5)
		}
		case 2:
		{
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
				tutorMake(id, TUTOR_GREEN, 4.0, "Niestety w lotku nic nie wygrales")
			}
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				ColorChat(id, GREEN, "[EXPMPD]^x01 Niestety w lotku nic nie wygrales")
			}
		}
		case 3:
		{
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
				tutorMake(id, TUTOR_GREEN, 4.0, "Niestety w lotku nic nie wygrales")
			}
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				ColorChat(id, GREEN, "[EXPMPD]^x01 Niestety w lotku nic nie wygrales")
			}
		}
		case 4:
		{
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
				tutorMake(id, TUTOR_GREEN, 4.0, "Niestety w lotku nic nie wygrales")
			}
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				ColorChat(id, GREEN, "[EXPMPD]^x01 Niestety w lotku nic nie wygrales")
			}
		}
		case 5:
		{
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
				tutorMake(id, TUTOR_GREEN, 4.0, "Wygrales w lotku 2 monety")
			
			}
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				ColorChat(id, GREEN, "[EXPMPD]^x01 Wygrales w lotku ^x042^x01 monety")
			}
			exp_set_user_monets(id, exp_get_user_monets(id)+2)
		}
		case 6:
		{
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
				tutorMake(id, TUTOR_GREEN, 4.0, "Wygrales w lotku 300 expa")
			}
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				ColorChat(id, GREEN, "[EXPMPD]^x01 Wygrales w lotku ^x04300^x01 expa")
			}
			exp_set_user_exp(id, exp_get_user_exp(id)+300)
			exp_checklevel(id)
		}
		case 7:
		{
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
				tutorMake(id, TUTOR_GREEN, 4.0, "Wygrales w lotku 500 expa")
			}
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				ColorChat(id, GREEN, "[EXPMPD]^x01 Wygrales w lotku^x04 500^x01 expa")
			}
			exp_set_user_exp(id, exp_get_user_exp(id)+500)
			exp_checklevel(id)
		}
		case 8:
		{
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
				tutorMake(id, TUTOR_GREEN, 4.0, "Wygrales w lotku $2000")
			}
			if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
			{
				ColorChat(id, GREEN, "[EXPMPD]^x01 Wygrales  w lotku ^x04$2000")
			}
			cs_set_user_money(id, cs_get_user_money(id)+2000)
		}
		case 9:
		{
			switch(random_num(1, 50))
			{
				case 25..27:
				{
					new gracz[33]
					get_user_name(id, gracz, 32)
					new exp = exp_get_user_nextlevelexp(id)-exp_get_user_exp(id)
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
						tutorMake(0, TUTOR_YELLOW, 4.0, "Gracz %s wygral w lotku nagrode glowna!!!^nBrakujacy exp do nastepnego levelu( %d ) : %d^nZwyciezcy Gratulujemy! ", gracz, exp_get_user_level(id)+1, exp)
					}
					if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
					{
						ColorChat(id, GREEN, "[EXPMPD]^x01 Gracz ^x03%s^x01 wygral w lotku nagrode glowna!!!", gracz)
						ColorChat(id, GREEN, "[EXPMPD]^x01 Brakujacy exp do nastepnego levelu(^x04 %d^x01 ) : ^x04%d", exp_get_user_level(id)+1, exp)
					}
					exp_set_user_exp(id, exp_get_user_exp(id)+exp)
					exp_checklevel(id)
				}
			}
		}
		case 10:
		{
			if(!is_user_alive(id)){
					Losowanie(id)
				}
			else
			{
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
					tutorMake(id, TUTOR_GREEN, 4.0, "Wygrales 100 HP")
				}
				if(get_pcvar_num(p_exp_infostyle) == 2 || get_pcvar_num(p_exp_infostyle) == 3)
				{
					ColorChat(id, GREEN, "[EXPMPD]^x01 Wygrales ^x04100^x03 HP")
				}
				set_user_health(id, get_user_health(id)+100)
			}
		}	
	}
	return PLUGIN_CONTINUE
}

public NowaRunda()
{
	for(new i = 1 ; i < 33 ; i++)
	{
		if(!is_user_connected(i))
			return PLUGIN_CONTINUE
		kupil_lotto[i] = 0
	}
	return PLUGIN_CONTINUE
}
			
			
			
