/*--------------------------------------------------------------------------------------------------

	SYSTEM SETTINGS

--------------------------------------------------------------------------------------------------*/
#define REVIVE_SIDES			[WEST,EAST,RESISTANCE,CIVILIAN]
#define REVIVE_SIDES_TXT		["West","East","Guer","Civ"]
#define REVIVE_DISTANCE			4
#define REVIVE_DISTANCE_BODY_CENTER	2.5

//behavior settings
#define REVIVE_MEDIKIT_MULTIPLIER	2		//multiplier acting on revive time if the player has a medikit
#define DEFAULT_REVIVE_TIME		6		//default time (in seconds) that it takes to revive a unit
#define DEFAULT_FORCE_RESPAWN_TIME	3		//default time (in seconds) that it takes to force respawn
#define DEFAULT_BLEEDOUT_TIME		1200		//default time (in seconds) that it takes to bleed out

//misc
#define BLOCKED_ACTIONS			["Throw","DeployWeaponManual","DeployWeaponAuto"]

//animations
#define ANIM_WOUNDED			"acts_injuredlyingrifle02_180"
#define ANIM_OK				"amovppnemstpsnonwnondnon"

#define KEY_ACTION_NONE			0
#define KEY_ACTION_START_REVIVE		1
#define KEY_ACTION_CANCEL_REVIVE	2
#define KEY_ACTION_START_RESPAWN	3
#define KEY_ACTION_CANCEL_RESPAWN	4

/*--------------------------------------------------------------------------------------------------

	INIT MODES

--------------------------------------------------------------------------------------------------*/
#define REVIVE_MODE_AUTODETECT			-1	//Revive2 compatability solution
#define REVIVE_MODE_DISABLED			0
#define REVIVE_MODE_ENABLED_ALL_PLAYERS		1
#define REVIVE_MODE_ENABLED_INDIVIDUAL_PLAYERS	2

/*--------------------------------------------------------------------------------------------------

	PLAYER VARIABLE NAMES

--------------------------------------------------------------------------------------------------*/
//unit variable names
#define VAR_REVIVE_ENABLED		"#rev_enabled"

//broadcasted unit variables
#define VAR_TRANSFER_STATE		"#rev"
#define VAR_TRANSFER_FORCING_RESPAWN	"#revF"
#define VAR_TRANSFER_BEING_REVIVED	"#revB"
#define VAR_BLOOD_LEVEL			"#revL"

//local unit variables
#define VAR_STATE			"#rev_state"
#define VAR_STATE_PREV			"#rev_statePrev"

#define VAR_BEING_REVIVED		"#rev_being_revived"
#define VAR_FORCING_RESPAWN		"#rev_forcing_respawn"

#define VAR_DAMAGE			"#rev_damage"
#define VAR_BLOOD			"#rev_blood"
#define VAR_ACTION_ID_REVIVE		"#rev_actionID_revive"
#define VAR_ACTION_ID_RESPAWN		"#rev_actionID_respawn"

#define VAR_CAMERA_VIEW			"#rev_camera"
#define VAR_ICON_SCRIPT			"#rev_iconScript"
#define VAR_ICON_POS			"#rev_iconPos"

#define VAR_INCAPACITATED_POS		"#rev_incap_pos"
#define VAR_INCAPACITATED_BACKUPPOS	"#rev_incap_backuppos"
#define VAR_INCAPACITATED_DIR		"#rev_incap_dir"
#define VAR_INCAPACITATED_BODY		"#rev_incap_corpse"

/*--------------------------------------------------------------------------------------------------

	GENERAL 'QUALITY OF LIFE' MACROS

--------------------------------------------------------------------------------------------------*/
#define GET_UNIT_VAR(unit)		([unit] call bis_fnc_objectVar)
#define GET_UNIT(unitVar)		(missionNamespace getVariable [unitVar,objNull])

#define IN_VEHICLE(unit)		(vehicle unit != unit)

#define ENABLE_REVIVE(unit,state)	(unit setVariable [VAR_REVIVE_ENABLED, state, true])
#define REVIVE_ENABLED(unit)		(unit getVariable [VAR_REVIVE_ENABLED, false])
#define REVIVE_ALLOWED(unit)		([unit] call bis_fnc_reviveAllowed)
#define IS_MP				isMultiplayer

/*--------------------------------------------------------------------------------------------------

	REQUIREMENTS

--------------------------------------------------------------------------------------------------*/
#define VAR_REQUIRED_SPECIALTY		"#rev_required_specialty"
#define VAR_REQUIRED_ITEMS		"#rev_required_items"

#define SET_REQUIRED_ITEMS(mode)	missionNamespace setVariable [VAR_REQUIRED_ITEMS, mode];
#define SET_REQUIRED_SPECIALTY(mode)	missionNamespace setVariable [VAR_REQUIRED_SPECIALTY, mode];

#define GET_REQUIRED_ITEMS		missionNamespace getVariable [VAR_REQUIRED_ITEMS, 0];
#define GET_REQUIRED_SPECIALTY		missionNamespace getVariable [VAR_REQUIRED_SPECIALTY, 0];

/*--------------------------------------------------------------------------------------------------

	PLAYER ACTION FLAGS

--------------------------------------------------------------------------------------------------*/
#define IS_BEING_REVIVED(unit)			(unit getVariable [VAR_BEING_REVIVED, false])
#define IS_FORCING_RESPAWN(unit)		(unit getVariable [VAR_FORCING_RESPAWN, false])

#define SET_BEING_REVIVED(unit,state)		["",state,unit] call bis_fnc_reviveOnBeingRevived;unit setVariable [VAR_TRANSFER_BEING_REVIVED, state, true]
#define SET_FORCING_RESPAWN(unit,state)		["",state,unit] call bis_fnc_reviveOnForcingRespawn;unit setVariable [VAR_TRANSFER_FORCING_RESPAWN, state, true]

#define SET_BEING_REVIVED_LOCAL(unit,state)	["",state,unit] call bis_fnc_reviveOnBeingRevived;unit setVariable [VAR_TRANSFER_BEING_REVIVED, state]
#define SET_FORCING_RESPAWN_LOCAL(unit,state)	["",state,unit] call bis_fnc_reviveOnForcingRespawn;unit setVariable [VAR_TRANSFER_FORCING_RESPAWN, state]

/*--------------------------------------------------------------------------------------------------

	PLAYER STATES

--------------------------------------------------------------------------------------------------*/
#define STATE_RESPAWNED			0
#define STATE_REVIVED			1
#define STATE_INCAPACITATED		2
#define STATE_DEAD			3

#define GET_STATE_STR(state)		format["%1(%2)",["RESPAWNED","REVIVED","INCAPACITATED","DEAD"] select state,state]

#define SET_STATE(unit,state)		["",state,unit] call bis_fnc_reviveOnState;unit setVariable [VAR_TRANSFER_STATE, state, true]
#define SET_STATE_LOCAL(unit,state)	["",state,unit] call bis_fnc_reviveOnState;unit setVariable [VAR_TRANSFER_STATE, state]
#define GET_STATE(unit)			(unit getVariable [VAR_STATE, STATE_RESPAWNED])
#define IS_DISABLED(unit)		(GET_STATE(unit) == STATE_INCAPACITATED)
#define IS_ACTIVE(unit)			(GET_STATE(unit) < STATE_INCAPACITATED)

/*--------------------------------------------------------------------------------------------------

	ICON STATES

--------------------------------------------------------------------------------------------------*/
#define ICON_STATE_ADD			-1
#define ICON_STATE_REMOVE		-2
#define ICON_STATE_FORCING_RESPAWN	-3
#define ICON_STATE_BEING_REVIVED	-4

#define ICON_STATE_INCAPACITATED	STATE_INCAPACITATED
#define ICON_STATE_DEAD			STATE_DEAD

/*--------------------------------------------------------------------------------------------------

	DAMAGE MODEL

--------------------------------------------------------------------------------------------------*/
#define RATIO_LETHAL					bis_revive_ratioLethal
#define RATIO_SOFT					bis_revive_ratioSoft
#define SELECTION_DAMAGE				bis_revive_dmgPerSelection

#define UNCONSCIOUS_MODES				["Basic","Advanced","Realistic"]

#define GET_RATIO_LETHAL(selection)			(RATIO_LETHAL getVariable [selection, 0])
#define SET_RATIO_LETHAL(selection,value)		(RATIO_LETHAL setVariable [selection, value])

#define GET_RATIO_SOFT(selection)			(RATIO_SOFT getVariable [selection, 0])
#define SET_RATIO_SOFT(selection,value)			(RATIO_SOFT setVariable [selection, value])

#define GET_SELECTION_DAMAGE(selection)			(SELECTION_DAMAGE getVariable [selection, 0])
#define SET_SELECTION_DAMAGE(selection,value)		(SELECTION_DAMAGE setVariable [selection, value])

#define MAX_SAFE_DAMAGE					0.95
#define SOFT_DAMAGE_BOOST				0.3		//how much each hit soft damage is enhanced

/*--------------------------------------------------------------------------------------------------

	HOLD ACTION AND 3D ICON TEXTURES

--------------------------------------------------------------------------------------------------*/
#define TEMPLATE_2D(id)			(format["<img size='3.0' shadow='0' color='#ffffff' image='\A3\Ui_f\data\IGUI\Cfg\Revive\overlayIcons\%1_ca.paa'/>",id])
#define TEMPLATE_3D(id)			(format["\A3\Ui_f\data\IGUI\Cfg\Revive\overlayIcons\%1_ca.paa",id])
#define TEMPLATE_3D_GROUP(id)		(format["\A3\Ui_f\data\IGUI\Cfg\Revive\overlayIconsGroup\%1_ca.paa",id])

#define SEQUENCE12_DYING		["u100","u75","u50","d50","d75","d100","d100","d75","d50","u50","u75","u100"]
#define SEQUENCE12_BEING_REVIVED	["u100","u75","u50","r50","r75","r100","r100","r75","r50","u50","u75","u100"]
#define SEQUENCE12_UNCONSCIOUS		["u100","u100","u100","u100","u100","u100","u100","u100","u100","u100","u100","u100"]
#define SEQUENCE12_DEAD			["d100","d100","d100","d100","d100","d100","d100","d100","d100","d100","d100","d100"]
#define SEQUENCE12_FORCING_RESPAWN	["u100","u75","u50","f50","f75","f100","f100","f75","f50","u50","u75","u100"]

#define TEXTURES_2D_DYING		bis_reviveTextures2d_dying
#define TEXTURES_2D_BEING_REVIVED	bis_reviveTextures2d_beingRevived
#define TEXTURES_2D_UNCONSCIOUS		bis_reviveTextures2d_unconscious

#define TEXTURES_3D_DYING		bis_reviveTextures3d_dying
#define TEXTURES_3D_BEING_REVIVED	bis_reviveTextures3d_beingRevived
#define TEXTURES_3D_UNCONSCIOUS		bis_reviveTextures3d_unconscious
#define TEXTURES_3D_DEAD		bis_reviveTextures3d_dead
#define TEXTURES_3D_FORCING_RESPAWN	bis_reviveTextures3d_forcingRespawn

#define TEXTURES_3D_GROUP_DYING			bis_reviveTextures3dGroup_dying
#define TEXTURES_3D_GROUP_BEING_REVIVED		bis_reviveTextures3dGroup_beingRevived
#define TEXTURES_3D_GROUP_UNCONSCIOUS		bis_reviveTextures3dGroup_unconscious
#define TEXTURES_3D_GROUP_DEAD			bis_reviveTextures3dGroup_dead
#define TEXTURES_3D_GROUP_FORCING_RESPAWN	bis_reviveTextures3dGroup_forcingRespawn

/*--------------------------------------------------------------------------------------------------

	ICON SETTINGS

--------------------------------------------------------------------------------------------------*/
//icon values
#define ICON_USERACTION_REVIVE		"\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa"			//todo: create new icon, based on heal icon
#define ICON_USERACTION_REVIVE_MEDIC	"\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_reviveMedic_ca.paa"		//todo: create new icon, based on heal icon & add "+" sign
#define ICON_USERACTION_RESPAWN		"\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_forceRespawn_ca.paa"		//todo: create suicide icon

#define ICON_VISIBLE_RANGE 		150		//up to this range icon is at full alpha
#define ICON_VISIBLE_RANGE_MAX 		175		//behind this range icon is not visible
#define ICON_SIZE			1.3
#define ICON_ALPHA			0.85

#define VAR_ICON_COLOR			"#rev_icon_color"
#define VAR_ICON_IS_ACTIVE		"#rev_icon_isActive"		//used in draw frame code to determine visualization and drawing of side arrows
#define VAR_ICON_IN_GROUP		"#rev_icon_inGroup"		//used in draw frame code to determine if unit is in teh same group as player

#define ICON_COLOR_ACTIVE		[1,0.3,0.3,ICON_ALPHA]
#define ICON_COLOR_DISABLED		[0.9,0.9,0.9,ICON_ALPHA]