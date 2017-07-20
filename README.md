# Warden-Menu [![Build Status](https://travis-ci.org/condolent/Warden-Menu.svg?branch=master)](https://travis-ci.org/condolent/Warden-Menu)
Sourcemod plugin for Jailbreak servers. Giving wardens a special menu to execute games with specific game-rules.  
[AlliedModders](https://forums.alliedmods.net/showthread.php?t=298907)

## Description
This plugin works great for jailbreak servers on CS:GO where the current warden can open up a menu. This menu gives the warden access to round-specific commands/variables that create funny games for all the players!

## Installation
Download and drop all the contents in /addons/sourcemod/ into your /csgo/addons/sourcemod/ folder.  
Type `sm plugins load cmenu` in the server console and you're done!

## Dependencies
This plugin currently only works with [ESK0s Jailbreak Warden](https://forums.alliedmods.net/showthread.php?t=278136) plugin.  
Make a request and I'll implement other warden plugins aswell.  
If you have `sm_cmenu_doors` set to `1` then you will also need [Smart Jail Doors](https://forums.alliedmods.net/showthread.php?p=2306018#post2306018).

## Features
The major function this plugin offers is that the warden can choose a special day to play out for the round. Each day has some special server rules that applies in order to make it much more fun for the players!  
1. Hide and Seek
2. Freeday
3. Warday
4. Gravity Freeday

There's also some other functions in the menu that the warden can take advantage of in order to make the game more comfortable.  
Some of the other entries in the menu include:  
1. Toggle noblock
2. Weapons menu, allowing the warden to spawn in the selected weapon to himself
3. Give a specific player(s) freeday, marked with beacons

## CVars
| ConVar      | Default | Description   |
|:----------- |:-------:|:------------- |
|`sm_cmenu_hns`|**1**|Add an option for Hide and Seek in the menu? 0 = Disable. 1 = Enable.|
|`sm_cmenu_hns_godmode`|**1**|Makes CT's invulnerable against attacks from T's during HnS to prevent rebels. 0 = Disable. 1 = Enable.|
|`sm_cmenu_hns_rounds`|**2**|How many times is HnS allowed per map? Set to 0 for unlimited.|
|`sm_cmenu_freeday`|**1**|Add an option for a freeday in the menu? 0 = Disable. 1 = Enable.|
|`sm_cmenu_freeday_rounds`|**2**|How many times is a Freeday allowed per map? Set to 0 for unlimited.|
|`sm_cmenu_warday`|**1**|Add an option for Warday in the menu? 0 = Disable. 1 = Enable.|
|`sm_cmenu_warday_rounds`|**2**|How many times is a Warday allowed per map?\nSet to 0 for unlimited.|
|`sm_cmenu_gravity`|**1**|Add an option for a gravity freeday in the menu? 0 = Disable. 1 = Enable.|
|`sm_cmenu_gravity_team`|**2**|Which team should get a special gravity on Gravity Freedays? 0 = All teams. 1 = Counter-Terrorists 2 = Terorrists.|
|`sm_cmenu_gravity_strength`|**0.5**|What should the gravity be set to on Gravity Freedays?|
|`sm_cmenu_gravity_rounds`|**1**|How many times is a Gravity Freeday allowed per map?\nSet to 0 for unlimited.|
|`sm_cmenu_noblock`|**1**|Add an option for toggling noblock in the menu? 0 = Disable. 1 = Enable.|
|`sm_cmenu_noblock_standard`|**1**|What should the noblock rules be as default on start of each round? This should have the same value as your mp_solid_teammates cvar in server.cfg. 1 = Solid teammates. 0 = No block|
|`sm_cmenu_auto_open`|**1**|Automatically open the menu when a user becomes warden? 0 = Disable. 1 = Enable.|
|`sm_cmenu_weapons`|**1**|Add an option for giving the warden a list of weapons via the menu? 0 = Disable. 1 = Enable.|
|`sm_cmenu_restricted_freeday`|**1**|Add an option for a restricted freeday in the menu? This event uses the same configuration as a normal freeday. 0 = Disable. 1 = Enable.|
|`sm_cmenu_player_freeday`|**1**|Add an option for giving a specific player a freeday in the menu? 0 = Disable. 1 = Enable.|
|`sm_cmenu_doors`|**1**|Add an option for opening doors via the menu. 0 = Disable. 1 = Enable|

## Commands
| Command   | Description   | Flag     |
|:--------- |:------------- |:-------- |
|sm_cmenu   | _Opens up the warden menu._| - |
|sm_wmenu   | _Same as above command_| - |
|sm_noblock | _Toggles noblock_        | - |
|sm_days    | _Opens the days menu_    | - |
|sm_open    | _Toggles the cell doors_ | - |
|sm_abortgames | _Cancels the current game._| b |

## Translate
Want to help translate?  
Send me a message on [Steam](https://steamcommunity.com/id/hyprcsgo) or create an [Issue](https://github.com/condolent/Warden-Menu/issues).

## API for Developers
**Natives**
```
/*
* 
* INCLUDE FOR THE SOURCEMOD PLUGIN; WARDEN MENU
* https://forums.alliedmods.net/showthread.php?t=298907
* 
*/
#if defined cmenuincluded
 #endinput
#endif
#define cmenuincluded

/**
* Check if there is a event day currently active.
* 
* @return     true if yes
*/
native bool IsEventDayActive();

/**
* Check if a Hide and Seek game is running.
*
* @return     true if yes
*/
native bool IsHnsActive();

/**
* Check if a Gravity Freeday is running.
*
* @return     true if yes
*/
native bool IsGravFreedayActive();

/**
* Check if a warday is running.
*
* @return     true if yes
*/
native bool IsWarActive();

/**
* Check if a freeday is running.
*
* @return     true if yes
*/
native bool IsFreedayActive();

/**
* Check if the specified client already has a freeday.
*
* @param     client index
* @return     true if yes
*/
native bool ClientHasFreeday(int client);

/**
* Give a client a freeday
*
* @param      client index
* @return     true if successful
*/
native bool GiveClientFreeday(int client);

/*
* Remove a client's freeday
*
* @param      client index
* @param      set a beacon
* @return     true if successful
*/
native bool RemoveClientFreeday(int client, bool beacon);
```
**Forwards**
```
forward OnCMenuOpened(int client)
   - Called when a warden opens the warden menu. Also called when a player becomes a warden if sm_cmenu_auto_open is set to 1.

forward OnEventDayCreated()
   - Called when an event day is created.

forward OnEventDayAborted()
   - Called when an event day is aborted.

forward OnHnsOver()
   - Called when Hide and Seek is won.
```

## Todo
_Currently nothing planned. Maybe a few more event days!_
