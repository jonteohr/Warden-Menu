/*
* ## TEAM VARIABLES ##
* CS_TEAM_T
* CS_TEAM_CT
* CS_TEAM_SPECTATOR
* CS_TEAM_NONE
*/

#include <sourcemod>
#include <cstrike>
#include <colors>
#include <eskojbwarden>

#define VERSION "1.0"

#define CHOICE1 "#choice1"
#define CHOICE2 "#choice2"
#define CHOICE3 "#choice3"
#define CHOICE4 "#choice4"

new String:prefix[] = "[{blue}WardenMenu{default}]";
new bool:IsGameActive = false;

// Current game
int hnsActive = 0;
int freedayActive = 0;
int wardayActive = 0;

// Track number of games played
int hnsTimes = 0;
int freedayTimes = 0;
int warTimes = 0;

// ## CVars ##
ConVar cvVersion;
// Convars to add different menu entries
ConVar cvHnS;
ConVar cvHnSGod;
ConVar cvHnSTimes;
ConVar cvFreeday;
ConVar cvFreedayTimes;
ConVar cvWarday;
ConVar cvWardayTimes;

public Plugin:myinfo = 
{
	name = "[CS:GO] Warden Menu",
	author = "Hypr",
	description = "Gives wardens access to a special menu",
	version = VERSION,
	url = "https://condolent.xyz"
}

public OnPluginStart() {
	
	LoadTranslations("cmenu.phrases.txt");
	SetGlobalTransTarget(LANG_SERVER);
	
	AutoExecConfig(true, "cmenu");
	
	//var = CreateConVar("cvar_name", "default_value", "description", _, true, min, true, max);
	cvVersion = CreateConVar("sm_cmenu_version", VERSION, "Current version running. Debugging purposes only!", FCVAR_DONTRECORD); // Not visible in config
	cvHnS = CreateConVar("sm_cmenu_hns", "1", "Add an option for Hide and Seek in the menu?\n0 = Disable. 1 = Enable.", _, true, 0.0, true, 1.0);
	cvHnSGod = CreateConVar("sm_cmenu_hns_godmode", "1", "Makes CT's invulnerable against attacks from T's during HnS to prevent rebels.\n0 = Disable. 1 = Enable.", _, true, 0.0, true, 1.0);
	cvHnSTimes = CreateConVar("sm_cmenu_hns_rounds", "2", "How many times is HnS allowed per map?\nSet to 0 for unlimited.");
	cvFreeday = CreateConVar("sm_cmenu_freeday", "1", "Add an option for a freeday in the menu?\n0 = Disable. 1 = Enable.", _, true, 0.0, true, 1.0);
	cvFreedayTimes = CreateConVar("sm_cmenu_freeday_rounds", "2", "How many times is a Freeday allowed per map?\nSet to 0 for unlimited.");
	cvWarday = CreateConVar("sm_cmenu_warday", "1", "Add an option for Warday in the menu?\n0 = Disable. 1 = Enable.", _, true, 0.0, true, 1.0);
	cvWardayTimes = CreateConVar("sm_cmenu_warday_rounds", "1", "How many times is a Warday allowed per map?\nSet to 0 for unlimited.");
	
	RegAdminCmd("sm_abortgames", sm_abortgames, ADMFLAG_KICK);
	RegConsoleCmd("sm_cmenu", sm_cmenu);
	
	HookEvent("player_hurt", OnPlayerHurt);
	HookEvent("player_death", OnPlayerDeath);
	HookEvent("round_end", OnRoundEnd);
	
}

public void OnPlayerDeath(Event event, const char[] name, bool dontBroadcast) {
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if(EJBW_IsClientWarden(client)) {
		abortGames();
		CPrintToChatAll("%s %t", prefix, "Warden Died");
	}
}

public void OnPlayerHurt(Event event, const char[] name, bool dontBroadcast) {
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	
	if(hnsActive == 1 && GetClientTeam(client) == CS_TEAM_CT && cvHnSGod.IntValue == 1) {
		if(!IsFakeClient(attacker) && GetClientTeam(attacker) == CS_TEAM_T) {
			event.Cancel();
			CPrintToChat(attacker, "%s %t", prefix, "No Rebel HnS");
		}
	}
}

public void OnRoundEnd(Event event, const char[] name, bool dontBroadcast) {
	abortGames();
}

public void OnMapStart() {
	abortGames();
}

public Action sm_cmenu(int client, int args) {
	
	if(GetClientTeam(client) == CS_TEAM_CT) {
		if(IsPlayerAlive(client)) {
			if(EJBW_IsClientWarden(client)) {
				
				openMenu(client);
				
			} else {
				error(client, 0);
			}
		} else {
			error(client, 1);
		}
	} else {
		error(client, 2);
	}
	
	return Plugin_Handled;
}

public Action sm_abortgames(int client, int args) {
	
	if(IsGameActive) {
		CPrintToChatAll("%s %t", prefix, "Admin Aborted", client);
		abortGames();
	} else {
		CPrintToChat(client, "%s %t", prefix, "Admin Abort Denied");
	}
	
	return Plugin_Handled;
}

public void openMenu(int client) {
	Menu menu = new Menu(MenuHandler1, MENU_ACTIONS_ALL);
	
	char title[64];
	Format(title, sizeof(title), "%t", "Menu Title");
	
	menu.SetTitle(title);
	if(cvFreeday.IntValue == 1) {
		menu.AddItem(CHOICE1, "Choice 1");
	}
	if(cvHnS.IntValue == 1) {
		menu.AddItem(CHOICE2, "Choice 2");
	}
	if(cvWarday.IntValue == 1) {
		menu.AddItem(CHOICE3, "Choice 3");
	}
	menu.AddItem(CHOICE4, "Choice 4");
	menu.Display(client, 20);
}

public int MenuHandler1(Menu menu, MenuAction action, int client, int param2) {
	switch(action) {
		case MenuAction_Start:
		{
			// Displaying menu to client
		}
		case MenuAction_Display:
		{
			char buffer[255];
			Format(buffer, sizeof(buffer), "%t", "Menu Title");
			Panel panel = view_as<Panel>(param2);
			panel.SetTitle(buffer);
		}
		case MenuAction_Select:
		{
			char info[32];
			menu.GetItem(param2, info, sizeof(info));
			if(!IsGameActive) {
				if(StrEqual(info, CHOICE1)) {
					initFreeday(client);
				}
				if(StrEqual(info, CHOICE2)) {
					initHns(client);
				}
				if(StrEqual(info, CHOICE3)) {
					initWarday(client);
				}
			} else {
				if(StrEqual(info, CHOICE4)) {
					abortGames();
				} else if(StrEqual(info, CHOICE1) || StrEqual(info, CHOICE2) || StrEqual(info, CHOICE3)) {
					CPrintToChat(client, "%s %t", prefix, "Cannot Exec Game");
				}
			}
		}
		case MenuAction_End:
		{
			delete menu;
		}
		case MenuAction_DrawItem:
		{
			int style;
			char info[32];
			menu.GetItem(param2, info, sizeof(info), style);
			
			// Disable all if a game is active!
			if(IsGameActive) {
				if(StrEqual(info, CHOICE1)) {
					return ITEMDRAW_DISABLED;
				} else if(StrEqual(info, CHOICE2)) {
					return ITEMDRAW_DISABLED;
				} else if(StrEqual(info, CHOICE3)) {
					return ITEMDRAW_DISABLED;
				} else if(StrEqual(info, CHOICE4)) {
					return ITEMDRAW_DEFAULT;
				} else {
					return style;
				}
			} else {
				if(StrEqual(info, CHOICE4)) {
					return ITEMDRAW_DISABLED;
				} else {
					return style;
				}
			}
		}
		case MenuAction_DisplayItem:
		{
			char info[32];
			menu.GetItem(param2, info, sizeof(info));
			
			char display[64];
			
			if(StrEqual(info, CHOICE1)) {
				Format(display, sizeof(display), "%t", "Choice 1");
				return RedrawMenuItem(display);
			}
			if(StrEqual(info, CHOICE2)) {
				Format(display, sizeof(display), "%t", "Choice 2");
				return RedrawMenuItem(display);
			}
			if(StrEqual(info, CHOICE3)) {
				Format(display, sizeof(display), "%t", "Choice 3");
				return RedrawMenuItem(display);
			}
			if(StrEqual(info, CHOICE4)) {
				Format(display, sizeof(display), "%t", "Choice 4");
				return RedrawMenuItem(display);
			}
		}
	}
	
	return 0;
}

public void abortGames() {
	if(IsGameActive) {
		// Reset
		IsGameActive = false;
		hnsActive = 0;
		wardayActive = 0;
		freedayActive = 0;
	}
}

public void initHns(int client) {
	if(cvHnSTimes.IntValue == 0) {
		PrintHintTextToAll("%t", "HnS Begun");
		hnsActive = 1;
		IsGameActive = true;
	} else if(cvHnSTimes.IntValue != 0 && hnsTimes >= cvHnSTimes.IntValue) {
		
		CPrintToChat(client, "%s %t", prefix, "Too many hns", hnsTimes, cvHnSTimes.IntValue);
		
	} else if(cvHnSTimes.IntValue != 0 && hnsTimes < cvHnSTimes.IntValue) {
		PrintHintTextToAll("%t", "HnS Begun");
		hnsActive = 1;
		IsGameActive = true;
		hnsTimes++;
	}
}

public void initFreeday(int client) {
	
	/*
	* What to do to the server here??
	*/
	
	if(cvFreedayTimes.IntValue == 0) {
		PrintHintTextToAll("%t", "Freeday Begun");
		freedayActive = 1;
		IsGameActive = true;
	} else if(cvFreedayTimes.IntValue != 0 && freedayTimes >= cvFreedayTimes.IntValue) {
		CPrintToChat(client, "%s %t", prefix, "Too many freedays", freedayTimes, cvFreedayTimes.IntValue);
	} else if(cvFreedayTimes.IntValue != 0 && freedayTimes < cvFreedayTimes.IntValue) {
		PrintHintTextToAll("%t", "Freeday Begun");
		freedayActive = 1;
		IsGameActive = true;
		freedayTimes++;
	}
}

public void initWarday(int client) {
	
	/*
	* Same here. Anything to do to the server?
	*/
	
	if(cvWardayTimes.IntValue == 0) {
		PrintHintTextToAll("%t", "Warday Begun");
		wardayActive = 1;
		IsGameActive = true;
	} else if(cvWardayTimes.IntValue != 0 && warTimes >= cvWardayTimes.IntValue) {
		CPrintToChat(client, "%s %t", "Too many wardays", warTimes, cvWardayTimes.IntValue);
	} else if(cvWardayTimes.IntValue != 0 && warTimes < cvWardayTimes.IntValue) {
		PrintHintTextToAll("%t", "Warday Begun");
		wardayActive = 1;
		IsGameActive = true;
		warTimes++;
	}
	
}

public void error(int client, int errorCode) {
	if(errorCode == 0) {
		CPrintToChat(client, "%s %t", prefix, "Not Warden");
	}
	if(errorCode == 1) {
		CPrintToChat(client, "%s %t", prefix, "Not Alive");
	}
	if(errorCode == 2) {
		CPrintToChat(client, "%s %t", prefix, "Not CT");
	}
}