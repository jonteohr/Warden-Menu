/*
* 
* INCLUCE FOR THE SOURCEMOD PLUGIN; WARDEN MENU
* https://forums.alliedmods.net/showthread.php?t=298907
* 
*/
#if defined cmenuincluded
 #endinput
#endif
#define cmenuincluded

/**
* Called when client opens the menu.
*
* @param client
*/
forward void OnCMenuOpened(int client);

/**
* Called when an event day is created.
*/
forward void OnEventDayCreated();

/**
* Called when an event day is aborted.
*/
forward void OnEventDayAborted();

/**
* Check if there is a event day currently active.
* 
* @return	true if yes
*/
native bool IsEventDayActive();

/**
* Check if a Hide and Seek game is running.
*
* @return	true if yes
*/
native bool IsHnsActive();

/**
* Check if a Gravity Freeday is running.
*
* @return	true if yes
*/
native bool IsGravFreedayActive();

/**
* Check if a warday is running.
*
* @return	true if yes
*/
native bool IsWarActive();

/**
* Check if a freeday is running.
*
* @return	true if yes
*/
native bool IsFreedayActive();