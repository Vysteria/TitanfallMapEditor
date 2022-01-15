// TODO:
// Model tracking and save/Clear functions are temp. We already update the client knowledge of loadouts. Derive from that.
// Move the struct off the player?

#if CLIENT && MP
	untyped
#endif //client && MP

#if CLIENT
	const float CARD_TAG_SCALE = 0.0 // update to match same const in hud_defs.rui

	const DEFAULT_FOV = 50.0
	const DEFAULT_DOF_NEAR_START = 7.5
	const DEFAULT_DOF_NEAR_END = 7.7
	const DEFAULT_DOF_FAR_START = 200.0
	const DEFAULT_DOF_FAR_END = 300.0
	const TRANSITION_DURATION = 0.25

	const DEFAULT_MAX_TURN_SPEED = 270.0
	const PILOT_MAX_TURN_SPEED = 270.0
	const TITAN_MAX_TURN_SPEED = 100.0

	const MENU_COLOR_CORRECTION = "materials/correction/menu.raw"
	const MENU_TEST_EFFECT = $"P_menu_motes"

	const vector WEAPON_DLIGHT_COLOR = <0.65, 0.75, 1.0>

	global struct MenuCharacterDef
	{
		asset bodyModel = $""
		int camoIndex = -1
		int skinIndex = 0
		int decalIndex = -1
		int loadoutIndex = 0
		string idleAnim

		string weapon
		array<string> mods
		asset weaponModel = $""
		int weaponCamoIndex = -1
		int weaponSkinIndex = -1

		int showArmBadge = 0
		asset armBadgeModel = $""
		int armBadgeBodyGroupIndex = 0
		bool isPrime = false
	}

	struct CharacterData
	{
		entity mover
		entity body
		entity weapon
		entity prop
		entity armBadge
		string attachName
		string bodyAnim
		float[2] rotationDelta
		float fovScale = 1.0
		float maxTurnSpeed = DEFAULT_MAX_TURN_SPEED
	}

	struct PresentationDef
	{
		CharacterData ornull characterData = null
		float maxTurnDegrees = 360.0
		float maxPitchDegrees = 0.0
		bool useRollAxis = true
		string sceneAnim

		float fov = DEFAULT_FOV
		float dofNearStart = DEFAULT_DOF_NEAR_START
		float dofNearEnd = DEFAULT_DOF_NEAR_END
		float dofFarStart = DEFAULT_DOF_FAR_START
		float dofFarEnd = DEFAULT_DOF_FAR_END

		float csmTexelScale1 = 1.0
		float csmTexelScale2 = 1.0
		float csmStartDistance = 0.0

		string pilotAnimType
		string titanAnimType

		bool showCallsign = false
		bool showStoreBG = false
		bool showStorePrimeBG = false
		bool showMiscModel = false
		bool showWeaponModel = false
		bool showTitanModel = true // false would be a better default, but the hiding/showing of this stuff needs be done in a more general/flexible way, so leaving this for now

		void functionref() activateFunc
	}

	struct
	{
		entity sceneRef
		entity cameraTarget
		float[2] mouseRotateDelta

		CharacterData menuPilot
		CharacterData menuTitan
		CharacterData menuFaction
		CharacterData menuMiscModel
		CharacterData menuWeaponModel
		CharacterData ornull activeCharacter = null
		var menuCallsignRui
		var menuCallsignTopo
		var menuStoreBackground
		var menuStorePrimeBg
		var menuStorePrimeBgRui
		var menuStorePrimeBgCreated

		entity weaponDLight

		float lastZoomTime

		int presentationType = ePresentationType.INACTIVE
		bool presentationTypeInitialized = false
		PresentationDef[ePresentationType.COUNT] presentationData

		table< string, table<string, table<int,string> > > pilotAnims
		table< string, table<string, string> > titanAnims

		int menuColorCorrection = -1
	} file

	global function MenuModels_Init
	global function MenuMapEntitiesExist
#endif //CLIENT

#if CLIENT && MP
	global function SetPresentationType

	global function UpdatePilotModel
	global function UpdateTitanModel
	global function UpdateFactionModel
	global function UpdateBoostModel
	global function UpdateStoreBackground
	global function UpdateStorePrimeBg
	global function UpdateCallsignCard
	global function UpdateCallsignIcon
	global function UpdateCallsign

	global function SetEditingPilotLoadoutIndex
	global function ClearEditingPilotLoadoutIndex

	global function SetHeldPilotWeaponType

	global function SetEditingTitanLoadoutIndex
	global function ClearEditingTitanLoadoutIndex

	global function PreviewPilotCharacter
	global function SavePilotCharacterPreview
	global function PreviewPilotWeapon
	global function SavePilotWeaponPreview
	global function PreviewPilotWeaponCamoChange
	global function PreviewPilotWeaponSkinChange
	global function ClearAllPilotPreview

    global function PreviewPilotWeaponMod
    global function SavePilotWeaponModPreview

	global function PreviewPilotCamoChange
	//global function SavePilotCamoPreview

	global function PreviewTitanCamoChange
	global function SaveTitanCamoPreview
	global function ClearTitanCamoPreview

	global function PreviewTitanSkinChange
	global function SaveTitanSkinPreview
	global function ClearTitanSkinPreview

	global function PreviewTitanDecalChange
	global function SaveTitanDecalPreview
	global function ClearTitanDecalPreview

	global function PreviewTitanCombinedChange
	global function SaveTitanCombinedPreview
	global function ClearTitanCombinedPreview

	global function PreviewTitanWeaponCamoChange
	global function ClearAllTitanPreview

	global function SetMenuOpenState

	// Only these 2 functions are run from the server and they may not be needed. Remove server updates if possible.
	global function ServerCallback_UpdatePilotModel
	global function ServerCallback_UpdateTitanModel

	global function GetMenuPilotBody
	global function GetCallsignTopo

	global function GetFactionModel
	global function GetFactionModelSkin

	global function UpdateStoreWeaponModelSkin
	global function UpdateStoreWeaponModelZoom

	global function UpdateMouseRotateDelta

	global function GetMenuMiscModel // TODO: Remove when done testing

	global function UpdateMenuToHarvester

	global function GetDLightEntity
#endif // CLIENT && MP

#if UI
	const MOUSE_ROTATE_MULTIPLIER = 25.0

	global function UpdateUIMapSupportsMenuModels
	global function RunMenuClientFunction
	global function UI_SetPresentationType

	global function UICodeCallback_MouseMovementCapture
#endif // UI

	global const STORE_BG_DEFAULT = 0
	global const STORE_BG_BUNDLE1 = 1
	global const STORE_BG_BUNDLE2 = 2
	global const STORE_BG_BUNDLE3 = 3
	global const STORE_BG_BUNDLE4 = 4
	global const STORE_BG_BUNDLE5 = 5
	global const STORE_BG_BUNDLE6 = 6

#if CLIENT

	var function GetCallsignTopo()
	{
		return file.menuCallsignTopo
	}

	entity function GetMenuPilotBody()
	{
		return file.menuPilot.body
	}

    void function MenuModels_Init()
    {
	    if ( IsMultiplayer() && MenuMapEntitiesExist() )
		    clGlobal.mapSupportsMenuModels = true

	    RunUIScript( "UpdateUIMapSupportsMenuModels", clGlobal.mapSupportsMenuModels )

	    if ( !clGlobal.mapSupportsMenuModels )
		    return

		#if MP
			PrecacheParticleSystem( MENU_TEST_EFFECT )
			file.menuColorCorrection = ColorCorrection_Register( MENU_COLOR_CORRECTION )

			InitPresentationData()
			InitMenuModelAnims()
			thread InitMenuEntities( GetLocalClientPlayer() )
			thread ModelRotationThread()
			AddCallback_OnClientScriptInit( OnClientScriptInit )
		#endif // MP

		RegisterSignal( "UpdateCallsign" )
    }

	bool function MenuMapEntitiesExist()
	{
		array<string> entNames =
		[
			"menu_scene_ref",
			"menu_camera_target"
		]

		foreach ( name in entNames )
		{
			if ( GetEntArrayByScriptName( name ).len() != 1 )
				return false
		}

		return true
	}
#endif // CLIENT

#if UI
	void function UpdateUIMapSupportsMenuModels( bool value )
	{
		uiGlobal.mapSupportsMenuModels = value
		uiGlobal.mapSupportsMenuModelsUpdated = true

		printt( Time(), "uiGlobal.mapSupportsMenuModelsUpdated set to: true" )
	}
#endif // UI

#if CLIENT && MP
	void function InitPresentationData()
	{
		// TODO: Rework so scenes can be defined in a more flexible way (what entities get created, shown, hidden, animated)
		// TODO: Need anims happening a bit differently for transition support
		// Interruptable function that plays intro anim and then idle if intro completes uninterrupted
		// Outro anims should work the same

		int presentationType = ePresentationType.INACTIVE
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_main_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "main_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels

		presentationType = ePresentationType.DEFAULT
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_main_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "main_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Show spawn models
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.22
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 70.0
		file.presentationData[ presentationType ].showCallsign 		= true

		presentationType = ePresentationType.STORE_CAMO_PACKS
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_main_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "main_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Show spawn models
		file.presentationData[ presentationType ].dofFarStart 		= 200.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.22
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 70.0

		presentationType = ePresentationType.STORE_FRONT
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_settings_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "main_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].dofFarStart 		= 2300.0
		file.presentationData[ presentationType ].dofFarEnd 		= 3000.0
		file.presentationData[ presentationType ].showStoreBG 		= true

		presentationType = ePresentationType.STORE_PRIME_TITANS
		file.presentationData[ presentationType ].characterData 	= file.menuTitan
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_loadout_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].dofFarStart 		= 4000.0
		file.presentationData[ presentationType ].dofFarEnd 		= 5000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0
		file.presentationData[ presentationType ].showStorePrimeBG 	= true

		presentationType = ePresentationType.STORE_WEAPON_SKINS
		file.presentationData[ presentationType ].characterData 	= file.menuWeaponModel
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_weapon_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "main_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].maxPitchDegrees 	= 90
		file.presentationData[ presentationType ].dofFarStart 		= 4000.0
		file.presentationData[ presentationType ].dofFarEnd 		= 5000.0
		file.presentationData[ presentationType ].showWeaponModel 	= true
		file.presentationData[ presentationType ].showTitanModel 	= false
		//file.presentationData[ presentationType ].useRollAxis 		= true

		presentationType = ePresentationType.SEARCH
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_main_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "main_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Show spawn models
		file.presentationData[ presentationType ].fov 				= DEFAULT_FOV + 10
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.22
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 70.0
		file.presentationData[ presentationType ].showCallsign 		= true

		presentationType = ePresentationType.CALLSIGN
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_main_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "main_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Show spawn models
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.22
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 70.0

		presentationType = ePresentationType.KNOWLEDGEBASE_MAIN
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_loadout_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "weapon_inspect_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels
		file.presentationData[ presentationType ].fov 				= DEFAULT_FOV - 25
		file.presentationData[ presentationType ].dofFarStart 		= 30.0
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.22
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 70.0

		presentationType = ePresentationType.KNOWLEDGEBASE_SUB
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_loadout_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "weapon_inspect_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels
		file.presentationData[ presentationType ].fov 				= DEFAULT_FOV - 28
		file.presentationData[ presentationType ].dofFarStart 		= 30.0
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.22
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 70.0

		presentationType = ePresentationType.PVE_MAIN
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_loadout_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "weapon_inspect_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels
		file.presentationData[ presentationType ].fov 				= DEFAULT_FOV - 25
		file.presentationData[ presentationType ].dofFarStart 		= 30.0
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.22
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 70.0

		presentationType = ePresentationType.PILOT
		file.presentationData[ presentationType ].characterData 	= file.menuPilot
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_loadout_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].dofFarStart 		= 200.0
		file.presentationData[ presentationType ].dofFarEnd 		= 300.0
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.4
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 70.0

		presentationType = ePresentationType.PILOT_LOADOUT_EDIT
		file.presentationData[ presentationType ].characterData 	= file.menuPilot
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_loadout_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels
		file.presentationData[ presentationType ].dofFarStart 		= 200.0
		file.presentationData[ presentationType ].dofFarEnd 		= 300.0
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.4
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 70.0

		presentationType = ePresentationType.PILOT_CHARACTER
		file.presentationData[ presentationType ].characterData 	= file.menuPilot
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_loadout_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].dofFarStart 		= 200.0
		file.presentationData[ presentationType ].dofFarEnd 		= 300.0
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.4
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 70.0

		presentationType = ePresentationType.PILOT_WEAPON
		file.presentationData[ presentationType ].characterData 	= file.menuPilot
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_loadout_edit_idle_01"
		file.presentationData[ presentationType ].pilotAnimType 	= "weapon_inspect_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.22
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 40.0

		presentationType = ePresentationType.TITAN
		file.presentationData[ presentationType ].characterData 	= file.menuTitan
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_loadout_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0

		presentationType = ePresentationType.TITAN_LOADOUT_EDIT
		file.presentationData[ presentationType ].characterData 	= file.menuTitan
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_loadout_edit"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "editing_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0

		presentationType = ePresentationType.TITAN_SKIN_EDIT
		file.presentationData[ presentationType ].characterData 	= file.menuTitan
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_loadout_edit"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "editing_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0

		presentationType = ePresentationType.TITAN_ARMBADGE
		file.presentationData[ presentationType ].characterData 	= file.menuTitan
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_loadout_edit"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "editing_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0

		presentationType = ePresentationType.TITAN_WEAPON
		file.presentationData[ presentationType ].characterData 	= file.menuTitan
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_loadout_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "editing_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0

		presentationType = ePresentationType.TITAN_NOSE_ART
		file.presentationData[ presentationType ].characterData 	= file.menuTitan
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_noseart_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "nose_art_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Titan animation change
		file.presentationData[ presentationType ].maxTurnDegrees 	= 100.0
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0

		presentationType = ePresentationType.NO_MODELS
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_settings_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "main_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change

		presentationType = ePresentationType.FACTIONS
		file.presentationData[ presentationType ].characterData 	= file.menuFaction
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_faction_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "main_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].csmTexelScale1 	= 0.4
		file.presentationData[ presentationType ].csmTexelScale2 	= 0.55
		file.presentationData[ presentationType ].csmStartDistance 	= 70.0

		presentationType = ePresentationType.BOOSTS
		file.presentationData[ presentationType ].characterData 	= file.menuMiscModel
		file.presentationData[ presentationType ].sceneAnim 		= "camera_menu_burncard_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "main_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "background_idle"
		file.presentationData[ presentationType ].showMiscModel 	= true

		presentationType = ePresentationType.TITAN_CENTER
		file.presentationData[ presentationType ].characterData 	= file.menuTitan
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_frontierdefense_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0

		presentationType = ePresentationType.TITAN_CENTER_SELECTED
		file.presentationData[ presentationType ].characterData 	= file.menuTitan
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_frontierdefense_idle_selected"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "editing_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels
		file.presentationData[ presentationType ].fov 				= DEFAULT_FOV - 10
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0

		presentationType = ePresentationType.TITAN_LEFT
		file.presentationData[ presentationType ].characterData 	= file.menuTitan
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_left_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0

		presentationType = ePresentationType.TITAN_RIGHT
		file.presentationData[ presentationType ].characterData 	= file.menuTitan
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_right_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0

		presentationType = ePresentationType.FD_MAIN
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_frontierdefense_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "hidden_from_main"
		file.presentationData[ presentationType ].titanAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0
		file.presentationData[ presentationType ].showCallsign 		= true
		file.presentationData[ presentationType ].showMiscModel 	= true

		presentationType = ePresentationType.FD_SEARCH
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_frontierdefense_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "hidden_from_main"
		file.presentationData[ presentationType ].titanAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].fov 				= DEFAULT_FOV + 10
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0
		file.presentationData[ presentationType ].showCallsign 		= true
		file.presentationData[ presentationType ].showMiscModel 	= true

		presentationType = ePresentationType.FD_FIND_GAME
		file.presentationData[ presentationType ].sceneAnim 		= "camera_titan_menu_loadout_idle"
		file.presentationData[ presentationType ].pilotAnimType 	= "background_idle"
		file.presentationData[ presentationType ].titanAnimType 	= "focused_idle"
		file.presentationData[ presentationType ].activateFunc 		= UpdateBothModels // Animation change
		file.presentationData[ presentationType ].fov 				= DEFAULT_FOV + 10
		file.presentationData[ presentationType ].dofFarStart 		= 500.0
		file.presentationData[ presentationType ].dofFarEnd 		= 1000.0
		file.presentationData[ presentationType ].csmStartDistance 	= 200.0
		file.presentationData[ presentationType ].showCallsign 		= true
		file.presentationData[ presentationType ].showMiscModel 	= true
	}

	void function UpdateBothModels()
	{
		entity player = GetLocalClientPlayer()

		int loadoutIndex
		if ( clGlobal.editingPilotLoadoutIndex != -1 )
			loadoutIndex = clGlobal.editingPilotLoadoutIndex
		else
			loadoutIndex = GetPersistentSpawnLoadoutIndex( player, "pilot" )
		UpdatePilotModel( player, loadoutIndex )

		if ( clGlobal.editingTitanLoadoutIndex != -1 )
			loadoutIndex = clGlobal.editingTitanLoadoutIndex
		else
			loadoutIndex = GetPersistentSpawnLoadoutIndex( player, "titan" )
		UpdateTitanModel( player, loadoutIndex )
	}

	void function OnClientScriptInit( entity player )
	{
		UpdateCallsign( player )
	}

	void function InitMenuModelAnims()
	{
		string animType = "main_idle"
		file.pilotAnims[ animType ] <- {}

		string bodyType = "light"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_main_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_main_idle_01"

		bodyType = "medium"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_main_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_main_idle_01"

		bodyType = "heavy"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_main_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_main_idle_01"

		bodyType = "nomad"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_main_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_main_idle_01"

		bodyType = "stalker"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_main_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_main_idle_01"

		bodyType = "geist"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_main_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_main_idle_01"

		bodyType = "grapple"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_main_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_main_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_main_idle_01"

		animType = "background_idle"
		file.pilotAnims[ animType ] <- {}

		bodyType = "light"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		bodyType = "medium"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		bodyType = "heavy"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		bodyType = "nomad"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		bodyType = "stalker"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		bodyType = "geist"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		bodyType = "grapple"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		animType = "focused_idle"
		file.pilotAnims[ animType ] <- {}

		bodyType = "light"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_idle_01"

		bodyType = "medium"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_idle_01"

		bodyType = "heavy"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_idle_01"

		bodyType = "nomad"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_idle_01"

		bodyType = "stalker"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_idle_01"

		bodyType = "geist"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_idle_01"

		bodyType = "grapple"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_idle_01"

		animType = "weapon_inspect_idle"
		file.pilotAnims[ animType ] <- {}

		bodyType = "light"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_edit_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ]		<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ]	<- "pt_menu_loadout_edit_idle_03"

		bodyType = "medium"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_edit_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_edit_idle_03"

		bodyType = "heavy"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_edit_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_edit_idle_03"

		bodyType = "nomad"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_edit_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_edit_idle_03"

		bodyType = "stalker"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_edit_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_edit_idle_03"

		bodyType = "geist"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_edit_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_edit_idle_03"

		bodyType = "grapple"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_menu_loadout_edit_idle_02"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_menu_loadout_edit_idle_01"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_menu_loadout_edit_idle_03"

		animType = "hidden_from_main"
		file.pilotAnims[ animType ] <- {}

		bodyType = "light"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ]		<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ]	<- "pt_titan_menu_loadout_idle"

		bodyType = "medium"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		bodyType = "heavy"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		bodyType = "nomad"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		bodyType = "stalker"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		bodyType = "geist"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		bodyType = "grapple"
		file.pilotAnims[ animType ][ bodyType ] <- {}
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.SMALL ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.MEDIUM ]	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.LARGE ] 	<- "pt_titan_menu_loadout_idle"
		file.pilotAnims[ animType ][ bodyType ][ eMenuAnimClass.CUSTOM ] 	<- "pt_titan_menu_loadout_idle"

		animType = "background_idle"
		file.titanAnims[ animType ] <- {}
		file.titanAnims[ animType ][ "titan_stryder_arc" ]					<- "titan_light_menu_main_idle_01"
		file.titanAnims[ animType ][ "titan_stryder_leadwall" ]				<- "titan_light_menu_main_idle_01"
		file.titanAnims[ animType ][ "titan_stryder_sniper" ]				<- "titan_light_menu_main_idle_01"
		file.titanAnims[ animType ][ "titan_stryder_northstar_prime" ]		<- "titan_light_menu_main_idle_01"
		file.titanAnims[ animType ][ "titan_stryder_ronin_prime" ]			<- "titan_light_menu_main_idle_01"
		file.titanAnims[ animType ][ "titan_atlas_tracker" ]				<- "titan_medium_menu_main_idle_01_TONE"
		file.titanAnims[ animType ][ "titan_atlas_vanguard" ]				<- "titan_medium_menu_main_idle_01_MONARCH"
		file.titanAnims[ animType ][ "titan_atlas_stickybomb" ]				<- "titan_medium_menu_main_idle_01"
		file.titanAnims[ animType ][ "titan_atlas_ion_prime" ]				<- "titan_medium_menu_main_idle_01"
		file.titanAnims[ animType ][ "titan_atlas_tone_prime" ]				<- "titan_medium_menu_main_idle_01_TONE"
		file.titanAnims[ animType ][ "titan_ogre_meteor" ]					<- "titan_heavy_menu_main_idle_01"
		file.titanAnims[ animType ][ "titan_ogre_scorch_prime" ]			<- "titan_heavy_menu_main_idle_01"
		file.titanAnims[ animType ][ "titan_ogre_minigun" ]					<- "titan_heavy_menu_main_idle_01_LEGION"
		file.titanAnims[ animType ][ "titan_ogre_legion_prime" ]			<- "titan_heavy_menu_main_idle_01_LEGION"
		file.titanAnims[ animType ][ "titan_ogre_fighter" ]					<- "titan_heavy_menu_main_idle_01"

		animType = "focused_idle"
		file.titanAnims[ animType ] <- {}
		file.titanAnims[ animType ][ "titan_stryder_arc" ]					<- "titan_light_menu_loadout_idle"
		file.titanAnims[ animType ][ "titan_stryder_leadwall" ]				<- "titan_light_menu_loadout_idle"
		file.titanAnims[ animType ][ "titan_stryder_sniper" ]				<- "titan_light_menu_loadout_idle_NSTAR"
		file.titanAnims[ animType ][ "titan_stryder_northstar_prime" ]		<- "titan_light_menu_loadout_idle_NSTAR"
		file.titanAnims[ animType ][ "titan_stryder_ronin_prime" ]			<- "titan_light_menu_loadout_idle"
		file.titanAnims[ animType ][ "titan_atlas_tracker" ]				<- "titan_medium_menu_loadout_idle"
		file.titanAnims[ animType ][ "titan_atlas_vanguard" ]				<- "titan_medium_menu_loadout_idle_MONARCH"
		file.titanAnims[ animType ][ "titan_atlas_stickybomb" ]				<- "titan_medium_menu_loadout_idle_ION"
		file.titanAnims[ animType ][ "titan_atlas_ion_prime" ]				<- "titan_medium_menu_loadout_idle_ION"
		file.titanAnims[ animType ][ "titan_atlas_tone_prime" ]				<- "titan_medium_menu_loadout_idle"
		file.titanAnims[ animType ][ "titan_ogre_meteor" ]					<- "titan_heavy_menu_loadout_idle_SCORCH"
		file.titanAnims[ animType ][ "titan_ogre_scorch_prime" ]			<- "titan_heavy_menu_loadout_idle_SCORCH"
		file.titanAnims[ animType ][ "titan_ogre_minigun" ]					<- "titan_heavy_menu_loadout_idle_LEGION"
		file.titanAnims[ animType ][ "titan_ogre_legion_prime" ]			<- "titan_heavy_menu_loadout_idle_LEGION"
		file.titanAnims[ animType ][ "titan_ogre_fighter" ]					<- "titan_heavy_menu_loadout_idle"

		animType = "editing_idle"
		file.titanAnims[ animType ] <- {}
		file.titanAnims[ animType ][ "titan_stryder_arc" ]					<- "titan_light_menu_loadout_idle_edit_NSTAR"
		file.titanAnims[ animType ][ "titan_stryder_leadwall" ]				<- "titan_light_menu_loadout_idle_edit_RONIN"
		file.titanAnims[ animType ][ "titan_stryder_sniper" ]				<- "titan_light_menu_loadout_idle_edit_NSTAR"
		file.titanAnims[ animType ][ "titan_stryder_northstar_prime" ]		<- "titan_light_menu_loadout_idle_edit_NSTAR"
		file.titanAnims[ animType ][ "titan_stryder_ronin_prime" ]			<- "titan_light_menu_loadout_idle_edit_RONIN"
		file.titanAnims[ animType ][ "titan_atlas_tracker" ]				<- "titan_medium_menu_loadout_idle_edit_TONE"
		file.titanAnims[ animType ][ "titan_atlas_vanguard" ]				<- "titan_medium_menu_loadout_idle_edit_MONARCH"
		file.titanAnims[ animType ][ "titan_atlas_stickybomb" ]				<- "titan_medium_menu_loadout_idle_edit_ION"
		file.titanAnims[ animType ][ "titan_atlas_ion_prime" ]				<- "titan_medium_menu_loadout_idle_edit_ION"
		file.titanAnims[ animType ][ "titan_atlas_tone_prime" ]				<- "titan_medium_menu_loadout_idle_edit_TONE"
		file.titanAnims[ animType ][ "titan_ogre_meteor" ]					<- "titan_heavy_menu_loadout_idle_edit_SCORCH"
		file.titanAnims[ animType ][ "titan_ogre_scorch_prime" ]			<- "titan_heavy_menu_loadout_idle_edit_SCORCH"
		file.titanAnims[ animType ][ "titan_ogre_minigun" ]					<- "titan_heavy_menu_loadout_idle_edit_LEGION"
		file.titanAnims[ animType ][ "titan_ogre_legion_prime" ]			<- "titan_heavy_menu_loadout_idle_edit_LEGION"
		file.titanAnims[ animType ][ "titan_ogre_fighter" ]					<- "titan_heavy_menu_loadout_idle_edit_LEGION"

		animType = "nose_art_idle"
		file.titanAnims[ animType ] <- {}
		file.titanAnims[ animType ][ "titan_stryder_arc" ]					<- "titan_light_menu_noseart_idle"
		file.titanAnims[ animType ][ "titan_stryder_leadwall" ]				<- "titan_light_menu_noseart_idle"
		file.titanAnims[ animType ][ "titan_stryder_sniper" ]				<- "titan_light_menu_noseart_idle"
		file.titanAnims[ animType ][ "titan_stryder_northstar_prime" ]		<- "titan_light_menu_noseart_idle"
		file.titanAnims[ animType ][ "titan_stryder_ronin_prime" ]			<- "titan_light_menu_noseart_idle"
		file.titanAnims[ animType ][ "titan_atlas_tracker" ]				<- "titan_medium_menu_noseart_idle_TONE"
		file.titanAnims[ animType ][ "titan_atlas_vanguard" ]				<- "titan_medium_menu_noseart_idle_MONARCH"
		file.titanAnims[ animType ][ "titan_atlas_stickybomb" ]				<- "titan_medium_menu_noseart_idle"
		file.titanAnims[ animType ][ "titan_atlas_ion_prime" ]				<- "titan_medium_menu_noseart_idle"
		file.titanAnims[ animType ][ "titan_atlas_tone_prime" ]				<- "titan_medium_menu_noseart_idle_TONE"
		file.titanAnims[ animType ][ "titan_ogre_meteor" ]					<- "titan_heavy_menu_noseart_idle"
		file.titanAnims[ animType ][ "titan_ogre_scorch_prime" ]			<- "titan_heavy_menu_noseart_idle"
		file.titanAnims[ animType ][ "titan_ogre_minigun" ]					<- "titan_heavy_menu_noseart_idle_LEGION"
		file.titanAnims[ animType ][ "titan_ogre_legion_prime" ]			<- "titan_heavy_menu_noseart_idle_LEGION"
		file.titanAnims[ animType ][ "titan_ogre_fighter" ]					<- "titan_heavy_menu_noseart_idle"

		animType = "fd_idle"
		file.titanAnims[ animType ] <- {}
		file.titanAnims[ animType ][ "titan_stryder_leadwall" ]				<- "titan_light_menu_FD_idle_RONIN"
		file.titanAnims[ animType ][ "titan_stryder_sniper" ]				<- "titan_light_menu_FD_idle_NSTAR"
		file.titanAnims[ animType ][ "titan_stryder_northstar_prime" ]		<- "titan_light_menu_FD_idle_NSTAR"
		file.titanAnims[ animType ][ "titan_stryder_ronin_prime" ]			<- "titan_light_menu_FD_idle_RONIN"
		file.titanAnims[ animType ][ "titan_atlas_tracker" ]				<- "titan_medium_menu_FD_idle_TONE"
		file.titanAnims[ animType ][ "titan_atlas_vanguard" ]				<- "titan_medium_menu_FD_idle_MONARCH"
		file.titanAnims[ animType ][ "titan_atlas_stickybomb" ]				<- "titan_medium_menu_FD_idle_ION"
		file.titanAnims[ animType ][ "titan_atlas_ion_prime" ]				<- "titan_medium_menu_FD_idle_ION"
		file.titanAnims[ animType ][ "titan_atlas_tone_prime" ]				<- "titan_medium_menu_FD_idle_TONE"
		file.titanAnims[ animType ][ "titan_ogre_meteor" ]					<- "titan_heavy_menu_FD_idle_SCORCH"
		file.titanAnims[ animType ][ "titan_ogre_scorch_prime" ]			<- "titan_heavy_menu_FD_idle_SCORCH"
		file.titanAnims[ animType ][ "titan_ogre_minigun" ]					<- "titan_heavy_menu_FD_idle_LEGION"
		file.titanAnims[ animType ][ "titan_ogre_legion_prime" ]			<- "titan_heavy_menu_FD_idle_LEGION"
		file.titanAnims[ animType ][ "titan_stryder_arc" ]					<- "titan_light_menu_FD_idle_RONIN"
		file.titanAnims[ animType ][ "titan_ogre_fighter" ]					<- "titan_heavy_menu_FD_idle_SCORCH"
	}

	string function GetPilotAnimType()
	{
		return file.presentationData[ file.presentationType ].pilotAnimType
	}

	string function GetTitanAnimType()
	{
		return file.presentationData[ file.presentationType ].titanAnimType
	}

	string function GetMenuPilotAnim( string animType, string bodyType, int menuAnimClass )
	{
		Assert( animType in file.pilotAnims )
		Assert( bodyType in file.pilotAnims[ animType ] )
		Assert( menuAnimClass in file.pilotAnims[ animType ][ bodyType ] )

		return file.pilotAnims[ animType ][ bodyType ][ menuAnimClass ]
	}

	string function GetMenuTitanAnim( string anim, string setFile )
	{
		Assert( anim in file.titanAnims )
		Assert( setFile in file.titanAnims[ anim ] )

		return file.titanAnims[ anim ][ setFile ]
	}

	void function InitMenuEntities( entity player )
	{
		file.sceneRef = GetEntByScriptName( "menu_scene_ref" )
		vector refOrigin = file.sceneRef.GetOrigin()
		vector refAngles = file.sceneRef.GetAngles()

		entity environmentModel = CreateClientSidePropDynamic( refOrigin, refAngles, DEFAULT_MENU_ENVIRONMENT_MODEL )
		environmentModel.kv.solid = 0
		environmentModel.kv.disableshadows = 1
		environmentModel.MakeSafeForUIScriptHack()

		#if DEV
			if ( BuildingCubeMaps() )
				return
		#endif

		file.cameraTarget = GetEntByScriptName( "menu_camera_target" )
		clGlobal.menuCamera = CreateClientSidePointCamera( <0, 0, 0>, <0, 0, 0>, DEFAULT_FOV )

		CreateMenuFX( environmentModel )


		// Create scene model
		clGlobal.menuSceneModel = CreateClientSidePropDynamic( refOrigin, refAngles, GetSetFileModel( DEFAULT_PILOT_SETTINGS ) )
		clGlobal.menuSceneModel.Hide()
		clGlobal.menuSceneModel.MakeSafeForUIScriptHack()
		file.cameraTarget.SetParent( clGlobal.menuSceneModel, "VDU", false, 0.0 )

		// Create movers
		CreateMover( file.menuPilot, "ORIGIN", PILOT_MAX_TURN_SPEED )
		CreateMover( file.menuTitan, "PROPGUN", TITAN_MAX_TURN_SPEED )
		CreateMover( file.menuFaction, "CHESTFOCUS" )
		CreateMover( file.menuMiscModel, "HEADFOCUS" )
		CreateMover( file.menuWeaponModel, "HEADFOCUS" )
		/*{
			vector origin = clGlobal.menuSceneModel.GetAttachmentOrigin( clGlobal.menuSceneModel.LookupAttachment( "HEADFOCUS" ) )
			file.menuWeaponModel.mover.ClearParent()
			file.menuWeaponModel.mover.SetOrigin( origin + <16, -3, 4> )
			file.menuWeaponModel.mover.SetParent( clGlobal.menuSceneModel, "HEADFOCUS", true, 0.0 )

			file.weaponDLight = CreateClientSideDynamicLight( origin, <0,0,0>, <0, 0, 0>, 512.0 )
		}*/

		//thread DrawTag( clGlobal.menuSceneModel, "ORIGIN" )
		//thread DrawTag( clGlobal.menuSceneModel, "PROPGUN" )
		//thread DrawTag( clGlobal.menuSceneModel, "CHESTFOCUS" )
		//thread DrawTag( clGlobal.menuSceneModel, "HEADFOCUS" )

		//thread DrawOrg( file.menuPilot.mover )
		//thread DrawOrg( file.menuTitan.mover )
		//thread DrawOrg( file.menuFaction.mover )
		//thread DrawOrg( file.menuMiscModel.mover )
		//thread DrawOrg( file.menuWeaponModel.mover )

		WaitSignal( level, "CachedLoadoutsReady" )

		CreatePilotModel( player, file.menuPilot.mover )
		CreateTitanModel( player, file.menuTitan.mover )
		CreateFactionModel( player, file.menuFaction.mover )
		CreateMiscModel( player, file.menuMiscModel.mover )
		file.menuWeaponModel.body = CreateModelForMover( player, file.menuWeaponModel.mover )

		#if HAS_WORLD_CALLSIGN
			CreateCallsign( player, clGlobal.menuSceneModel )
		#endif
		CreateStoreBackground( player )

		clGlobal.initializedMenuModels = true
		UpdateCallsign( player )
	}

	entity function GetDLightEntity()
	{
//		return file.weaponDLight
		return file.menuWeaponModel.body
	}

	void function CreateMover( CharacterData character, string attachName, float maxTurnSpeed = DEFAULT_MAX_TURN_SPEED )
	{
		character.mover = CreateClientsideScriptMover( $"models/dev/empty_model.mdl", <0, 0, 0>, <0, 0, 0> )
		character.mover.SetParent( clGlobal.menuSceneModel, attachName, false, 0.0 )
		character.attachName = attachName
		character.maxTurnSpeed = maxTurnSpeed
	}

	void function CreatePilotModel( entity player, entity mover )
	{
		int team = player.GetTeam()
		int loadoutIndex = GetPersistentSpawnLoadoutIndex( player, "pilot" )
		string suit = GetPilotLoadoutSuit( loadoutIndex )
		string genderRace = GetPilotLoadoutGenderRace( loadoutIndex )
		string setFile = GetSuitAndGenderBasedSetFile( suit, genderRace )
		asset bodyModel = GetSetFileModel( setFile )

		vector refOrigin = mover.GetOrigin()
		vector refAngles = mover.GetAngles()

		if ( DREW_MODE == 1 ) // TEMPHACK
		{
			refOrigin = refOrigin + <0, 0, -1000>
		}
		else if ( DREW_MODE == 2 )
		{
			entity greenScreenEnt = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, GREEN_SCREEN_MODEL )
			greenScreenEnt.MakeSafeForUIScriptHack()
			greenScreenEnt.kv.disableshadows = 1
		}

		entity bodyEnt = CreateClientSidePropDynamic( refOrigin, refAngles, bodyModel )
		bodyEnt.SetParent( mover )
		bodyEnt.SetAlive( true )
		bodyEnt.SetVisibleForLocalPlayer( 0 )
		bodyEnt.MakeSafeForUIScriptHack()
		SetTeam( bodyEnt, team )

		file.menuPilot.body = bodyEnt

		string attachName = "PROPGUN"
		int attachIndex = bodyEnt.LookupAttachment( attachName )
		vector origin = bodyEnt.GetAttachmentOrigin( attachIndex )
		vector angles = bodyEnt.GetAttachmentAngles( attachIndex )
		string weapon = GetPilotLoadoutWeapon( loadoutIndex, clGlobal.heldPilotWeaponType )
		entity weaponEnt = CreateWeaponModel( weapon, origin, angles )

		weaponEnt.SetParent( bodyEnt, attachName, false, 0.0 )

		bodyEnt.SetIKWeapon( weaponEnt )
		file.menuPilot.weapon = weaponEnt
	}

	var function CreateCallsignTopology( vector org, vector ang, float width, float height )
	{
		// adjust so the RUI is drawn with the org as its center point
		org += ( (AnglesToRight( ang )*-1) * (width*0.5) )
		org += ( AnglesToUp( ang ) * (height*0.5) )

		// right and down vectors that get added to base org to create the display size
		vector right = ( AnglesToRight( ang ) * width )
		vector down = ( (AnglesToUp( ang )*-1) * height )

		return RuiTopology_CreatePlane( org, right, down, true )
	}

	void function CreateCallsign( entity player, entity mover )
	{
		//var topo = CreateCallsignTopology( GetMenuPilotBody().GetOrigin() + <110, 32, 100>, < 0, 45, 6 >, 32 * 1.25, 17 * 1.25 )
		//var topo = CreateCallsignTopology( GetMenuPilotBody().GetOrigin() + <98, 16, 92>, < 0, 45, 6 >, 32 * 1.15, 17 * 1.15 )
		var topo = CreateCallsignTopology( < -32, 50, 67 >, <0, 165, 6>, 28, 15 + (28 * CARD_TAG_SCALE) )
		RuiTopology_SetParent( topo, mover, "ORIGIN" )
		var rui = RuiCreate( $"ui/callsign_basic.rpak", topo, RUI_DRAW_WORLD, 0 )
		file.menuCallsignRui = rui
		file.menuCallsignTopo = topo

		UpdateCallsign( player )
	}

	void function CreateStoreBackground( entity player )
	{
		file.menuStoreBackground = CreateClientSidePropDynamic( <68.1134, 377.554, -21.029>, <0.0, 225.0, 0.0>, $"models/test/brad/store_card.mdl" )
	}

	void function UpdateStoreBackground( entity player, int storeBgIndex )
	{
		switch ( storeBgIndex )
		{
			case STORE_BG_DEFAULT:
				file.menuStoreBackground.SetModel( $"models/test/brad/store_card.mdl" )
				file.menuStoreBackground.SetOrigin( <68.1134, 377.554, -18.25> )
				break
			case STORE_BG_BUNDLE1:
				file.menuStoreBackground.SetModel( $"models/test/brad/store_card_angel_city.mdl" )
				file.menuStoreBackground.SetOrigin( <68.1134, 377.554, -18.25> )
				break
			case STORE_BG_BUNDLE2:
				file.menuStoreBackground.SetModel( $"models/test/brad/store_card_colony.mdl" )
				file.menuStoreBackground.SetOrigin( <68.1134, 377.554, -18.25> )
				break
			case STORE_BG_BUNDLE3:
				file.menuStoreBackground.SetModel( $"models/test/brad/store_card_relic.mdl" )
				file.menuStoreBackground.SetOrigin( <68.1134, 377.554, -18.25> )
				break
			case STORE_BG_BUNDLE4:
				file.menuStoreBackground.SetModel( $"models/test/brad/store_card_prime_bundle.mdl" )
				file.menuStoreBackground.SetOrigin( <68.1134, 377.554, -18.25> )
				break
			case STORE_BG_BUNDLE5:
				file.menuStoreBackground.SetModel( $"models/test/brad/store_weapon_warpaint_bundle.mdl" )
				file.menuStoreBackground.SetOrigin( <68.1134, 377.554, -18.25> )
				break
			case STORE_BG_BUNDLE6:
				file.menuStoreBackground.SetModel( $"models/test/brad/jump_start.mdl" )
				file.menuStoreBackground.SetOrigin( <68.1134, 377.554, -18.25> )
				break
		}
	}

	void function UpdateStorePrimeBg( entity player, int loadoutIndex )
	{
		switch ( loadoutIndex )
		{
			case 0:
				RuiSetImage( file.menuStorePrimeBgRui, "bgImage", $"rui/menu/store/prime_ion_bg" )
				break
			case 1:
				RuiSetImage( file.menuStorePrimeBgRui, "bgImage", $"rui/menu/store/prime_scorch_bg" )
				break
			case 2:
				RuiSetImage( file.menuStorePrimeBgRui, "bgImage", $"rui/menu/store/prime_northstar_bg" )
				break
			case 3:
				RuiSetImage( file.menuStorePrimeBgRui, "bgImage", $"rui/menu/store/prime_ronin_bg" )
				break
			case 4:
				RuiSetImage( file.menuStorePrimeBgRui, "bgImage", $"rui/menu/store/prime_tone_bg" )
				break
			case 5:
				RuiSetImage( file.menuStorePrimeBgRui, "bgImage", $"rui/menu/store/prime_legion_bg" )
				break
			case 6:
				RuiSetImage( file.menuStorePrimeBgRui, "bgImage", $"rui/menu/store/prime_vanguard_bg" )
				break
		}
	}

	void function UpdateCallsign( entity player )
	{
		if ( !clGlobal.initializedMenuModels ) // Handle early calls that UI script can trigger before client is ready
			return

		#if HAS_WORLD_CALLSIGN
			CallingCard callingCard = PlayerCallingCard_GetActive( player )
			CallsignIcon callsignIcon = PlayerCallsignIcon_GetActive( player )

			RuiSetImage( file.menuCallsignRui, "cardImage", callingCard.image )
			RuiSetInt( file.menuCallsignRui, "layoutType", callingCard.layoutType )
			RuiSetImage( file.menuCallsignRui, "iconImage", callsignIcon.image )
			RuiSetString( file.menuCallsignRui, "playerLevel", PlayerXPDisplayGenAndLevel( player.GetGen(), player.GetLevel() ) )
			RuiSetString( file.menuCallsignRui, "playerName", player.GetPlayerName() )
			RuiSetImage( file.menuCallsignRui, "cardGenImage", PlayerXPGetGenIcon( player ) ) //Commented Out Temporarily to Fix Blocker Bug: 220132
			RuiSetBool( file.menuCallsignRui, "isLobbyCard", true )

			thread KeepCallsignUpToDate( player )
		#endif
	}

	void function KeepCallsignUpToDate( entity player )
	{
		#if HAS_WORLD_CALLSIGN
			player.Signal( "UpdateCallsign" )
			player.EndSignal( "UpdateCallsign" )

			while ( IsValid( player ) )
			{
				CallingCard callingCard = PlayerCallingCard_GetActive( player )
				CallsignIcon callsignIcon = PlayerCallsignIcon_GetActive( player )
				RuiSetString( file.menuCallsignRui, "playerName", player.GetPlayerName() )
				RuiSetString( file.menuCallsignRui, "playerLevel", PlayerXPDisplayGenAndLevel( player.GetGen(), player.GetLevel() ) )
				RuiSetImage( file.menuCallsignRui, "cardImage", callingCard.image )
				RuiSetImage( file.menuCallsignRui, "iconImage", callsignIcon.image )
				RuiSetImage( file.menuCallsignRui, "cardGenImage", PlayerXPGetGenIcon( player ) )  //Commented Out Temporarily to Fix Blocker Bug: 220132
				RuiSetInt( file.menuCallsignRui, "layoutType", callingCard.layoutType )
				wait 0.5
			}
		#endif
	}

	entity function CreateWeaponModel( string weapon, vector origin, vector angles )
	{
		entity weaponEnt = CreateClientSidePropDynamic( origin, angles, GetWeaponModel( weapon ) )
		weaponEnt.MakeSafeForUIScriptHack()

		return weaponEnt
	}

	void function CreateTitanModel( entity player, entity mover )
	{
		int team = player.GetTeam()
		int loadoutIndex = GetPersistentSpawnLoadoutIndex( player, "titan" )
		string setFile = GetTitanLoadoutSetFile( loadoutIndex )
		asset chassisModel = GetSetFileModel( setFile )

		vector refOrigin = mover.GetOrigin()
		vector refAngles = mover.GetAngles()

		if ( DREW_MODE == 1 ) // TEMPHACK
			refOrigin = refOrigin + < 0, 0, -1000 >

		entity chassisEnt = CreateClientSidePropDynamic( refOrigin, refAngles, chassisModel )
		chassisEnt.SetParent( mover )
		chassisEnt.SetAlive( true )
		chassisEnt.SetVisibleForLocalPlayer( 0 )
		chassisEnt.MakeSafeForUIScriptHack()
		SetTeam( chassisEnt, team )

		file.menuTitan.body = chassisEnt

		int attachIndex = chassisEnt.LookupAttachment( "PROPGUN" )
		vector origin = chassisEnt.GetAttachmentOrigin( attachIndex )
		vector angles = chassisEnt.GetAttachmentAngles( attachIndex )

		string weapon = GetTitanLoadoutPrimary( loadoutIndex )
		asset weaponModel = GetWeaponModel( weapon )

		entity weaponEnt = CreateClientSidePropDynamic( origin, angles, weaponModel )
		weaponEnt.SetParent( chassisEnt, "PROPGUN", false, 0.0 )
		weaponEnt.MakeSafeForUIScriptHack()
		file.menuTitan.weapon = weaponEnt
	}

	void function CreateFactionModel( entity player, entity mover )
	{
		int team = player.GetTeam()
		string ref = GetFactionChoice( player )
		asset bodyModel = GetFactionModel( ref )
		int skin = GetFactionModelSkin( ref )

		vector refOrigin = mover.GetOrigin()
		vector refAngles = mover.GetAngles()

		entity bodyEnt = CreateClientSidePropDynamic( refOrigin, refAngles, bodyModel )
		bodyEnt.SetParent( mover )
		bodyEnt.SetAlive( true )
		bodyEnt.SetVisibleForLocalPlayer( 0 )
		bodyEnt.MakeSafeForUIScriptHack()
		bodyEnt.SetSkin( skin )
		SetTeam( bodyEnt, team )

		file.menuFaction.body = bodyEnt

		entity propEnt = CreateFactionPropModel( bodyEnt, ref )
		if ( IsValid( file.menuFaction.weapon ) )
			file.menuFaction.weapon.Destroy()

		file.menuFaction.weapon = propEnt
	}

	entity function CreateFactionPropModel( entity baseEnt, string ref )
	{
		string attachName = GetFactionPropAttachment( ref )
		if ( attachName == "" )
			return null

		int attachIndex = baseEnt.LookupAttachment( attachName )
		vector origin = baseEnt.GetAttachmentOrigin( attachIndex )
		vector angles = baseEnt.GetAttachmentAngles( attachIndex )
		asset propModel = GetFactionPropModel( ref )

		entity propEnt = CreateClientSidePropDynamic( origin, angles, propModel )
		propEnt.SetParent( baseEnt, attachName, false, 0.0 )
		propEnt.MakeSafeForUIScriptHack()

		return propEnt
	}

	void function CreateMiscModel( entity player, entity mover )
	{
		entity modelEnt = CreateClientSidePropDynamic( mover.GetOrigin(), mover.GetAngles(), $"models/dev/empty_model.mdl" )
		modelEnt.SetParent( mover )
		modelEnt.SetVisibleForLocalPlayer( 0 )
		modelEnt.MakeSafeForUIScriptHack()

		file.menuMiscModel.body = modelEnt
	}


	entity function CreateModelForMover( entity player, entity mover )
	{
		entity modelEnt = CreateClientSidePropDynamic( mover.GetOrigin(), mover.GetAngles(), $"models/dev/empty_model.mdl" )
		modelEnt.SetParent( mover )
		modelEnt.SetVisibleForLocalPlayer( 0 )
		modelEnt.MakeSafeForUIScriptHack()

		return modelEnt
	}

	entity function CreateAttachedModel( entity baseEnt, asset model, string attachName )
	{
		int attachIndex = baseEnt.LookupAttachment( attachName )
		vector origin = baseEnt.GetAttachmentOrigin( attachIndex )
		vector angles = baseEnt.GetAttachmentAngles( attachIndex )

		entity propEnt = CreateClientSidePropDynamic( origin, angles, model )
		propEnt.SetParent( baseEnt, attachName, false, 0.0 )
		propEnt.MakeSafeForUIScriptHack()

		return propEnt
	}

	void function CreateMenuFX( entity model )
	{
		int index = GetParticleSystemIndex( MENU_TEST_EFFECT )
		int attachID = model.LookupAttachment( "ORIGIN" )

		printt( index )
		printt( model )
		printt( attachID )
		int fxID = StartParticleEffectOnEntity( model, index, FX_PATTACH_POINT_FOLLOW, attachID )
		EffectSetDontKillForReplay( fxID )
	}

	void function ServerCallback_UpdatePilotModel( int loadoutIndex )
	{
		if ( !clGlobal.mapSupportsMenuModels )
			return

		entity player = GetLocalClientPlayer()

		UpdatePilotModel( player, loadoutIndex )
	}

	void function UpdatePilotModel( entity player, int loadoutIndex )
	{
		if ( !clGlobal.initializedMenuModels ) // Handle early calls that UI script can trigger before client is ready
			return

		string genderRace = GetPilotLoadoutGenderRace( loadoutIndex )
		string suit = GetPilotLoadoutSuit( loadoutIndex )
		string setFile = GetSuitAndGenderBasedSetFile( suit, genderRace )
		string weapon = GetPilotLoadoutWeapon( loadoutIndex, clGlobal.heldPilotWeaponType )
		array<string> mods = GetPilotLoadoutWeaponMods( loadoutIndex, clGlobal.heldPilotWeaponType )
		mods.removebyvalue( "" )
		mods.removebyvalue( "none" )

		asset bodyModel = GetSetFileModel( setFile )
		asset weaponModel = GetWeaponModel( weapon )
		string idleAnim = GetMenuPilotAnim( GetPilotAnimType(), suit, GetItemMenuAnimClass( weapon ) )
		int camoIndex = GetPilotCamoIndex( loadoutIndex )
		int weaponSkinIndex = GetPilotLoadoutWeaponSkinIndex( loadoutIndex, clGlobal.heldPilotWeaponType )
		int weaponCamoIndex = GetPilotLoadoutWeaponCamoIndex( loadoutIndex, clGlobal.heldPilotWeaponType )

		clGlobal.currentMenuPilotModels.loadoutIndex = loadoutIndex
		clGlobal.currentMenuPilotModels.bodyModel = bodyModel
		clGlobal.currentMenuPilotModels.camoIndex = camoIndex
		clGlobal.currentMenuPilotModels.idleAnim = idleAnim

		clGlobal.currentMenuPilotModels.weapon = weapon
		clGlobal.currentMenuPilotModels.weaponModel = weaponModel
		clGlobal.currentMenuPilotModels.weaponSkinIndex = weaponSkinIndex
		clGlobal.currentMenuPilotModels.weaponCamoIndex = weaponCamoIndex
		clGlobal.currentMenuPilotModels.mods = mods

		UpdatePilotModelDisplay( player )
	}

	void function ServerCallback_UpdateTitanModel( int loadoutIndex, int flags = 0 )
	{
		if ( !clGlobal.mapSupportsMenuModels )
			return

		entity player = GetLocalClientPlayer()

		UpdateTitanModel( player, loadoutIndex, flags )
	}

	void function UpdateTitanModel( entity player, int loadoutIndex, int flags = 0 )
	{
		if ( !clGlobal.initializedMenuModels ) // Handle early calls that UI script can trigger before client is ready
			return

		if ( loadoutIndex == -1 )
		{
			file.menuTitan.body.Hide()
			file.menuTitan.weapon.Hide()

			return
		}

		file.menuTitan.body.Show()
		file.menuTitan.weapon.Show()

		TitanLoadoutDef cachedLoadout = GetCachedTitanLoadout( loadoutIndex )
		string setFile
		if ( flags & TITANMENU_FORCE_NON_PRIME )
			setFile = GetSetFileForTitanClassAndPrimeStatus( cachedLoadout.titanClass, false )
		else if ( flags & TITANMENU_FORCE_PRIME )
			setFile = GetSetFileForTitanClassAndPrimeStatus( cachedLoadout.titanClass, true )
		else
			setFile = GetTitanLoadoutSetFile( loadoutIndex )

		string weapon = GetTitanLoadoutPrimary( loadoutIndex )
		asset chassisModel = GetSetFileModel( setFile )
		asset weaponModel = GetWeaponModel( weapon )
		string idleAnim = GetMenuTitanAnim( GetTitanAnimType(), setFile )
		int camoIndex
		int skinIndex
		int decalIndex
		int weaponCamoIndex
		int showArmBadge

		if ( !( flags & TITANMENU_NO_CUSTOMIZATION ) )
		{
			camoIndex = GetTitanCamoIndex( loadoutIndex )
			skinIndex = GetTitanSkinIndex( loadoutIndex )
			decalIndex = GetTitanDecalIndex( loadoutIndex )
			weaponCamoIndex = cachedLoadout.primaryCamoIndex
			showArmBadge = GetTitanLoadoutArmBadgeState( loadoutIndex )
		}

		clGlobal.currentMenuTitanModels.isPrime = Dev_GetPlayerSettingByKeyField_Global( setFile, "isPrime" ) == 1
		clGlobal.currentMenuTitanModels.loadoutIndex = loadoutIndex
		clGlobal.currentMenuTitanModels.bodyModel = chassisModel
		clGlobal.currentMenuTitanModels.camoIndex = camoIndex
		clGlobal.currentMenuTitanModels.skinIndex = skinIndex
		clGlobal.currentMenuTitanModels.decalIndex = decalIndex
		clGlobal.currentMenuTitanModels.idleAnim = idleAnim

		clGlobal.currentMenuTitanModels.weaponModel = weaponModel
		clGlobal.currentMenuTitanModels.weaponCamoIndex = weaponCamoIndex

		asset armBadgeModel = GetTitanLoadoutArmBadge( loadoutIndex )
		clGlobal.currentMenuTitanModels.armBadgeModel = armBadgeModel
		clGlobal.currentMenuTitanModels.armBadgeBodyGroupIndex = armBadgeModel != $"" ? 0 : 0
		clGlobal.currentMenuTitanModels.showArmBadge = showArmBadge

		UpdateTitanModelDisplay( player )
	}

	void function UpdatePilotModelDisplay( entity player )
	{
		if ( !clGlobal.initializedMenuModels ) // Handle early calls that UI script can trigger before client is ready
			return

		asset bodyModel = clGlobal.previewMenuPilotModels.bodyModel
		if ( bodyModel == $"" )
			bodyModel = clGlobal.currentMenuPilotModels.bodyModel

		string idleAnim = clGlobal.previewMenuPilotModels.idleAnim
		if ( idleAnim == "" )
			idleAnim = clGlobal.currentMenuPilotModels.idleAnim

		bool playIdle = false
		if ( file.menuPilot.body.GetModelName() != bodyModel || idleAnim != file.menuPilot.bodyAnim ) // Model has changed or anim has changed
			playIdle = true

		file.menuPilot.body.SetModel( bodyModel )

		int camoIndex = clGlobal.previewMenuPilotModels.camoIndex
		if ( camoIndex == -1 )
			camoIndex = clGlobal.currentMenuPilotModels.camoIndex

		if ( camoIndex > 0 )
		{
			file.menuPilot.body.SetSkin( PILOT_SKIN_INDEX_CAMO )
			file.menuPilot.body.SetCamo( camoIndex )
		}
		else
		{
			file.menuPilot.body.SetSkin( 0 )
			file.menuPilot.body.SetCamo( -1 )
		}

		if ( playIdle )
		{
			PlayMenuAnim( file.menuPilot.body, idleAnim )
			file.menuPilot.bodyAnim = idleAnim
		}

		string weapon = clGlobal.previewMenuPilotModels.weapon
		if ( weapon == "" )
			weapon = clGlobal.currentMenuPilotModels.weapon

		asset weaponModel = clGlobal.previewMenuPilotModels.weaponModel
		if ( weaponModel == $"" )
			weaponModel = clGlobal.currentMenuPilotModels.weaponModel

		file.menuPilot.weapon.SetSkin( WEAPON_SKIN_INDEX_DEFAULT ) // Lame that we need this, but this avoids invalid skin errors when the model changes and the currently shown skin index doesn't exist for the new model
		file.menuPilot.weapon.SetModel( weaponModel )

		bool isPreviewingWeaponNotMatchingCurrent = clGlobal.previewMenuPilotModels.weaponModel != $"" && clGlobal.previewMenuPilotModels.weaponModel != clGlobal.currentMenuPilotModels.weaponModel

		array<string> mods = clGlobal.previewMenuPilotModels.mods
		if ( mods.len() == 0 )
		{
			// Don't show mods if previewing a weapon that isn't already equipped
			if ( isPreviewingWeaponNotMatchingCurrent )
				mods = []
			else
				mods = clGlobal.currentMenuPilotModels.mods
		}
		SetBodyGroupsForWeaponConfig( file.menuPilot.weapon, weapon, mods )

		int weaponCamoIndex
		int weaponSkinIndex
		if ( isPreviewingWeaponNotMatchingCurrent )
		{
			weaponCamoIndex = 0
			weaponSkinIndex = 0
		}
		else
		{
			// Skin or camo preview is active so use preview values for both
			if ( clGlobal.previewMenuPilotModels.weaponSkinIndex != -1 || clGlobal.previewMenuPilotModels.weaponCamoIndex != -1 )
			{
				weaponSkinIndex = clGlobal.previewMenuPilotModels.weaponSkinIndex
				weaponCamoIndex = clGlobal.previewMenuPilotModels.weaponCamoIndex
			}
			else // no preview active, show current for both
			{
				weaponSkinIndex = clGlobal.currentMenuPilotModels.weaponSkinIndex
				weaponCamoIndex = clGlobal.currentMenuPilotModels.weaponCamoIndex
			}
		}


		if ( weaponCamoIndex > 0 )
			weaponSkinIndex = WEAPON_SKIN_INDEX_CAMO
		else
			weaponCamoIndex = -1

		file.menuPilot.weapon.SetSkin( weaponSkinIndex )
		//printt( "Set pilot weapon skin to:", weaponSkinIndex )
		file.menuPilot.weapon.SetCamo( weaponCamoIndex )
		//printt( "Set pilot weapon camo to:", weaponCamoIndex )
	}

	void function UpdateTitanModelDisplay( entity player )
	{
		if ( !clGlobal.initializedMenuModels ) // Handle early calls that UI script can trigger before client is ready
			return

		asset bodyModel = clGlobal.previewMenuTitanModels.bodyModel
		if ( bodyModel == $"" )
			bodyModel = clGlobal.currentMenuTitanModels.bodyModel

		string idleAnim = clGlobal.previewMenuTitanModels.idleAnim
		if ( idleAnim == "" )
			idleAnim = clGlobal.currentMenuTitanModels.idleAnim

		bool playIdle = false
		if ( file.menuTitan.body.GetModelName() != bodyModel || idleAnim != file.menuTitan.bodyAnim ) // Model has changed or anim has changed
			playIdle = true

		if ( file.menuTitan.body.GetModelName() != bodyModel  )
		{
			file.menuTitan.body.SetSkin( 0 ) //First reset skin and decal to default to avoid code error message when changing models, if the new models don't have the same skins supported
			file.menuTitan.body.SetCamo( -1 )
			file.menuTitan.body.SetModel( bodyModel )
		}

		int camoIndex = clGlobal.previewMenuTitanModels.camoIndex
		int skinIndex = clGlobal.previewMenuTitanModels.skinIndex

		bool usedCurrentValues = false
		if ( camoIndex == -1 && skinIndex == 0 )
		{
			camoIndex = clGlobal.currentMenuTitanModels.camoIndex
			skinIndex = clGlobal.currentMenuTitanModels.skinIndex
			usedCurrentValues = true
		}
		else
		{
			camoIndex = clGlobal.previewMenuTitanModels.camoIndex
			skinIndex = clGlobal.previewMenuTitanModels.skinIndex
		}

		if ( camoIndex > 0 )
		{
			skinIndex = TITAN_SKIN_INDEX_CAMO
		}
		else
		{
			camoIndex = -1
		}

		file.menuTitan.body.SetSkin( skinIndex )
		file.menuTitan.body.SetCamo( camoIndex )

		int decalIndex = clGlobal.previewMenuTitanModels.decalIndex
		if ( decalIndex == -1 )
			decalIndex = clGlobal.currentMenuTitanModels.decalIndex

		file.menuTitan.body.SetDecal( decalIndex )
		//printt( "Set titan decal to:", decalIndex )

		if ( playIdle )
		{
			PlayMenuAnim( file.menuTitan.body, idleAnim )
			file.menuTitan.bodyAnim = idleAnim
		}

		asset weaponModel = clGlobal.previewMenuTitanModels.weaponModel
		if ( weaponModel == $"" )
			weaponModel = clGlobal.currentMenuTitanModels.weaponModel

		file.menuTitan.weapon.SetModel( weaponModel )

		int weaponCamoIndex = clGlobal.previewMenuTitanModels.weaponCamoIndex
		if ( weaponCamoIndex == -1 )
			weaponCamoIndex = clGlobal.currentMenuTitanModels.weaponCamoIndex

		//printt( "clGlobal.previewMenuTitanModels.weaponCamoIndex:", clGlobal.previewMenuTitanModels.weaponCamoIndex )
		//printt( "clGlobal.currentMenuTitanModels.weaponCamoIndex:", clGlobal.currentMenuTitanModels.weaponCamoIndex )
		//printt( "weaponCamoIndex:", weaponCamoIndex )
		if ( weaponCamoIndex > 0 )
		{
			file.menuTitan.weapon.SetSkin( WEAPON_SKIN_INDEX_CAMO )
			//printt( "Set titan weapon skin to:", WEAPON_SKIN_INDEX_CAMO )
			file.menuTitan.weapon.SetCamo( weaponCamoIndex )
			//printt( "Set titan weapon camo to:", weaponCamoIndex )
		}
		else
		{
			file.menuTitan.weapon.SetSkin( 0 )
			//printt( "Set titan weapon skin to:", 0 )
			file.menuTitan.weapon.SetCamo( -1 )
			//printt( "Set titan weapon camo to:", -1 )
		}

		if ( IsValid( file.menuTitan.prop ) )
			file.menuTitan.prop.Destroy()

		if ( bodyModel == $"models/titans/light/titan_light_locust.mdl" )
			file.menuTitan.prop = CreateAttachedModel( file.menuTitan.body, $"models/weapons/titan_sword/w_titan_sword.mdl", "SIDEARM_HOLSTER" )
		else if ( bodyModel == $"models/titans/light/titan_light_ronin_prime.mdl" )
			file.menuTitan.prop = CreateAttachedModel( file.menuTitan.body, $"models/weapons/titan_sword/w_titan_sword_prime.mdl", "SIDEARM_HOLSTER" )

		if ( IsValid( file.menuTitan.armBadge ) )
			file.menuTitan.armBadge.Destroy()

		UpdatePreviewTitanArmBadge( player, skinIndex, camoIndex, clGlobal.currentMenuTitanModels.loadoutIndex )
		asset armBadgeModel = clGlobal.previewMenuTitanModels.armBadgeModel
		int armBadgeBodyGroupIndex = clGlobal.previewMenuTitanModels.armBadgeBodyGroupIndex
		if ( usedCurrentValues )
		{
			UpdateMenuTitanArmBadge( player, skinIndex, camoIndex, clGlobal.currentMenuTitanModels.loadoutIndex )
			armBadgeModel = clGlobal.currentMenuTitanModels.armBadgeModel
			armBadgeBodyGroupIndex = clGlobal.currentMenuTitanModels.armBadgeBodyGroupIndex
		}

		if ( armBadgeBodyGroupIndex != -1 && armBadgeModel != $"" )
		{
			file.menuTitan.armBadge = CreateAttachedModel( file.menuTitan.body, armBadgeModel, TITAN_ARM_BADGE_ATTACHMENT )
			file.menuTitan.armBadge.SetBodygroup( 0, armBadgeBodyGroupIndex )
		}
	}

	void function SetEditingPilotLoadoutIndex( entity player, int loadoutIndex )
	{
		clGlobal.editingPilotLoadoutIndex = loadoutIndex
	}

	void function ClearEditingPilotLoadoutIndex( entity player )
	{
		clGlobal.editingPilotLoadoutIndex = -1
	}

	void function SetHeldPilotWeaponType( entity player, int itemType )
	{
		clGlobal.heldPilotWeaponType = itemType
	}

	void function SetEditingTitanLoadoutIndex( entity player, int loadoutIndex )
	{
		clGlobal.editingTitanLoadoutIndex = loadoutIndex
	}

	void function ClearEditingTitanLoadoutIndex( entity player )
	{
		clGlobal.editingTitanLoadoutIndex = -1
	}


	void function PreviewPilotCharacter( entity player, int itemIndex )
	{
		Assert( clGlobal.editingPilotLoadoutIndex != -1 )

		array<ItemDisplayData> items = GetVisibleItemsOfType( eItemTypes.PILOT_SUIT )
		string animType = "focused_idle"
		string suit = items[ itemIndex ].ref
		string weapon = GetPilotLoadoutWeapon( clGlobal.editingPilotLoadoutIndex, clGlobal.heldPilotWeaponType )
		string idleAnim = GetMenuPilotAnim( animType, suit, GetItemMenuAnimClass( weapon ) )
		string genderRace = GetPilotLoadoutGenderRace( clGlobal.editingPilotLoadoutIndex )
		string setFile = GetSuitAndGenderBasedSetFile( suit, genderRace )
		asset bodyModel = GetSetFileModel( setFile )

		clGlobal.previewMenuPilotModels.bodyModel = bodyModel
		clGlobal.previewMenuPilotModels.idleAnim = idleAnim

		UpdatePilotModelDisplay( player )
	}

	void function PreviewPilotWeapon( entity player, int itemType, int itemIndex, int weaponCategory )
	{
		Assert( itemType == eItemTypes.PILOT_PRIMARY || itemType == eItemTypes.PILOT_SECONDARY )
		Assert( clGlobal.editingPilotLoadoutIndex != -1 )

		array<ItemDisplayData> items
		if ( weaponCategory != -1 )
			items = GetVisibleItemsOfTypeForCategory( itemType, weaponCategory )
		else
			items = GetVisibleItemsOfType( itemType )

		string weapon = items[ itemIndex ].ref
		asset weaponModel = GetWeaponModel( weapon )
		string animType = "weapon_inspect_idle"
		string suit = GetPilotLoadoutSuit( clGlobal.editingPilotLoadoutIndex )
		string idleAnim = GetMenuPilotAnim( animType, suit, GetItemMenuAnimClass( weapon ) )
		int weaponSkinIndex = GetPilotLoadoutWeaponSkinIndex( clGlobal.editingPilotLoadoutIndex, itemType )
		int weaponCamoIndex = GetPilotLoadoutWeaponCamoIndex( clGlobal.editingPilotLoadoutIndex, itemType )

		clGlobal.previewMenuPilotModels.idleAnim = idleAnim
		clGlobal.previewMenuPilotModels.weapon = weapon
		clGlobal.previewMenuPilotModels.weaponModel = weaponModel
		clGlobal.previewMenuPilotModels.weaponSkinIndex = weaponSkinIndex
		clGlobal.previewMenuPilotModels.weaponCamoIndex = weaponCamoIndex
		clGlobal.previewMenuPilotModels.mods = []

		UpdatePilotModelDisplay( player )
	}

	void function PreviewPilotWeaponMod( entity player, int modIndex, string modRef )
	{
		Assert( clGlobal.editingPilotLoadoutIndex != -1 )

		array<string> mods = GetPilotLoadoutWeaponMods( clGlobal.editingPilotLoadoutIndex, clGlobal.heldPilotWeaponType )
		mods[ modIndex ] = modRef
		mods.removebyvalue( "" )
		mods.removebyvalue( "none" )

		clGlobal.previewMenuPilotModels.mods = mods

		UpdatePilotModelDisplay( player )
	}

	void function PreviewPilotCamoChange( entity player, int camoIndex )
	{
		clGlobal.previewMenuPilotModels.camoIndex = camoIndex
		UpdatePilotModelDisplay( player )
	}

	void function PreviewPilotWeaponCamoChange( entity player, int camoIndex )
	{
		if ( camoIndex == 0 ) // Special case for factory issue. Should make factory issue work as any other weapon skin item in the future.
		{
			clGlobal.previewMenuPilotModels.weaponSkinIndex = WEAPON_SKIN_INDEX_DEFAULT
			clGlobal.previewMenuPilotModels.weaponCamoIndex = -1
		}
		else
		{
			clGlobal.previewMenuPilotModels.weaponSkinIndex = WEAPON_SKIN_INDEX_CAMO
			clGlobal.previewMenuPilotModels.weaponCamoIndex = camoIndex
		}

		printt( "PreviewPilotWeaponCamoChange", clGlobal.previewMenuPilotModels.weaponSkinIndex, clGlobal.previewMenuPilotModels.weaponCamoIndex )
		UpdatePilotModelDisplay( player )
	}

	void function PrintWeaponModelData()
	{
		printt( "clGlobal.previewMenuPilotModels.weaponSkinIndex:", clGlobal.previewMenuPilotModels.weaponSkinIndex, "clGlobal.currentMenuPilotModels.weaponSkinIndex:", clGlobal.currentMenuPilotModels.weaponSkinIndex )
		printt( "clGlobal.previewMenuPilotModels.weaponCamoIndex:", clGlobal.previewMenuPilotModels.weaponCamoIndex, "clGlobal.currentMenuPilotModels.weaponCamoIndex:", clGlobal.currentMenuPilotModels.weaponCamoIndex )
	}

	void function PreviewPilotWeaponSkinChange( entity player, int skinIndex )
	{
		clGlobal.previewMenuPilotModels.weaponSkinIndex = skinIndex
		clGlobal.previewMenuPilotModels.weaponCamoIndex = -1
		printt( "PreviewPilotWeaponSkinChange", clGlobal.previewMenuPilotModels.weaponSkinIndex, clGlobal.previewMenuPilotModels.weaponCamoIndex )
		UpdatePilotModelDisplay( player )
	}

	void function PreviewTitanDecalChange( entity player, int decalIndex )
	{
		clGlobal.previewMenuTitanModels.decalIndex = decalIndex
		UpdateTitanModelDisplay( player )
	}

	void function PreviewTitanCamoChange( entity player, int camoIndex )
	{
		clGlobal.previewMenuTitanModels.camoIndex = camoIndex
		clGlobal.previewMenuTitanModels.skinIndex = camoIndex > 0 ? TITAN_SKIN_INDEX_CAMO : 0
		// clGlobal.previewMenuTitanModels.armBadgeModel = $""
		// clGlobal.previewMenuTitanModels.armBadgeBodyGroupIndex = 0

		printt( "PreviewTitanCamoChange", clGlobal.previewMenuTitanModels.skinIndex, clGlobal.previewMenuTitanModels.camoIndex )
		UpdateTitanModelDisplay( player )
	}

	void function PreviewTitanSkinChange( entity player, int skinIndex )
	{
		clGlobal.previewMenuTitanModels.camoIndex = -1
		clGlobal.previewMenuTitanModels.skinIndex = skinIndex
		printt( "PreviewTitanSkinChange", clGlobal.previewMenuTitanModels.skinIndex, clGlobal.previewMenuTitanModels.camoIndex )
		UpdateTitanModelDisplay( player )
	}

	void function PreviewTitanCombinedChange( entity player, int skinIndex, int camoIndex, int loadoutIndex )
	{
		clGlobal.previewMenuTitanModels.camoIndex = camoIndex
		clGlobal.previewMenuTitanModels.skinIndex = skinIndex
		clGlobal.previewMenuTitanModels.loadoutIndex = loadoutIndex
		UpdatePreviewTitanArmBadge( player, skinIndex, camoIndex, loadoutIndex )
		printt( "PreviewTitanCombinedChange", clGlobal.previewMenuTitanModels.skinIndex, clGlobal.previewMenuTitanModels.camoIndex )
		UpdateTitanModelDisplay( player )
	}

	void function UpdatePreviewTitanArmBadge( entity player, int skinIndex, int camoIndex, int loadoutIndex )
	{
		UpdateMenuDefArmBadge( clGlobal.previewMenuTitanModels, player, skinIndex, camoIndex, loadoutIndex )
	}

	void function UpdateMenuTitanArmBadge( entity player, int skinIndex, int camoIndex, int loadoutIndex )
	{
		UpdateMenuDefArmBadge( clGlobal.currentMenuTitanModels, player, skinIndex, camoIndex, loadoutIndex )
	}

	void function UpdateMenuDefArmBadge( MenuCharacterDef charDef, entity player, int skinIndex, int camoIndex, int loadoutIndex )
	{
		if ( !IsConnected() ) //Defensive fix for persistence not being loaded when disconnecting or connecting into a match.
			return

		TitanLoadoutDef loadout = clone GetCachedTitanLoadout( loadoutIndex )

		asset armBadgeModel = GetTitanArmBadgeFromLoadoutAndSkinIndex( loadout, skinIndex )

		int armBadgeBodyGroupIndex = -1
		if ( armBadgeModel != $"" )
		{
			int difficulty = FD_GetHighestDifficultyForTitan( player, loadout.titanClass )
			switch ( difficulty )
			{
				case eFDDifficultyLevel.HARD:
					armBadgeBodyGroupIndex = 1
					break
				case eFDDifficultyLevel.MASTER:
					armBadgeBodyGroupIndex = 2
					break
				case eFDDifficultyLevel.INSANE:
					armBadgeBodyGroupIndex = 3
					break
				default:
					armBadgeBodyGroupIndex = 0
					break
			}
		}
		charDef.armBadgeModel = armBadgeModel
		charDef.armBadgeBodyGroupIndex = armBadgeBodyGroupIndex
	}

	void function PreviewTitanWeaponCamoChange( entity player, int camoIndex )
	{
		clGlobal.previewMenuTitanModels.weaponCamoIndex = camoIndex
		UpdateTitanModelDisplay( player )
	}

	void function UpdateFactionModel( entity player, int itemIndex )
	{
		if ( !clGlobal.initializedMenuModels ) // Handle early calls that UI script can trigger before client is ready
			return

		array<ItemDisplayData> items = GetVisibleItemsOfType( eItemTypes.FACTION )
		string ref = items[ itemIndex ].ref
		asset model = GetFactionModel( ref )
		int skinIndex = GetFactionModelSkin( ref )
		asset propModel = GetFactionPropModel( ref )
		string idleAnim = GetFactionIdleAnim( ref )

		//bool playIdle = false
		//if ( file.menuFaction.body.GetModelName() != model || idleAnim != file.menuFaction.bodyAnim ) // Model has changed or anim has changed
		//	playIdle = true

		file.menuFaction.body.SetSkin( 0 )
		file.menuFaction.body.SetModel( model )
		file.menuFaction.body.SetSkin( skinIndex )

		entity propEnt = CreateFactionPropModel( file.menuFaction.body, ref )
		if ( IsValid( file.menuFaction.weapon ) )
			file.menuFaction.weapon.Destroy()

		file.menuFaction.weapon = propEnt

		//if ( playIdle )
		//{
			PlayMenuAnim( file.menuFaction.body, idleAnim )
			file.menuFaction.bodyAnim = idleAnim
		//}
	}

	void function UpdateMenuToHarvester()
	{
		thread SpawnHarvester()
	}

	void function SpawnHarvester()
	{
		EndSignal( level, "EndSetPresentationType" )

		while ( !clGlobal.initializedMenuModels ) // Handle early calls that UI script can trigger before client is ready
			WaitFrame()

		vector originOffset = < 450, -700, 0 >
		vector angleOffset = <0, 0, 0>

		file.menuMiscModel.body.SetLocalOrigin( originOffset )
		file.menuMiscModel.body.SetLocalAngles( angleOffset )
		bool success = file.menuMiscModel.body.SetModel( MODEL_HARVESTER_TOWER )

		if ( !success )
			return

		entity harvester = file.menuMiscModel.body
		int attachID = harvester.LookupAttachment( "ref" )
		vector attachOrg = harvester.GetAttachmentOrigin( attachID )
		vector attachAng = harvester.GetAttachmentAngles( attachID )
		entity ringEnt = CreateClientSidePropDynamic( attachOrg, attachAng, MODEL_HARVESTER_TOWER_RINGS )
		ringEnt.SetParent( harvester )
		ringEnt.Anim_Play( "generator_cycle_fast" )
		int harvesterBeamFX = StartParticleEffectOnEntity( harvester, GetParticleSystemIndex( FX_HARVESTER_BEAM ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		EffectSetControlPointVector( harvesterBeamFX, 1, < 126.0, 188.0, 236.0 > )

		OnThreadEnd(
		function() : ( ringEnt, harvesterBeamFX )
			{
				ringEnt.Destroy()
				EffectStop( harvesterBeamFX, true, true )
			}
		)

		WaitForever()
	}

	void function UpdateBoostModel( entity player, int itemIndex )
	{
		if ( !clGlobal.initializedMenuModels ) // Handle early calls that UI script can trigger before client is ready
			return

		array<ItemDisplayData> items = GetVisibleItemsOfType( eItemTypes.BURN_METER_REWARD )
		string ref = items[ itemIndex ].ref
		asset model = GetBoostModel( ref )
		int skinIndex = GetBoostSkin( ref )

		vector originOffset = <0, 0, 0>
		vector angleOffset = <0, 0, 90>

		file.menuMiscModel.body.SetLocalOrigin( originOffset )
		file.menuMiscModel.body.SetLocalAngles( angleOffset )
		file.menuMiscModel.body.SetModel( model )
		file.menuMiscModel.body.SetSkin( skinIndex )
	}

	vector function GetWeaponModelOffset( string weaponRef )
	{
		vector vec = <0, 0, 0>

		switch ( weaponRef )
		{
			case "mp_weapon_sniper":
				vec = <27.5, -2.55, 1.2>
				break
		}

		return vec
	}

	void function UpdateStoreWeaponModelSkin( entity player, string weaponRef, int skinIndex )
	{
		if ( !clGlobal.initializedMenuModels ) // Handle early calls that UI script can trigger before client is ready
			return

		printt( "skinIndex:", skinIndex )

		vector moverOffset = GetWeaponModelOffset( weaponRef )
		file.menuWeaponModel.mover.SetLocalOrigin( moverOffset )

		asset model = GetWeaponViewmodel( weaponRef )
		file.menuWeaponModel.body.SetSkin( 0 ) // Lame, but without this the game can complain that the skin is invalid when the model or skin is changed, regardless of which happens first
		file.menuWeaponModel.body.SetModel( model )
		file.menuWeaponModel.body.SetSkin( skinIndex )

		vector angleOffset = <0, 60, 0>

		string attachmentName = "MENU_ROTATE"
		vector originOffset = GetAttachmentOriginOffset( file.menuWeaponModel.body, attachmentName, angleOffset )

		file.menuWeaponModel.body.SetLocalOrigin( originOffset )
		file.menuWeaponModel.body.SetLocalAngles( angleOffset )
		file.menuWeaponModel.body.Anim_SetPaused( true )
	}

	void function UpdateStoreWeaponModelZoom( entity player, float zoomFrac )
	{
		if ( file.activeCharacter == null )
			return

		if ( Time() - file.lastZoomTime < 0.1 )
			return

		CharacterData character = expect CharacterData( file.activeCharacter )
		if ( zoomFrac == 0 )
			character.fovScale = character.fovScale < 1.0 ? 1.0 : 0.0
		else if ( zoomFrac > 0 )
			character.fovScale = 1.0
		else
			character.fovScale = 0.0

		file.lastZoomTime = Time()
	}

	vector function GetAttachmentOriginOffset( entity ent, string attachName, vector angles )
	{
		int attachIndex = ent.LookupAttachment( attachName )
		ent.SetAngles( angles )
		vector worldOrigin = ent.GetAttachmentOrigin( attachIndex )
		vector localOffset = ent.GetOrigin() - worldOrigin

		return localOffset
	}

	vector function GetWorldSpaceCenterOffset( entity ent, vector angles )
	{
		ent.SetAngles( angles )
		vector worldOrigin = ent.GetWorldSpaceCenter()
		vector localOffset = ent.GetOrigin() - worldOrigin

		return localOffset
	}

	entity function GetMenuMiscModel()
	{
		return file.menuMiscModel.body
	}

	void function UpdateCallsignCard( entity player, int itemIndex )
	{
		if ( !clGlobal.initializedMenuModels ) // Handle early calls that UI script can trigger before client is ready
			return

		#if HAS_WORLD_CALLSIGN
			CallingCard callsignCard = CallingCard_GetByIndex( itemIndex )
			RuiSetImage( file.menuCallsignRui, "cardImage", callsignCard.image )
			RuiSetInt( file.menuCallsignRui, "layoutType", callsignCard.layoutType )
			RuiSetImage( file.menuCallsignRui, "cardGenImage", PlayerXPGetGenIcon( player ) )
		#endif
	}

	void function UpdateCallsignIcon( entity player, int itemIndex )
	{
		if ( !clGlobal.initializedMenuModels ) // Handle early calls that UI script can trigger before client is ready
			return

		#if HAS_WORLD_CALLSIGN
			CallsignIcon callsignIcon = CallsignIcon_GetByIndex( itemIndex )
			RuiSetImage( file.menuCallsignRui, "iconImage", callsignIcon.image )
		#endif
	}

	// TODO: Do we need to account for model strings sometimes having a skin specified by appending ":0", ":1", etc?
	asset function GetSetFileModel( string setFile )
	{
		return GetPlayerSettingsAssetForClassName( setFile, "bodymodel" )
	}

	string function GetPilotLoadoutGenderRace( int loadoutIndex )
	{
		return GetCachedPilotLoadout( loadoutIndex ).race
	}

	string function GetPilotLoadoutSuit( int loadoutIndex )
	{
		return GetCachedPilotLoadout( loadoutIndex ).suit
	}

	int function GetPilotCamoIndex( int loadoutIndex )
	{
		return GetCachedPilotLoadout( loadoutIndex ).camoIndex
	}

	string function GetPilotLoadoutWeapon( int loadoutIndex, int weaponItemType )
	{
		string ref

		if ( weaponItemType == eItemTypes.PILOT_PRIMARY )
			ref = GetCachedPilotLoadout( loadoutIndex ).primary
		else if ( weaponItemType == eItemTypes.PILOT_SECONDARY )
			ref = GetCachedPilotLoadout( loadoutIndex ).secondary
		else if ( weaponItemType == eItemTypes.PILOT_WEAPON3 )
			ref = GetCachedPilotLoadout( loadoutIndex ).weapon3
		else
			Assert( false )

		return ref
	}

	array<string> function GetPilotLoadoutWeaponMods( int loadoutIndex, int weaponItemType )
	{
		array<string> mods

		if ( weaponItemType == eItemTypes.PILOT_PRIMARY )
		{
			mods.append( GetCachedPilotLoadout( loadoutIndex ).primaryMod1 )
			mods.append( GetCachedPilotLoadout( loadoutIndex ).primaryMod2 )
			mods.append( GetCachedPilotLoadout( loadoutIndex ).primaryMod3 )
			mods.append( GetCachedPilotLoadout( loadoutIndex ).primaryAttachment )
		}
		else if ( weaponItemType == eItemTypes.PILOT_SECONDARY )
		{
			mods.append( GetCachedPilotLoadout( loadoutIndex ).secondaryMod1 )
			mods.append( GetCachedPilotLoadout( loadoutIndex ).secondaryMod2 )
			mods.append( GetCachedPilotLoadout( loadoutIndex ).secondaryMod3 )
		}
		else if ( weaponItemType == eItemTypes.PILOT_WEAPON3 )
		{
			mods.append( GetCachedPilotLoadout( loadoutIndex ).weapon3Mod1 )
			mods.append( GetCachedPilotLoadout( loadoutIndex ).weapon3Mod2 )
			mods.append( GetCachedPilotLoadout( loadoutIndex ).weapon3Mod3 )
		}
		else
		{
			Assert( false )
		}

		return mods
	}

	int function GetPilotLoadoutWeaponCamoIndex( int loadoutIndex, int weaponItemType )
	{
		int camoIndex = -1

		if ( weaponItemType == eItemTypes.PILOT_PRIMARY )
			camoIndex = GetCachedPilotLoadout( loadoutIndex ).primaryCamoIndex
		else if ( weaponItemType == eItemTypes.PILOT_SECONDARY )
			camoIndex = GetCachedPilotLoadout( loadoutIndex ).secondaryCamoIndex
		else if ( weaponItemType == eItemTypes.PILOT_WEAPON3 )
			camoIndex = GetCachedPilotLoadout( loadoutIndex ).weapon3CamoIndex
		else
			Assert( false )

		return camoIndex
	}

	int function GetPilotLoadoutWeaponSkinIndex( int loadoutIndex, int weaponItemType )
	{
		int skinIndex = 0

		if ( weaponItemType == eItemTypes.PILOT_PRIMARY )
			skinIndex = GetCachedPilotLoadout( loadoutIndex ).primarySkinIndex
		else if ( weaponItemType == eItemTypes.PILOT_SECONDARY )
			skinIndex = GetCachedPilotLoadout( loadoutIndex ).secondarySkinIndex
		else if ( weaponItemType == eItemTypes.PILOT_WEAPON3 )
			skinIndex = GetCachedPilotLoadout( loadoutIndex ).weapon3SkinIndex
		else
			Assert( false )

		return skinIndex
	}

	string function GetTitanLoadoutSetFile( int loadoutIndex )
	{
		return GetCachedTitanLoadout( loadoutIndex ).setFile
	}

	string function GetTitanLoadoutPrimary( int loadoutIndex )
	{
		return GetCachedTitanLoadout( loadoutIndex ).primary
	}

	int function GetTitanCamoIndex( int loadoutIndex )
	{
		return GetCachedTitanLoadoutCamoIndex( loadoutIndex )
	}

	int function GetTitanSkinIndex( int loadoutIndex )
	{
		return GetCachedTitanLoadoutSkinIndex( loadoutIndex )
	}

	int function GetTitanDecalIndex( int loadoutIndex )
	{
		return GetCachedTitanLoadoutDecalIndex( loadoutIndex )
	}

	asset function GetTitanLoadoutArmBadge( int loadoutIndex )
	{
		return GetCachedTitanLoadoutArmBadge( loadoutIndex )
	}

	int function GetTitanLoadoutArmBadgeState( int loadoutIndex )
	{
		return GetCachedTitanArmBadgeState( loadoutIndex )
	}

	asset function GetFactionModel( string ref )
	{
		var dataTable = GetDataTable( $"datatable/faction_leaders.rpak" )
		int row = GetDataTableRowMatchingStringValue( dataTable, GetDataTableColumnByName( dataTable, "persistenceRef" ), ref )
		asset model = GetDataTableAsset( dataTable, row, GetDataTableColumnByName( dataTable, "modelName" ) )

		return model
	}

	int function GetFactionModelSkin( string ref )
	{
		var dataTable = GetDataTable( $"datatable/faction_leaders.rpak" )
		int row = GetDataTableRowMatchingStringValue( dataTable, GetDataTableColumnByName( dataTable, "persistenceRef" ), ref )
		int skin = GetDataTableInt( dataTable, row, GetDataTableColumnByName( dataTable, "skinIndex" ) )

		return skin
	}

	string function GetFactionPropAttachment( string ref )
	{
		var dataTable = GetDataTable( $"datatable/faction_leaders.rpak" )
		int row = GetDataTableRowMatchingStringValue( dataTable, GetDataTableColumnByName( dataTable, "persistenceRef" ), ref )
		string attachment = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "propAttachment" ) )

		return attachment
	}

	asset function GetFactionPropModel( string ref )
	{
		var dataTable = GetDataTable( $"datatable/faction_leaders.rpak" )
		int row = GetDataTableRowMatchingStringValue( dataTable, GetDataTableColumnByName( dataTable, "persistenceRef" ), ref )
		asset model = GetDataTableAsset( dataTable, row, GetDataTableColumnByName( dataTable, "propModelName" ) )

		return model
	}

	string function GetFactionIdleAnim( string ref )
	{
		var dataTable = GetDataTable( $"datatable/faction_leaders.rpak" )
		int row = GetDataTableRowMatchingStringValue( dataTable, GetDataTableColumnByName( dataTable, "persistenceRef" ), ref )
		string anim = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "menuIdleAnim" ) )

		return anim
	}

	asset function GetBoostModel( string ref )
	{
		var dataTable = GetDataTable( $"datatable/burn_meter_rewards.rpak" )
		int row = GetDataTableRowMatchingStringValue( dataTable, GetDataTableColumnByName( dataTable, "itemRef" ), ref )
		asset model = GetDataTableAsset( dataTable, row, GetDataTableColumnByName( dataTable, "model" ) )

		return model
	}

	void function SavePilotCharacterPreview( entity player )
	{
		clGlobal.currentMenuPilotModels.bodyModel = clGlobal.previewMenuPilotModels.bodyModel
		clGlobal.previewMenuPilotModels.bodyModel = $""

		clGlobal.previewMenuPilotModels.idleAnim = ""

		UpdatePilotModelDisplay( player )
	}

	void function SavePilotWeaponPreview( entity player )
	{
		clGlobal.currentMenuPilotModels.idleAnim = clGlobal.previewMenuPilotModels.idleAnim
		clGlobal.previewMenuPilotModels.idleAnim = ""

		clGlobal.currentMenuPilotModels.weapon = clGlobal.previewMenuPilotModels.weapon
		clGlobal.previewMenuPilotModels.weapon = ""

		clGlobal.currentMenuPilotModels.weaponModel = clGlobal.previewMenuPilotModels.weaponModel
		clGlobal.previewMenuPilotModels.weaponModel = $""

		clGlobal.previewMenuPilotModels.weaponCamoIndex = -1
		clGlobal.previewMenuPilotModels.weaponSkinIndex = -1

		clGlobal.currentMenuPilotModels.mods = []

		UpdatePilotModelDisplay( player )
	}

	void function SavePilotWeaponModPreview( entity player )
	{
		clGlobal.currentMenuPilotModels.mods = clGlobal.previewMenuPilotModels.mods
		clGlobal.previewMenuPilotModels.mods = []
		UpdatePilotModelDisplay( player )
	}

	//void function SavePilotCamoPreview( entity player )
	//{
	//	clGlobal.currentMenuPilotModels.camoIndex = clGlobal.previewMenuPilotModels.camoIndex
	//	clGlobal.previewMenuPilotModels.camoIndex = -1
	//	UpdatePilotModelDisplay( player )
	//}

	void function ClearAllPilotPreview( entity player )
	{
		clGlobal.previewMenuPilotModels.bodyModel = $""
		clGlobal.previewMenuPilotModels.camoIndex = -1
		clGlobal.previewMenuPilotModels.weapon = ""
		clGlobal.previewMenuPilotModels.weaponModel = $""
		clGlobal.previewMenuPilotModels.weaponCamoIndex = -1
		clGlobal.previewMenuPilotModels.weaponSkinIndex = -1
		clGlobal.previewMenuPilotModels.mods = []
		clGlobal.previewMenuPilotModels.idleAnim = ""
		UpdatePilotModelDisplay( player )
	}

	void function SaveTitanDecalPreview( entity player )
	{
		clGlobal.currentMenuTitanModels.decalIndex = clGlobal.previewMenuTitanModels.decalIndex
		clGlobal.previewMenuTitanModels.decalIndex = -1
		UpdateTitanModelDisplay( player )
	}

	void function ClearTitanDecalPreview( entity player )
	{
		clGlobal.previewMenuTitanModels.decalIndex = -1
		UpdateTitanModelDisplay( player )
	}

	void function SaveTitanCamoPreview( entity player )
	{
		clGlobal.currentMenuTitanModels.camoIndex = clGlobal.previewMenuTitanModels.camoIndex
		clGlobal.previewMenuTitanModels.camoIndex = -1

		clGlobal.currentMenuTitanModels.skinIndex = clGlobal.previewMenuTitanModels.skinIndex
		clGlobal.previewMenuTitanModels.skinIndex = 0

		UpdateTitanModelDisplay( player )
	}

	void function ClearTitanCamoPreview( entity player )
	{
		clGlobal.previewMenuTitanModels.camoIndex = -1
		clGlobal.previewMenuTitanModels.skinIndex = 0

		UpdateTitanModelDisplay( player )
	}

	void function ClearTitanCombinedPreview( entity player )
	{
		clGlobal.previewMenuTitanModels.camoIndex = -1
		clGlobal.previewMenuTitanModels.skinIndex = 0

		clGlobal.previewMenuTitanModels.armBadgeBodyGroupIndex = -1
		clGlobal.previewMenuTitanModels.armBadgeModel = $""

		UpdateTitanModelDisplay( player )
	}

	void function SaveTitanSkinPreview( entity player )
	{
		clGlobal.currentMenuTitanModels.skinIndex = clGlobal.previewMenuTitanModels.skinIndex
		clGlobal.previewMenuTitanModels.skinIndex = 0

		clGlobal.currentMenuTitanModels.camoIndex = clGlobal.previewMenuTitanModels.camoIndex
		clGlobal.previewMenuTitanModels.camoIndex = -1

		UpdateTitanModelDisplay( player )
	}

	void function SaveTitanCombinedPreview( entity player )
	{
		clGlobal.currentMenuTitanModels.skinIndex = clGlobal.previewMenuTitanModels.skinIndex
		clGlobal.previewMenuTitanModels.skinIndex = 0

		clGlobal.currentMenuTitanModels.camoIndex = clGlobal.previewMenuTitanModels.camoIndex
		clGlobal.previewMenuTitanModels.camoIndex = -1

		clGlobal.currentMenuTitanModels.armBadgeModel = clGlobal.previewMenuTitanModels.armBadgeModel
		clGlobal.previewMenuTitanModels.armBadgeModel = $""

		clGlobal.currentMenuTitanModels.armBadgeBodyGroupIndex = clGlobal.previewMenuTitanModels.armBadgeBodyGroupIndex
		clGlobal.previewMenuTitanModels.armBadgeBodyGroupIndex = -1

		UpdateTitanModelDisplay( player )
	}

	void function ClearTitanSkinPreview( entity player )
	{
		clGlobal.previewMenuTitanModels.camoIndex = -1
		clGlobal.previewMenuTitanModels.skinIndex = 0
		UpdateTitanModelDisplay( player )
	}

	void function ClearAllTitanPreview( entity player )
	{
		clGlobal.previewMenuTitanModels.bodyModel = $""
		clGlobal.previewMenuTitanModels.camoIndex = -1
		clGlobal.previewMenuTitanModels.skinIndex = 0
		clGlobal.previewMenuTitanModels.decalIndex = -1
		//clGlobal.previewMenuTitanModels.armBadgeModel = $"" // Not sure why these aren't in here. These should be uncommented when we're sure it's safe to.
		//clGlobal.previewMenuTitanModels.armBadgeBodyGroupIndex = -1
		clGlobal.previewMenuTitanModels.weaponModel = $""
		clGlobal.previewMenuTitanModels.weaponCamoIndex = -1
		clGlobal.previewMenuTitanModels.idleAnim = ""
		UpdateTitanModelDisplay( player )
	}

	void function PlayMenuAnim( entity model, string anim )
	{
		float animCycle = model.GetCycle()

		//printt( "PlayMenuAnim(", model, ",",  anim, ")" )

		model.Anim_NonScriptedPlay( anim )
		model.SetCycle( animCycle )
	}

	void function SetPresentationType( entity player, int presentationType, bool interpolate )
	{
		thread SetPresentationTypeThread( player, presentationType, interpolate )
	}

	void function SetPresentationTypeThread( entity player, int presentationType, bool interpolate )
	{
		Signal( level, "EndSetPresentationType" )
		EndSignal( level, "EndSetPresentationType" )

		while ( !clGlobal.initializedMenuModels )
			WaitFrame()

		// setting menu camera while our viewentity isn't player will crash
		// unfortunately no way to close menu if we get our viewentity set while menu is open atm
		while ( GetViewEntity().GetClassName() == "class C_BaseEntity" )
			WaitFrame()

		if ( file.presentationTypeInitialized && presentationType == file.presentationType )
			return

		file.presentationType = presentationType

		if ( !file.presentationTypeInitialized )
			file.presentationTypeInitialized = true

		if ( file.presentationData[ presentationType ].activateFunc != null )
			file.presentationData[ presentationType ].activateFunc()

		if ( IsValid( player ) )
			SetMenuCamera( player, presentationType, interpolate )

		CharacterData ornull lastActiveCharacter = file.activeCharacter
		file.activeCharacter = file.presentationData[ presentationType ].characterData

		#if HAS_WORLD_CALLSIGN
		if ( !file.presentationData[ presentationType ].showCallsign )
		{
			RuiSetFloat( file.menuCallsignRui, "cardAlpha", 0.0 )
		}
		else
		{
			RuiSetFloat( file.menuCallsignRui, "cardAlpha", 1.0 )
		}
		#endif

		if ( !file.presentationData[ presentationType ].showStoreBG )
			file.menuStoreBackground.Hide()
		else
			file.menuStoreBackground.Show()

		if ( !file.presentationData[ presentationType ].showStorePrimeBG )
		{
			if ( file.menuStorePrimeBgCreated )
			{
				file.menuStorePrimeBgCreated = false
				RuiTopology_Destroy( file.menuStorePrimeBg )
				RuiDestroy( file.menuStorePrimeBgRui )
			}
		}
		else
		{
			file.menuStorePrimeBgCreated = true
			file.menuStorePrimeBg = RuiTopology_CreatePlane( < -91.6658, 453.079, 463.765>, <399.802, -12.5803, 0.000155184>, <3.28334, 104.34, -386.138>, false )
			file.menuStorePrimeBgRui = RuiCreate( $"ui/prime_titan_bg.rpak", file.menuStorePrimeBg, RUI_DRAW_WORLD, 0 )
		}

		if ( file.presentationData[ presentationType ].showMiscModel )
			file.menuMiscModel.body.Show()
		else
			file.menuMiscModel.body.Hide()

		if ( file.presentationData[ presentationType ].showWeaponModel )
		{
			//file.weaponDLight.SetLightColor( WEAPON_DLIGHT_COLOR )
			file.menuWeaponModel.body.Show()
		}
		else
		{
			//file.weaponDLight.SetLightColor( <0, 0, 0> )
			file.menuWeaponModel.body.Hide()
		}

		if ( file.presentationData[ presentationType ].showTitanModel )
		{
			file.menuTitan.body.Show()
			file.menuTitan.weapon.Show()
			if ( IsValid( file.menuTitan.prop ) )
				file.menuTitan.prop.Show()
			if ( IsValid( file.menuTitan.armBadge ) )
				file.menuTitan.armBadge.Show()
		}
		else
		{
			file.menuTitan.body.Hide()
			file.menuTitan.weapon.Hide()
			if ( IsValid( file.menuTitan.prop ) )
				file.menuTitan.prop.Hide()
			if ( IsValid( file.menuTitan.armBadge ) )
				file.menuTitan.armBadge.Hide()
		}

		if ( lastActiveCharacter != null )
			ResetCharacterRotation( expect CharacterData( lastActiveCharacter ) )
	}

	void function SetMenuCamera( entity player, int presentationType, bool interpolate )
	{
		string sceneAnim = file.presentationData[ presentationType ].sceneAnim
		clGlobal.menuSceneModel.Anim_PlayWithRefPoint( sceneAnim, file.sceneRef.GetOrigin(), file.sceneRef.GetAngles() + <0, -90, 0>, 0 )
		if ( !interpolate )
			clGlobal.menuSceneModel.Anim_SetStartTime( 1.0 )

		if ( presentationType == ePresentationType.INACTIVE )
		{
			SetMapSetting_CsmTexelScale( 1.0, 1.0 )
			SetMapSetting_CsmStartDistance( 0.0 )

			player.ClearMenuCameraEntity()
			printt( "Clearing menu camera" )
			player.SetScriptMenuOff()
			return
		}

		player.SetScriptMenuOn()

		float fov = file.presentationData[ presentationType ].fov
		player.SetMenuCameraEntity( clGlobal.menuCamera )
		clGlobal.menuCamera.SetTarget( file.cameraTarget, fov, interpolate, EASING_CUBIC_INOUT, TRANSITION_DURATION )

		//EASING_LINEAR
		//EASING_SINE_IN
		//EASING_SINE_OUT
		//EASING_SINE_INOUT
		//EASING_CIRC_IN
		//EASING_CIRC_OUT
		//EASING_CIRC_INOUT
		//EASING_CUBIC_IN
		//EASING_CUBIC_OUT
		//EASING_CUBIC_INOUT
		//EASING_BACK_IN
		//EASING_BACK_OUT
		//EASING_BACK_INOUT

		float dofNearStart 	= file.presentationData[ presentationType ].dofNearStart
		float dofNearEnd 	= file.presentationData[ presentationType ].dofNearEnd
		float dofFarStart 	= file.presentationData[ presentationType ].dofFarStart
		float dofFarEnd 	= file.presentationData[ presentationType ].dofFarEnd

		if ( interpolate )
			printt( "Interpolating menu camera to:", Dev_GetEnumString( ePresentationType, presentationType ) )
		else
			printt( "Snapping menu camera to:", Dev_GetEnumString( ePresentationType, presentationType ) )

		if ( interpolate )
		{
			DoF_LerpNearDepth( dofNearStart, dofNearEnd, TRANSITION_DURATION )
			DoF_LerpFarDepth( dofFarStart, dofFarEnd, TRANSITION_DURATION )
		}
		else
		{
			DoF_SetNearDepth( dofNearStart, dofNearEnd )
			DoF_SetFarDepth( dofFarStart, dofFarEnd )
		}

		DoFSetDilateInfocus( true ) // We want to reduce DoF aliasing around bright edges in the menus.

#if CONSOLE_PROG
		const float texelNorm = 2.0
#else
		const float texelNorm = 1.0
#endif

		float csmTexelScale1	= file.presentationData[ presentationType ].csmTexelScale1 * texelNorm
		float csmTexelScale2	= file.presentationData[ presentationType ].csmTexelScale2 * texelNorm
		float csmStartDistance	= file.presentationData[ presentationType ].csmStartDistance

		// Tweaks in order to maximize the shadow space usage for the pilot and/or the titan.
		// Used the convar csm_debug_2d to find the best values on PC.
		SetMapSetting_CsmTexelScale( csmTexelScale1, csmTexelScale2 )
		SetMapSetting_CsmStartDistance( csmStartDistance )
	}

	void function ModelRotationThread()
	{
		for ( ;; )
		{
			WaitFrame()

			if ( file.activeCharacter == null )
				continue

			CharacterData character = expect CharacterData( file.activeCharacter )
			float[2] rotationDelta

			if ( IsControllerModeActive() )
			{
				const float STICK_DEADZONE = 0.05
				float stickXRaw = clamp( InputGetAxis( ANALOG_RIGHT_X ), -1.0, 1.0 )
				float stickXRemappedAbs = (fabs( stickXRaw ) < STICK_DEADZONE) ? 0.0 : ((fabs( stickXRaw ) - STICK_DEADZONE) / (1.0 - STICK_DEADZONE))
				float stickX = EaseIn( stickXRemappedAbs ) * (stickXRaw < 0.0 ? -1.0 : 1.0)

				rotationDelta[0] = ((character.rotationDelta[0] + stickX * character.maxTurnSpeed * FrameTime()) % 360.0)

				float stickYRaw = clamp( InputGetAxis( ANALOG_RIGHT_Y ), -1.0, 1.0 )
				float stickYRemappedAbs = (fabs( stickYRaw ) < STICK_DEADZONE) ? 0.0 : ((fabs( stickYRaw ) - STICK_DEADZONE) / (1.0 - STICK_DEADZONE))
				float stickY = EaseIn( stickYRemappedAbs ) * (stickYRaw < 0.0 ? -1.0 : 1.0)

				rotationDelta[1] = ((character.rotationDelta[1] + stickY * character.maxTurnSpeed * FrameTime()) % 360.0)
			}
			else
			{
				rotationDelta[0] = ((character.rotationDelta[0] + file.mouseRotateDelta[0] * FrameTime()) % 360.0)
				file.mouseRotateDelta[0] = 0 // clear because otherwise it would keep spinning

				rotationDelta[1] = ((character.rotationDelta[1] + file.mouseRotateDelta[1] * FrameTime()) % 360.0)
				file.mouseRotateDelta[1] = 0 // clear because otherwise it would keep spinning
			}

			float maxTurnDegrees = file.presentationData[ file.presentationType ].maxTurnDegrees
			if ( maxTurnDegrees < 360.0 )
			{
				float minRotationDelta = 0 - (maxTurnDegrees / 2)
				float maxRotationDelta = maxTurnDegrees / 2
				rotationDelta[0] = clamp( rotationDelta[0], minRotationDelta, maxRotationDelta )
			}

			float maxPitchDegrees = file.presentationData[ file.presentationType ].maxPitchDegrees
			if ( maxPitchDegrees < 360.0 )
			{
				float minRotationDelta = 0 - (maxPitchDegrees / 2)
				float maxRotationDelta = maxPitchDegrees / 2
				rotationDelta[1] = clamp( rotationDelta[1], minRotationDelta, maxRotationDelta )
			}

			character.rotationDelta[0] = rotationDelta[0]
			character.rotationDelta[1] = rotationDelta[1]

			vector defaultAngles = clGlobal.menuSceneModel.GetAttachmentAngles( clGlobal.menuSceneModel.LookupAttachment( character.attachName ) )
			vector newAng

			/*
				if ( file.presentationData[ file.presentationType ].useRollAxis )
					newAng = <defaultAngles.x, defaultAngles.y + character.rotationDelta[0], defaultAngles.z  + character.rotationDelta[1]>
				else
					newAng = <defaultAngles.x + character.rotationDelta[1], defaultAngles.y + character.rotationDelta[0], defaultAngles.z>
			*/

			vector pitchTowardCamera = < -rotationDelta[1], 0, 0> //AnglesCompose( <0, -90, 0>, AnglesCompose( <rotationDelta[1], 0, 0>, <0, 90, 0> ) )

//			newAng = <defaultAngles.x, defaultAngles.y + character.rotationDelta[0], defaultAngles.z>
			newAng = AnglesCompose( defaultAngles, pitchTowardCamera )
			newAng = AnglesCompose( newAng, <0, character.rotationDelta[0], 0> )

			float fov = file.presentationData[ file.presentationType ].fov
			float finalFOV = GraphCapped( character.fovScale, 0.0, 1.0, fov * 0.6, fov )
			clGlobal.menuCamera.SetTarget( file.cameraTarget, finalFOV, true, EASING_CUBIC_INOUT, 0.05 )

			character.mover.SetAngles( newAng )
		}
	}

	void function ResetCharacterRotation( CharacterData character )
	{
		entity mover = character.mover
		vector defaultAngles = clGlobal.menuSceneModel.GetAttachmentAngles( clGlobal.menuSceneModel.LookupAttachment( character.attachName ) )
		vector currentAngles = mover.GetAngles()
		character.rotationDelta[0] = 0.0
		character.rotationDelta[1] = 0.0
		character.fovScale = 1.0

		if ( currentAngles == defaultAngles )
			return

		// Get the reset time for the degrees we need to turn to get back to defaultAngles based on a maxDuration time for the worst case which is 180 degrees
		float absNormDeg = fabs( currentAngles.y - defaultAngles.y % 360.0 )
		float diffDeg = min( 360.0 - absNormDeg, absNormDeg )
		float maxDuration = 0.5
		float duration = diffDeg * (maxDuration / 180)
		float easeTime = duration / 3

		if ( duration > 0 )
			mover.NonPhysicsRotateTo( defaultAngles, duration, easeTime, easeTime )
		else
			mover.SetAngles( defaultAngles )
	}

	void function SetMenuOpenState( entity player, int state )
	{
		bool wasSoloDialogMenuOpen = clGlobal.isSoloDialogMenuOpen

		clGlobal.isMenuOpen = (state == 1)
		clGlobal.isSoloDialogMenuOpen = (state == 2);
		if ( clGlobal.isSoloDialogMenuOpen != wasSoloDialogMenuOpen )
			UpdateMainHudVisibility( player )

		if ( clGlobal.mapSupportsMenuModels && IsMultiplayer() && !IsLobby() )
		{
			if ( clGlobal.isMenuOpen )
			{
				ColorCorrection_SetExclusive( file.menuColorCorrection, true )
				ColorCorrection_SetWeight( file.menuColorCorrection, 1.0 )

				SetMapSetting_FogEnabled( false )
			}
			else
			{
				DoF_SetNearDepthToDefault()
				DoF_SetFarDepthToDefault()
				DoFSetDilateInfocus( false );

				ColorCorrection_SetWeight( file.menuColorCorrection, 0.0 )
				ColorCorrection_SetExclusive( file.menuColorCorrection, false )

				SetMapSetting_FogEnabled( true )
			}
		}
	}

	void function UpdateMouseRotateDelta( entity player, float deltaX, float deltaY )
	{
		file.mouseRotateDelta[0] = deltaX
		file.mouseRotateDelta[1] = deltaY
	}
#endif // CLIENT

#if UI
	void function RunMenuClientFunction( string func, var arg1 = null, var arg2 = null, var arg3 = null )
	{
		if ( !CanRunClientScript() || !uiGlobal.mapSupportsMenuModels )
			return

		if ( arg1 == null )
			RunClientScript( func, GetLocalClientPlayer() )
		else if ( arg2 == null )
			RunClientScript( func, GetLocalClientPlayer(), arg1 )
		else if ( arg3 == null )
			RunClientScript( func, GetLocalClientPlayer(), arg1, arg2 )
		else
			RunClientScript( func, GetLocalClientPlayer(), arg1, arg2, arg3 )
	}

	void function UI_SetPresentationType( int newPresentationType )
	{
		if ( IsFullyConnected() && uiGlobal.mapSupportsMenuModels )
		{
			if ( uiGlobal.activePresentationType == ePresentationType.NO_MODELS || newPresentationType == ePresentationType.NO_MODELS ||
				 uiGlobal.activePresentationType == ePresentationType.FACTIONS || newPresentationType == ePresentationType.FACTIONS ||
				 uiGlobal.activePresentationType == ePresentationType.BOOSTS || newPresentationType == ePresentationType.BOOSTS ||
				 uiGlobal.activePresentationType == ePresentationType.STORE_FRONT || newPresentationType == ePresentationType.STORE_FRONT ||
				 uiGlobal.activePresentationType == ePresentationType.PVE_MAIN || newPresentationType == ePresentationType.PVE_MAIN ||
				 uiGlobal.activePresentationType == ePresentationType.DEFAULT && newPresentationType == ePresentationType.STORE_WEAPON_SKINS ||
				 uiGlobal.activePresentationType == ePresentationType.STORE_WEAPON_SKINS && newPresentationType == ePresentationType.DEFAULT ||
				 uiGlobal.activePresentationType == ePresentationType.PILOT_WEAPON && newPresentationType == ePresentationType.STORE_WEAPON_SKINS ||
				 uiGlobal.activePresentationType == ePresentationType.STORE_WEAPON_SKINS && newPresentationType == ePresentationType.PILOT_WEAPON ||
				 uiGlobal.activePresentationType == ePresentationType.INACTIVE )
			{
				uiGlobal.interpolateCameraMoves = false
			}
			else
			{
				uiGlobal.interpolateCameraMoves = true
			}

			// When loading the lobby we don't want any interpolation
			if ( uiGlobal.lobbyFromLoadingScreen )
			{
				uiGlobal.interpolateCameraMoves = false
				uiGlobal.lobbyFromLoadingScreen	= false
			}

			RunClientScript( "SetPresentationType", GetLocalClientPlayer(), newPresentationType, uiGlobal.interpolateCameraMoves )

			uiGlobal.activePresentationType = newPresentationType

			if ( newPresentationType == ePresentationType.FD_MAIN ||
				newPresentationType == ePresentationType.FD_FIND_GAME
				)
				RunClientScript( "UpdateMenuToHarvester" )
		}
	}

	void function UICodeCallback_MouseMovementCapture( var capturePanel, int deltaX, int deltaY )
	{
		float screenScaleXModifier = 1920.0 / GetScreenSize()[0] // 1920 is base screen width
		float mouseXRotateDelta = deltaX * screenScaleXModifier * MOUSE_ROTATE_MULTIPLIER
		//printt( "deltaX:", deltaX, "deltaY:", deltaY )

		float screenScaleYModifier = 1080.0 / GetScreenSize()[1] // 1920 is base screen width
		float mouseYRotationDelta = deltaY * screenScaleYModifier * MOUSE_ROTATE_MULTIPLIER

		UpdateMouseDeltaBuffer( deltaX, deltaY )
        ModelUpdateMouseDeltaBuffer( deltaX, deltaY )

		RunMenuClientFunction( "UpdateMouseRotateDelta", mouseXRotateDelta, mouseYRotationDelta )
	}
#endif // UI
