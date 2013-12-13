Scriptname zzEstrusChaurusAE extends _ae_mod_base  

; VERSION 1
sslSystemConfig           property SexLabMCM                        auto
SexLabFramework           property SexLab                           auto
Faction                   property chaurus                          auto
Faction                   property SexLabAnimating                  auto
Spell                     property crChaurusParasite                auto 
MagicEffect[]             property crChaurusPoison                  auto 
Armor                     property zzEstrusChaurusParasite          auto  
Armor                     property zzEstrusChaurusFluid             auto  
GlobalVariable            property zzEstrusChaurusFluids            auto  

; VERSION 2
Spell                     property zzEstrusChaurusBreederAbility    auto
Faction                   property zzEstrusChaurusBreederFaction    auto

; VERSION 3
Faction                   property CurrentFollowerFaction           auto
Keyword                   property ActorTypeNPC                     auto

; VERSION 5
zzEstrusChaurusMCMScript  property mcm                              auto 

; VERSION 6
Faction                   property CurrentHireling                  auto

; VERSION 8
Armor                     property zzEstrusChaurusDwemerBinders     auto


; VERSION 11
Faction                   property zzEstrusChaurusExclusionFaction  auto

; VERSION 1
Actor[]            sexActors
sslBaseAnimation[] animations

; START AE CONTROLS ===========================================================
; This will be called during the mod selection process to see if the actor in
; question qualifies for your event. If this function returns false then your
; mod will be skipped.
;
; If it is not defined in your mod then your mod events will not be triggered.
Bool function qualifyActor(Actor akActor = none, String asStat = "")
	if !akActor || akActor.IsDead() || akActor.IsDisabled() || akActor.IsInFaction(zzEstrusChaurusExclusionFaction)
		return false
	endIf

	Bool bDeviousBelt = mcm.kwDeviousDevices != none && akActor.WornHasKeyword(mcm.kwDeviousDevices)

	if asStat == ae.HEALTH && !ae.isRagdolling(akActor) && !akActor.IsInFaction(SexLabAnimating) && !bDeviousBelt
		int idx       = crChaurusPoison.Length
		Actor kTarget = akActor.GetCombatTarget()

		if kTarget && kTarget.IsInFaction(chaurus)
			Debug.TraceConditional("EC::qualifyActor:faction:true", ae.VERBOSE)
			return true
		endIf

		while idx > 0
			idx -= 1
			if akActor.HasMagicEffect(crChaurusPoison[idx])
				Debug.TraceConditional("EC::qualifyActor:effect:true", ae.VERBOSE)
				return true
			endIf
		endWhile
	endIf

	Debug.TraceConditional("EC::qualifyActor:false", ae.VERBOSE)
	return false
endFunction

; This may be called during AE's cleanup process. Possibly due to a refid
; change. It will reregister the mod with AE.
function aeRegisterMod()
	myIndex = ae.register(self, 9, 4, myEvent, ae.HEALTH)
endFunction

; This function will be called when the user permanently disables the mod
; through the AE MCM menu.
function aeUninstallMod()
	Stop()
endFunction
; END AE CONTROLS =============================================================

; START AE VERSIONING =========================================================
; This functions exactly as and has the same purpose as the SkyUI function
; GetVersion(). It returns the static version of the AE script.
int function aeGetVersion()
	return 11
endFunction

function aeUpdate( int aiVersion )
	if (myVersion >= 2 && aiVersion < 2)
		zzEstrusChaurusBreederAbility = Game.GetFormFromFile(0x00019121, "EstrusChaurus.esp") as Spell
		zzEstrusChaurusBreederFaction = Game.GetFormFromFile(0x000160a9, "EstrusChaurus.esp") as Faction
	endIf
	if (myVersion >= 3 && aiVersion < 3)
		myActorsList = New Actor[10]
		myActorsList[0] = Game.GetPlayer()

		CurrentFollowerFaction = Game.GetFormFromFile(0x0005c84e, "Skyrim.esm") as Faction
		ActorTypeNPC = Game.GetFormFromFile(0x00013794, "Skyrim.esm") as Keyword
	endIf
	if (myVersion >= 4 && aiVersion < 4)
		myActorsList = New Actor[20]
		myActorsList[0] = Game.GetPlayer()
	endIf
	if (myVersion >= 5 && aiVersion < 5)	
		mcm = ( self as quest ) as zzEstrusChaurusMCMScript
	endIf
	if (myVersion >= 6 && aiVersion < 6)
		CurrentHireling = Game.GetFormFromFile(0x000bd738, "Skyrim.esm") as Faction
	endIf
	if (myVersion >= 7 && aiVersion < 7)
		myActorsList = New Actor[20]

		int idx = myActorsList.length
		while idx > 1
			idx -= 1
			myActorsList[idx] = none
		endWhile

		myActorsList[0] = Game.GetPlayer()
	endIf
	if (myVersion >= 10 && aiVersion < 10)
		zzEstrusChaurusDwemerBinders = Game.GetFormFromFile(0x00039e74, "EstrusChaurus.esp") as Armor
	endIf
	if (myVersion >= 11 && aiVersion < 11)
		zzEstrusChaurusExclusionFaction = Game.GetFormFromFile(0x0004058b, "EstrusChaurus.esp") as Faction
	endIf
endFunction
; END AE VERSIONING ===========================================================

event OnInit()
	aeRegisterMod()
endEvent

; START EC FUNCTIONS ==========================================================
int function AddCompanions()
	myActorsList[0] = Game.GetPlayer()

	Actor thisActor = none
	Int   thisCount = 0
	Cell  thisCell  = myActorsList[0].GetParentCell()
	Int   idxNPC    = thisCell.GetNumRefs(43)
	
	Bool  check1    = false
	Bool  check2    = false
	Bool  check3    = false
	
	Debug.Notification("$EC_COMPANIONS_CHECK")
	
	while idxNPC > 0 && thisCount < 19
		idxNPC -= 1
		thisActor = thisCell.GetNthRef(idxNPC,43) as Actor
		
		check1 = thisActor && !thisActor.IsDead() && !thisActor.IsDisabled()
		check2 = check1 && myActorsList.Find(thisActor) < 0 && thisActor.HasKeyword(ActorTypeNPC)
		check3 = check2 && ( thisActor.GetFactionRank(CurrentHireling) >= 0 || thisActor.GetFactionRank(CurrentFollowerFaction) >= 0 || thisActor.IsPlayerTeammate() )

		if check3
			thisCount += 1
			myActorsList[thisCount] = thisActor
			Debug.TraceConditional("EC::AddCompanions: " + thisActor.GetLeveledActorBase().GetName() + "@"+thisCount, ae.VERBOSE)
		else
			Debug.TraceConditional("EC::AddCompanions: " + thisActor.GetLeveledActorBase().GetName() + ":false", ae.VERBOSE)
		endif
	endWhile
	
	aeRegisterActors()
	
	return thisCount
endFunction

function RemoveCompanions()
	Int idxNPC = myActorsList.length
	while idxNPC > 1
		idxNPC -= 1
		ae.monitor(myActorsList[idxNPC], false)
		myActorsList[idxNPC] = none
	endWhile
endFunction
; END EC FUNCTIONS ============================================================

; On a EC Health Event
event OnECEvent(String asEventName, string asStat, float afStatValue, Form akSender)
	Debug.TraceConditional("EC::OnECEvent: " + asEventName, ae.VERBOSE)
	Actor kSender   = akSender as Actor
	Bool  bGenderOk = mcm.zzEstrusChaurusGender.GetValueInt() == 2 || kSender.GetLeveledActorBase().GetSex() == mcm.zzEstrusChaurusGender.GetValueInt()

	if bGenderOk && asEventName == myEvent + ae._START && asStat == ae.HEALTH && SexLab.ValidateActor(kSender) == 1
		Int chaurusRape = 0
		Actor kAttacker = ae.GetLastAttacker(kSender) as Actor
		
		kSender.StopCombatAlarm()
		kSender.StopCombat()
		kSender.DispelAllSpells()
		kSender.RestoreActorValue(ae.HEALTH, 10000)

		if kAttacker
			chaurusRape = SexLab.ValidateActor(kAttacker)
			kAttacker.StopCombatAlarm()
			kAttacker.StopCombat()

			if ( !kAttacker.IsInFaction(zzEstrusChaurusBreederFaction) )
				kAttacker.AddToFaction(zzEstrusChaurusBreederFaction)
			endIf
		endIf

		if ( !kSender.IsInFaction(zzEstrusChaurusBreederFaction) )
			kSender.AddToFaction(zzEstrusChaurusBreederFaction)
		endIf
		if ( !kSender.HasSpell(zzEstrusChaurusBreederAbility) )
			kSender.AddSpell(zzEstrusChaurusBreederAbility, false)
		endIf		

		Debug.TraceConditional("EC::SexLab.ValidateActor(kAttacker) = " + chaurusRape, ae.VERBOSE)
		
		if chaurusRape == 1 && kAttacker.IsInFaction(chaurus) && kAttacker.GetDistance(kSender) < 384.0
			animations   = SexLab.GetAnimationsByTag(2, "Creature", "Chaurus")
			sexActors    = new actor[2]
			sexActors[0] = kSender
			sexActors[1] = kAttacker
			crChaurusParasite.RemoteCast(kAttacker, kAttacker, kSender)
		else 
			animations   = SexLab.GetAnimationsByTag(1, "Estrus", "Tentacle")
			sexActors    = new actor[1]
			sexActors[0] = kSender
			crChaurusParasite.RemoteCast(kSender, kSender, kSender)
		endIf

		RegisterForModEvent("AnimationStart_estrusChaurus", "estrusChaurusStart")
		RegisterForModEvent("AnimationEnd_estrusChaurus",   "estrusChaurusEnd")
		RegisterForModEvent("StageEnd_estrusChaurus",       "estrusChaurusStage")

		if SexLab.StartSex(sexActors, animations, Victim=kSender, hook="estrusChaurus") < 0
			sexActors[0].DispelSpell(crChaurusParasite)
		endIf
		
		if kSender == Game.GetPlayer()
			SexLab.AdjustPlayerPurity(-5.0)
		endIf
	endIf
endEvent

; Sexlab Events
event estrusChaurusStart(string eventName, string argString, float argNum, form sender)
	sslThreadController control = SexLab.HookController(argString)
	sslBaseAnimation anim       = SexLab.HookAnimation(argString)
	actor[] actorList           = SexLab.HookActors(argString)
	
	actorList[0].RestoreActorValue(ae.HEALTH, 10000)
	if anim.name == "Tentacle Side"
		actorList[0].AddItem(zzEstrusChaurusParasite, 1, true)
		actorList[0].EquipItem(zzEstrusChaurusParasite, true, true)
	endIf
	if anim.name == "Dwemer Machine"
		actorList[0].AddItem(zzEstrusChaurusDwemerBinders, 1, true)
		actorList[0].EquipItem(zzEstrusChaurusDwemerBinders, true, true)
	endIf
	UnregisterForModEvent("AnimationStart_estrusChaurus")
endEvent

event estrusChaurusEnd(string eventName, string argString, float argNum, form sender)
	actor[] actorList = SexLab.HookActors(argString)
	
	int cnt = actorList[0].GetItemCount(zzEstrusChaurusFluid)
	if cnt > 0
		actorList[0].UnequipItem(zzEstrusChaurusFluid, false, true)
		actorList[0].RemoveItem(zzEstrusChaurusFluid, cnt, true)
	endIf

	UnregisterForModEvent("AnimationEnd_estrusChaurus")
	UnregisterForModEvent("StageEnd_estrusChaurus")

	actorList[0].SendModEvent(publicModEvents[0])
	actorList[0].DispelSpell(crChaurusParasite)
endEvent

event estrusChaurusStage(string eventName, string argString, float argNum, form sender)
	sslBaseAnimation anim = SexLab.HookAnimation(argString)
	actor[] actorList     = SexLab.HookActors(argString)
	int stage             = SexLab.HookStage(argString)
	int cntParasite       = actorList[0].GetItemCount(zzEstrusChaurusParasite)
	int cntBinders        = actorList[0].GetItemCount(zzEstrusChaurusDwemerBinders)

	actorList[0].RestoreActorValue(ae.HEALTH, 10000)
	if stage >= 2
		SexLab.ApplyCum(actorList[0], 7)
	endIf
	if stage == 3 && zzEstrusChaurusFluids.GetValue() as bool
		actorList[0].AddItem(zzEstrusChaurusFluid, 1, true)
		actorList[0].EquipItem(zzEstrusChaurusFluid, true, true)
	endIf
	if cntParasite > 0 && stage == 9
		actorList[0].UnequipItem(zzEstrusChaurusParasite, false, true)
		actorList[0].RemoveItem(zzEstrusChaurusParasite, cntParasite, true)
	endIf
	if cntBinders > 0 && stage == 9
		actorList[0].UnequipItem(zzEstrusChaurusDwemerBinders, false, true)
		actorList[0].RemoveItem(zzEstrusChaurusDwemerBinders, cntBinders, true)
	endIf
endEvent

