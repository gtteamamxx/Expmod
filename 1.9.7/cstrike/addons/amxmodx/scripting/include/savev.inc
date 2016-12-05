#if defined _Save_included
  #endinput
#endif

#include <amxmodx>

new sciezka[]	= "addons/amxmodx/Zapis_v2" // Folder zapisywanych plikow

/* Funkcja Zapisywania */

public ZapiszDane(const file[], const key[], const data[])
{
	new ominac
	new c[1024], sciezka_[128], arg1[64], tekst[500], len;
	
	formatex(sciezka_, 127, "%s/%s", sciezka, file);
	
	formatex(c, 1023, "^"%s^" ^"%s^"", key, data);
	
	if(!dir_exists(sciezka))
		mkdir(sciezka);	
		
	if(!file_exists(sciezka_))
		write_file(sciezka_, "", 0);
		
	for(new i; read_file(sciezka_, i, tekst, 499, len);i++)
	{
		parse(tekst, arg1, 63);
		
		if(equal(key, arg1, strlen(arg1)))
		{
			write_file(sciezka_, c, i); 
			ominac++
		}	
		else	
			continue;
	}
	if(!ominac)
		write_file(sciezka_, c, -1);
	ominac = 0
}

/* Funkcja Odczytywania */

public WczytajDane(const file[], const key[], data[], len)
{
	new tekst[1101], len, sciezka_[128];
	new arg1[64], arg2[1024];
	
	formatex(sciezka_, 127, "%s/%s", sciezka, file) 
	
	if(!file_exists(sciezka_))
		return PLUGIN_CONTINUE
	for(new i; read_file(sciezka_, i, tekst, 1100, len);i++)
	{
		parse(tekst, arg1, 63, arg2, 1023);
		
		if(equal(key, arg1, strlen(arg1)))
			copy(data, len, arg2); 
		else	
			continue;
	}
	return PLUGIN_CONTINUE
}

/* Funkcja Usuwania */

public UsunDane(const file[], const key[])
{

	new tekst[1101], len, sciezka_[128];
	new arg1[64], arg2[1024];
	
	formatex(sciezka_, 127, "%s/%s", sciezka, file) 
	
	if(!file_exists(sciezka_))
		return PLUGIN_CONTINUE
	for(new i; read_file(sciezka_, i, tekst, 1100, len);i++)
	{
		parse(tekst, arg1, 63, arg2, 1023);
		
		if(equal(key, arg1, strlen(arg1)))
			write_file(sciezka_, "", i);
		else	
			continue;
	}
	return PLUGIN_CONTINUE
}



/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1045\\ f0\\ fs16 \n\\ par }
*/
