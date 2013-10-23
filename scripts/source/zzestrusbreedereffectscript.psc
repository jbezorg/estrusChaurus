Scriptname zzEstrusBreederEffectScript extends activemagiceffect

Float function eggChain()
	ObjectReference thisThing = kTarget.PlaceAtme(xMarker)
	ObjectReference[] thisEgg = new ObjectReference[13]

	thisThing.moveToNode(kTarget, NINODE_SKIRT02)
	thisThing.MoveTo(thisThing, 3.0 * Math.Sin(thisThing.GetAngleZ()), 3.0 * Math.Cos(thisThing.GetAngleZ()), afZOffset = 3.0)

	Sound.SetInstanceVolume( zzEstrusBreastPainMarker.Play(kTarget), 1.0 )
	Int idx = 0
	Int len = Utility.RandomInt( 7, 13 )
	while idx < len
		thisEgg[idx] = thisThing.PlaceAtme(ChaurusEggs)
		thisEgg[idx].SetActorOwner( kTarget.GetActorBase() )
		if idx != 0
			; 0.0636
			Game.AddHavokBallAndSocketConstraint( thisEgg[idx - 1], "Egg:0", thisEgg[idx], "Egg:0", afRefALocalOffsetZ = 0.1 )
		endif
		idx += 1
		Utility.Wait( 0.1 )
	endWhile

	thisThing.Delete()
	return len / 10
endFunction

function oviposition()
	bool finished = false
	float fReduction
	float fBreastReduction
	float fButtReduction

	; make sure we have 3d loaded to access
	while ( !kTarget.Is3DLoaded() )
		Utility.Wait( 1.0 )
	endWhile
	if ( zzEstrusChaurusUninstall.GetValueInt() == 1 )
		GoToState("AFTERMATH")
	endIf

	fReduction       = eggChain()
	fBreastReduction = fReduction / 2.0
	fButtReduction   = fReduction / 2.0

	if ( bBellyEnabled )
		fPregBelly = fPregBelly - fReduction

		if ( fPregBelly < fOrigBelly )
			fPregBelly = fOrigBelly
		endif

		finished = ( fPregBelly == fOrigBelly )

		NetImmerse.SetNodeScale( kTarget, NINODE_BELLY, fPregBelly, false)
		if ( kTarget == kPlayer )
			NetImmerse.SetNodeScale( kTarget, NINODE_BELLY, fPregBelly, true)
		endif
	endif
	
	; BUTT SWELL ======================================================
	if ( bButtEnabled )
		fPregLeftButt  = fPregLeftButt  - fButtReduction
		fPregRightButt = fPregRightButt - fButtReduction

		if ( fPregLeftButt < fOrigLeftButt )
			fPregLeftButt = fOrigLeftButt
		endif
		if ( fPregRightButt < fOrigRightButt )
			fPregRightButt = fOrigRightButt
		endif
		
		if ( !bBellyEnabled && !bBreastEnabled )
			finished = ( fPregRightButt == fOrigRightButt || fPregLeftButt == fOrigLeftButt )
		endIF

		NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BUTT, fPregLeftButt, false)
		NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BUTT, fPregRightButt, false)
		if ( kTarget == kPlayer )
			NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BUTT, fPregLeftButt, true)
			NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BUTT, fPregRightButt, true)
		endif
	endif

	

	if ( bBreastEnabled )
		fPregLeftBreast    = fPregLeftBreast - fBreastReduction
		fPregRightBreast   = fPregRightBreast - fBreastReduction
		if bTorpedoFixEnabled
			fPregLeftBreast01  = fOrigLeftBreast01 * (fOrigLeftBreast / fPregLeftBreast)
			fPregRightBreast01 = fOrigRightBreast01 * (fOrigRightBreast / fPregRightBreast)
		endIf

		if ( fPregLeftBreast < fOrigLeftBreast )
			fPregLeftBreast = fOrigLeftBreast
		endif
		if ( fPregRightBreast < fOrigRightBreast )
			fPregRightBreast = fOrigRightBreast
		endif
		if bTorpedoFixEnabled
			if ( fPregLeftBreast01 < fOrigLeftBreast01 )
				fPregLeftBreast01 = fOrigLeftBreast01
			endif
			if ( fPregRightBreast01 < fOrigRightBreast01 )
				fPregRightBreast01 = fOrigRightBreast01
			endif
		endif
		
		if ( !bBellyEnabled && !bButtEnabled )
			finished = ( fPregRightBreast == fOrigRightBreast || fPregLeftBreast == fOrigLeftBreast )
		endIF

		NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST, fPregLeftBreast, false)
		NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST, fPregRightBreast, false)
		if bTorpedoFixEnabled
			NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST01, fPregLeftBreast01, false)
			NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST01, fPregRightBreast01, false)
		endIf
		if ( kTarget == kPlayer )
			NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST, fPregRightBreast, true)
			NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST, fPregLeftBreast, true)
			if bTorpedoFixEnabled
				NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST01, fPregRightBreast01, true)
				NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST01, fPregLeftBreast01, true)
			endif
		endif
	endif
	
	if !bBellyEnabled && !bBreastEnabled
		fPregBelly = fPregBelly - fReduction

		if ( fPregBelly < fOrigBelly )
			fPregBelly = fOrigBelly
		endif

		finished = ( fPregBelly == fOrigBelly )
	endIf

	Utility.Wait( Utility.RandomFloat( fOviparityTime, fOviparityTime * 2.0 ) )
	if ( !finished )
		oviposition()
	Else
		Debug.Trace("_EC_::GTS::AFTERMATH")
		GoToState("AFTERMATH")
	endif
endFunction

function manageSexLabAroused(int aiModRank = -1)
	if !MCM.kfSLAExposure
		return
	endIf
	
	if aiModRank == 0 || iOrigSLAExposureRank < -2
		iOrigSLAExposureRank = kTarget.GetFactionRank(MCM.kfSLAExposure)
	endIf
	if aiModRank < 0
		kTarget.SetFactionRank(MCM.kfSLAExposure, iOrigSLAExposureRank)
	endIf
	if aiModRank > 0 && kTarget.GetFactionRank(MCM.kfSLAExposure) < 100
		kTarget.ModFactionRank(MCM.kfSLAExposure, aiModRank)
	endIf
endFunction

event OnUpdateGameTime()
	Utility.Wait( 5.0 )

	Debug.Trace("_EC_::GTS::BIRTHING")
	GoToState("BIRTHING")
endEvent

state IMPREGNATE
	event OnBeginState()
		Debug.Trace("_EC_::state::IMPREGNATE")
	endEvent

	event OnUpdate()
		if ( zzEstrusChaurusUninstall.GetValueInt() == 1 )
			GoToState("AFTERMATH")
		endIf

		if ( !kTarget.IsInFaction( SexLabAnimatingFaction ) )
			; all will be false if bDisableNodeChange is true
			if ( bBellyEnabled || bBreastEnabled || bButtEnabled )
				GoToState("INCUBATION_NODE")
			Else
				GoToState("INCUBATION")
			endif
		endif

		RegisterForSingleUpdate( fWaitingTime )
	endEvent
endState

state INCUBATION_NODE
	event OnBeginState()
		Debug.Trace("_EC_::state::INCUBATION" )
	endEvent

	event OnUpdate()
		if ( zzEstrusChaurusUninstall.GetValueInt() == 1 )
			GoToState("AFTERMATH")
		endIf
		; catch a state change caused by RegisterForSingleUpdate
		if ( GetState() == "INCUBATION_NODE" )
			while ( kTarget.IsOnMount() || Utility.IsInMenuMode() )
				Utility.Wait( 2.0 )
			endWhile
			; make sure we have 3d loaded to access
			while ( !kTarget.Is3DLoaded() )
				Utility.Wait( 1.0 )
			endWhile
			fGameTime       = Utility.GetCurrentGameTime()
			fInfectionSwell = ( fGameTime - fInfectionStart ) / 5.0
			fBellySwell     = 0.0
			fBreastSwell    = 0.0
			
			; SexLab Aroused ==================================================
			manageSexLabAroused(1)
			
			; BREAST SWELL ====================================================
			iBreastSwellGlobal = zzEstrusSwellingBreasts.GetValueInt()
			if ( bBreastEnabled && iBreastSwellGlobal )
				fBreastSwell       = fInfectionSwell / iBreastSwellGlobal
				fPregLeftBreast    = fOrigLeftBreast + fBreastSwell
				fPregRightBreast   = fOrigRightBreast + fBreastSwell
				if bTorpedoFixEnabled
					fPregLeftBreast01  = fOrigLeftBreast01 * (fOrigLeftBreast / fPregLeftBreast)
					fPregRightBreast01 = fOrigRightBreast01 * (fOrigRightBreast / fPregRightBreast)
				endIf

				if fInfectionLastMsg < fGameTime && fInfectionSwell > 0.05
					fInfectionLastMsg = fGameTime + Utility.RandomFloat(0.0417, 0.25)
					Debug.Notification(sSwellingMsgs[Utility.RandomInt(0, sSwellingMsgs.Length - 1)])
					Sound.SetInstanceVolume( zzEstrusBreastPainMarker.Play(kTarget), 1.0 )
				endif

				if ( fPregLeftBreast > NINODE_MAX_SCALE )
					fPregLeftBreast = NINODE_MAX_SCALE
				endif
				if ( fPregRightBreast > NINODE_MAX_SCALE )
					fPregRightBreast = NINODE_MAX_SCALE
				endif
				if bTorpedoFixEnabled
					if ( fPregLeftBreast01 < NINODE_MIN_SCALE )
						fPregLeftBreast01 = NINODE_MIN_SCALE
					endif
					if ( fPregRightBreast01 < NINODE_MIN_SCALE )
						fPregRightBreast01 = NINODE_MIN_SCALE
					endif
				endif
				if ( fPregLeftBreast > zzEstrusChaurusMaxBreastScale.GetValue() )
					fPregLeftBreast = zzEstrusChaurusMaxBreastScale.GetValue()
				endif
				if ( fPregRightBreast > zzEstrusChaurusMaxBreastScale.GetValue() )
					fPregRightBreast = zzEstrusChaurusMaxBreastScale.GetValue()
				endif

				kTarget.SetAnimationVariableFloat("ecBreastSwell", fBreastSwell)
				NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST, fPregLeftBreast, false)
				NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST, fPregRightBreast, false)
				if bTorpedoFixEnabled
					NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST01, fPregLeftBreast01, false)
					NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST01, fPregRightBreast01, false)
				endIf
				if ( kTarget == kPlayer )
					NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST, fPregRightBreast, true)
					NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST, fPregLeftBreast, true)
					if bTorpedoFixEnabled
						NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST01, fPregRightBreast01, true)
						NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST01, fPregLeftBreast01, true)
					endIf
				endif
			elseIf ( bBreastEnabled && ( fPregLeftBreast != fOrigLeftBreast || fPregRightBreast != fOrigRightBreast ) )
				fPregLeftBreast    = fOrigLeftBreast
				fPregRightBreast   = fOrigRightBreast
				if bTorpedoFixEnabled
					fPregLeftBreast01  = fOrigLeftBreast01
					fPregRightBreast01 = fOrigRightBreast01
				endIf
				
				kTarget.SetAnimationVariableFloat("ecBreastSwell", 0.0)
				NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST, fPregLeftBreast, false)
				NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST, fPregRightBreast, false)
				if bTorpedoFixEnabled
					NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST01, fPregLeftBreast01, false)
					NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST01, fPregRightBreast01, false)
				endIf
				if ( kTarget == kPlayer )
					NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST, fPregRightBreast, true)
					NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST, fPregLeftBreast, true)
					if bTorpedoFixEnabled
						NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST01, fPregRightBreast01, true)
						NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST01, fPregLeftBreast01, true)
					endif
				endif
			endif

			; BELLY SWELL =====================================================
			iBellySwellGlobal = zzEstrusSwellingBelly.GetValueInt()
			if ( bBellyEnabled && iBellySwellGlobal )
				fBellySwell = fInfectionSwell / iBellySwellGlobal
				fPregBelly  = fOrigBelly + fBellySwell

				if fInfectionLastMsg < fGameTime && fInfectionSwell > 0.05
					fInfectionLastMsg = fGameTime + Utility.RandomFloat(0.0417, 0.25)
					Sound.SetInstanceVolume( zzEstrusBreastPainMarker.Play(kTarget), 1.0 )
				endif

				if ( fPregBelly > NINODE_MAX_SCALE * 2.0 )
					fPregBelly = NINODE_MAX_SCALE * 2.0 
				endif
				if ( fPregBelly > zzEstrusChaurusMaxBellyScale.GetValue() )
					fPregBelly = zzEstrusChaurusMaxBellyScale.GetValue()
				endif

				kTarget.SetAnimationVariableFloat("ecBellySwell", fBellySwell)
				NetImmerse.SetNodeScale( kTarget, NINODE_BELLY, fPregBelly, false)
				if ( kTarget == kPlayer )
					NetImmerse.SetNodeScale( kTarget, NINODE_BELLY, fPregBelly, true)
				endif
			elseIf ( bBellyEnabled && fPregBelly != fOrigBelly )
				fPregBelly = fOrigBelly
				kTarget.SetAnimationVariableFloat("ecBellySwell", 0.0)
				NetImmerse.SetNodeScale( kTarget, NINODE_BELLY, fPregBelly, false)
				if ( kTarget == kPlayer )
					NetImmerse.SetNodeScale( kTarget, NINODE_BELLY, fPregBelly, true)
				endif
			endif

			; BUTT SWELL ======================================================
			iButtSwellGlobal = zzEstrusSwellingBelly.GetValueInt()
			if ( bButtEnabled && iButtSwellGlobal )
				fButtSwell     = fInfectionSwell / iButtSwellGlobal
				fPregLeftButt  = fOrigLeftButt  + fButtSwell
				fPregRightButt = fOrigRightButt + fButtSwell

				if fInfectionLastMsg < fGameTime && fInfectionSwell > 0.05
					fInfectionLastMsg = fGameTime + Utility.RandomFloat(0.0417, 0.25)
					Sound.SetInstanceVolume( zzEstrusBreastPainMarker.Play(kTarget), 1.0 )
				endif

				if ( fPregLeftButt > NINODE_MAX_SCALE )
					fPregLeftButt = NINODE_MAX_SCALE 
				endif
				if ( fPregRightButt > NINODE_MAX_SCALE )
					fPregRightButt = NINODE_MAX_SCALE 
				endif
				if ( fPregLeftButt > zzEstrusChaurusMaxButtScale.GetValue() )
					fPregLeftButt = zzEstrusChaurusMaxButtScale.GetValue()
				endif
				if ( fPregRightButt > zzEstrusChaurusMaxButtScale.GetValue() )
					fPregRightButt = zzEstrusChaurusMaxButtScale.GetValue()
				endif

				NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BUTT, fPregLeftButt, false)
				NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BUTT, fPregRightButt, false)
				if ( kTarget == kPlayer )
					NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BUTT, fPregLeftButt, true)
					NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BUTT, fPregRightButt, true)
				endif
			elseIf ( bButtEnabled && ( fPregLeftButt != fOrigLeftButt || fPregRightButt != fOrigRightButt ) )
				fPregLeftButt = fOrigLeftButt
				fPregRightButt = fOrigRightButt

				NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BUTT, fPregLeftButt, false)
				NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BUTT, fPregRightButt, false)
				if ( kTarget == kPlayer )
					NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BUTT, fPregLeftButt, true)
					NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BUTT, fPregRightButt, true)
				endif
			endif

			if !kTarget.IsOnMount() && ( ( bBreastEnabled && iBreastSwellGlobal ) || ( bBellyEnabled && iBellySwellGlobal ) || ( bButtEnabled && iButtSwellGlobal ) )
				kTarget.QueueNiNodeUpdate()
			endIf
			
			kTarget.SetFactionRank(zzEstrusChaurusBreederFaction, Math.Floor(fBellySwell + fBreastSwell) )
			RegisterForSingleUpdate( fUpdateTime )
		endif
	endEvent
endState

state INCUBATION
	event OnBeginState()
		fOrigBelly = 1.0
		fPregBelly = NINODE_MAX_SCALE * 2.0
		Debug.Trace("_EC_::state::INCUBATION")
	endEvent

	event OnUpdate()
		if ( zzEstrusChaurusUninstall.GetValueInt() == 1 )
			GoToState("AFTERMATH")
		endIf

		; catch a state change caused by RegisterForSingleUpdate
		if ( GetState() == "INCUBATION" )
			; SexLab Aroused ==================================================
			manageSexLabAroused(1)

			RegisterForSingleUpdate( fUpdateTime )
		endif
	endEvent
endState

state BIRTHING
	event OnBeginState()
		Debug.Trace("_EC_::state::BIRTHING")
		while ( kTarget.IsOnMount() || Utility.IsInMenuMode() )
			Utility.Wait( 2.0 )
		endWhile
		Debug.SendAnimationEvent(kTarget, "BleedOutStart")
		Utility.Wait( 10.0 )

		;iBirthingLoops = Utility.RandomInt( 6, 10 )
		if bIsFemale
			kTarget.AddItem(zzEstrusChaurusFluid, 1, true)
			kTarget.EquipItem(zzEstrusChaurusFluid, true, true)
			kTarget.AddItem(zzEstrusChaurusMilkR, 1, true)
			kTarget.EquipItem(zzEstrusChaurusMilkR, true, true)
			kTarget.AddItem(zzEstrusChaurusMilkL, 1, true)
			kTarget.EquipItem(zzEstrusChaurusMilkL, true, true)
		endIf
		oviposition()
	endEvent

	event OnEndState()
		Debug.SendAnimationEvent(kTarget, "BleedOutStop")
	endEvent

	event OnUpdate()
		; catch any pending updates
	endEvent
endState

state AFTERMATH
	event OnBeginState()
		Debug.Trace("_EC_::state::AFTERMATH")

		if bIsFemale
			kTarget.UnequipItem(zzEstrusChaurusFluid, false, true)
			kTarget.RemoveItem(zzEstrusChaurusFluid, 1, true)
			kTarget.UnequipItem(zzEstrusChaurusMilkR, false, true)
			kTarget.RemoveItem(zzEstrusChaurusMilkR, 1, true)
			kTarget.UnequipItem(zzEstrusChaurusMilkL, false, true)
			kTarget.RemoveItem(zzEstrusChaurusMilkL, 1, true)
		endIf

		kTarget.RemoveSpell(zzEstrusChaurusBreederAbility)
	endEvent

	event OnUpdate()
		; catch any pending updates
	endEvent
endState

event OnEffectStart(Actor akTarget, Actor akCaster)
	kTarget            = akTarget
	kCaster            = akCaster
	kPlayer            = Game.GetPlayer()
	bDisableNodeChange = zzEstrusDisableNodeResize.GetValue() as Bool
	
	sSwellingMsgs      = new String[3]
	sSwellingMsgs[0]   = "$EC_SWELLING_1_3RD"
	sSwellingMsgs[1]   = "$EC_SWELLING_2_3RD"
	sSwellingMsgs[2]   = "$EC_SWELLING_3_3RD"

	GoToState("IMPREGNATE")
	zzEstrusChaurusInfected.Mod( 1.0 )
	kTarget.StopCombatAlarm()

	Float fMinTime     = zzEstrusIncubationPeriod.GetValue() * fIncubationTimeMin
	Float fMaxTime     = zzEstrusIncubationPeriod.GetValue() * fIncubationTimeMax
	fIncubationTime    = Utility.RandomFloat( fMinTime, fMaxTime )
	fInfectionStart    = Utility.GetCurrentGameTime()
	fthisIncubation    = fInfectionStart + ( fIncubationTime / 24.0 )
	bEnableSkirt02     = NetImmerse.HasNode(kTarget, NINODE_SKIRT02, false)
	bEnableSkirt03     = NetImmerse.HasNode(kTarget, NINODE_SKIRT03, false)
	bIsFemale          = kTarget.GetLeveledActorBase().GetSex() == 1
	bTorpedoFixEnabled = zzEstrusChaurusTorpedoFix.GetValueInt() as Bool

	;kCaster.PathToReference(kTarget, 1.0)
	
	if ( !kTarget.IsInFaction(zzEstrusChaurusBreederFaction) )
		kTarget.AddToFaction(zzEstrusChaurusBreederFaction)
	endIf

	if kTarget == kPlayer
		iIncubationIdx = 0
		MCM.fIncubationDue[iIncubationIdx] = fthisIncubation
		MCM.kIncubationDue[iIncubationIdx] = kTarget

		if kPlayer.GetAnimationVariableInt("i1stPerson") as bool
			Game.ForceThirdPerson()
		endIf
	else
		iIncubationIdx = MCM.kIncubationDue.Find(none, 1)
		if iIncubationIdx != -1
			MCM.fIncubationDue[iIncubationIdx] = fthisIncubation
			MCM.kIncubationDue[iIncubationIdx] = kTarget
		else
			kTarget.RemoveSpell(zzEstrusChaurusBreederAbility)
			return
		endif
	endif

	; SexLab Aroused
	manageSexLabAroused(0)

	if ( !bDisableNodeChange )
		; make sure we have loaded 3d to access
		while ( !kTarget.Is3DLoaded() )
			Utility.Wait( 1.0 )
		endWhile

		bEnableLeftBreast  = NetImmerse.HasNode(kTarget, NINODE_LEFT_BREAST, false)
		bEnableRightBreast = NetImmerse.HasNode(kTarget, NINODE_RIGHT_BREAST, false)
		bEnableLeftButt    = NetImmerse.HasNode(kTarget, NINODE_LEFT_BUTT, false)
		bEnableRightButt   = NetImmerse.HasNode(kTarget, NINODE_RIGHT_BUTT, false)
		bEnableBelly       = NetImmerse.HasNode(kTarget, NINODE_BELLY, false)

		bBreastEnabled     = ( bEnableLeftBreast && bEnableRightBreast && zzEstrusSwellingBreasts.GetValueInt() as bool )
		bButtEnabled       = ( bEnableLeftButt && bEnableRightButt && zzEstrusSwellingButt.GetValueInt() as bool )
		bBellyEnabled      = ( bEnableBelly && zzEstrusSwellingBelly.GetValueInt() as bool )

		if ( bBreastEnabled && kTarget.GetLeveledActorBase().GetSex() == 1 )
			fOrigLeftBreast  = NetImmerse.GetNodeScale(kTarget, NINODE_LEFT_BREAST, false)
			fOrigRightBreast = NetImmerse.GetNodeScale(kTarget, NINODE_RIGHT_BREAST, false)
			if bTorpedoFixEnabled
				fOrigLeftBreast01  = NetImmerse.GetNodeScale(kTarget, NINODE_LEFT_BREAST01, false)
				fOrigRightBreast01 = NetImmerse.GetNodeScale(kTarget, NINODE_RIGHT_BREAST01, false)
			endif
		endif
		if ( bButtEnabled )
			fOrigLeftButt    = NetImmerse.GetNodeScale(kTarget, NINODE_LEFT_BUTT, false)
			fOrigRightButt   = NetImmerse.GetNodeScale(kTarget, NINODE_RIGHT_BUTT, false)
		endif
		if ( bBellyEnabled )
			fOrigBelly       = NetImmerse.GetNodeScale(kTarget, NINODE_BELLY, false)
		endif
	endif

	if bEnableSkirt02
		RegisterForSingleUpdate( fUpdateTime )
		RegisterForSingleUpdateGameTime( fIncubationTime )
	Else
		Debug.MessageBox("$EC_INCOMPATIBLE")
		kTarget.RemoveSpell(zzEstrusChaurusBreederAbility)
	endif
endEvent

event OnEffectFinish(Actor akTarget, Actor akCaster)
	zzEstrusChaurusInfected.Mod( -1.0 )
	bUninstall = zzEstrusChaurusUninstall.GetValueInt() as Bool

	if iIncubationIdx != -1
		MCM.fIncubationDue[iIncubationIdx] = 0.0
		MCM.kIncubationDue[iIncubationIdx] = None
	endIf

	if ( kTarget.IsInFaction(zzEstrusChaurusBreederFaction) )
		kTarget.RemoveFromFaction(zzEstrusChaurusBreederFaction)
	endIf

	; if we are uninstalling, report the first 128 infected NPCs
	if ( bUninstall )
		iIncubationIdx = MCM.kIncubationOff.Find(none)
		if ( iIncubationIdx >= 0 )
			MCM.kIncubationOff[iIncubationIdx] = kTarget
		endif
	endIf
	
	; SexLab Aroused
	manageSexLabAroused()

	if ( !bDisableNodeChange )
		; make sure we have loaded 3d to access
		while ( !kTarget.Is3DLoaded() )
			Utility.Wait( 1.0 )
		endWhile

		if ( bBellyEnabled )
			NetImmerse.SetNodeScale( kTarget, NINODE_BELLY, fOrigBelly, false)
			if ( kTarget == kPlayer )
				NetImmerse.SetNodeScale( kTarget, NINODE_BELLY, fOrigBelly, true)
			endif
		endif

		if ( bButtEnabled )
			NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BUTT, fOrigLeftButt, false)
			NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BUTT, fOrigRightButt, false)
			if ( kTarget == kPlayer )
				NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BUTT, fOrigLeftButt, true)
				NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BUTT, fOrigRightButt, true)
			endif
		endif

		if ( bBreastEnabled )
			NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST, fOrigLeftBreast, false)
			NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST, fOrigRightBreast, false)
			if bTorpedoFixEnabled
				NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST01, fOrigLeftBreast01, false)
				NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST01, fOrigRightBreast01, false)
			endIf

			if ( kTarget == kPlayer )
				NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST, fOrigLeftBreast, true)
				NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST, fOrigRightBreast, true)
				if bTorpedoFixEnabled
					NetImmerse.SetNodeScale( kTarget, NINODE_LEFT_BREAST01, fOrigLeftBreast01, true)
					NetImmerse.SetNodeScale( kTarget, NINODE_RIGHT_BREAST01, fOrigRightBreast01, true)
				endif
			endif
		endif
	endif
endEvent

Actor kTarget            = None
Actor kCaster            = None
Actor kPlayer            = None
Bool  bDisableNodeChange = False
Bool  bEnableLeftBreast  = False
Bool  bEnableRightBreast = False
Bool  bEnableLeftButt    = False
Bool  bEnableRightButt   = False
Bool  bEnableBelly       = False
Bool  bEnableSkirt02     = False
Bool  bEnableSkirt03     = False
Bool  bBreastEnabled     = False
Bool  bButtEnabled       = False
Bool  bBellyEnabled      = False
Bool  bUninstall         = False
Bool  bIsFemale          = False
Bool  bTorpedoFixEnabled = True
Float fOrigLeftBreast    = 1.0
Float fPregLeftBreast    = 1.0
Float fOrigLeftBreast01  = 1.0
Float fPregLeftBreast01  = 1.0
Float fOrigLeftButt      = 1.0
Float fPregLeftButt      = 1.0
Float fOrigRightBreast   = 1.0
Float fPregRightBreast   = 1.0
Float fOrigRightBreast01 = 1.0
Float fPregRightBreast01 = 1.0
Float fOrigRightButt     = 1.0
Float fPregRightButt     = 1.0
Float fOrigBelly         = 1.0
Float fPregBelly         = 1.0
Float fInfectionStart    = 0.0
Float fInfectionSwell    = 0.0
Float fInfectionLastMsg  = 0.0
Float fBreastSwell       = 0.0
Int   iBreastSwellGlobal = 0
Float fButtSwell         = 0.0
Int   iButtSwellGlobal   = 0
Float fBellySwell        = 0.0
Int   iBellySwellGlobal  = 0
Float fUpdateTime        = 5.0
Float fWaitingTime       = 10.0
Float fOviparityTime     = 7.5
; * zzEstrusIncubationPeriod ( days )
Float fIncubationTimeMin = 22.6
Float fIncubationTimeMax = 26.6
Float fthisIncubation    = 0.0
Float fGameTime          = 0.0
Int iIncubationIdx       = -1
Int iBirthingLoops       = 6
; SexLab Aroused
Int iOrigSLAExposureRank = -3

String[] sSwellingMsgs

zzEstrusChaurusMCMScript Property MCM Auto

Armor                    Property zzEstrusChaurusFluid  Auto
Armor                    Property zzEstrusChaurusMilkR  Auto
Armor                    Property zzEstrusChaurusMilkL  Auto
Faction                  Property CurrentFollowerFaction  Auto
Faction                  Property zzEstrusChaurusBreederFaction  Auto
Faction                  Property SexLabAnimatingFaction  Auto
GlobalVariable           Property zzEstrusDisableNodeResize  Auto
GlobalVariable           Property zzEstrusIncubationPeriod  Auto
GlobalVariable           Property zzEstrusSwellingBreasts  Auto
GlobalVariable           Property zzEstrusSwellingBelly  Auto
GlobalVariable           Property zzEstrusSwellingButt  Auto
GlobalVariable           Property zzEstrusChaurusUninstall  Auto
GlobalVariable           Property zzEstrusChaurusInfected  Auto
GlobalVariable           Property zzEstrusChaurusMaxBreastScale  Auto  
GlobalVariable           Property zzEstrusChaurusMaxBellyScale  Auto
GlobalVariable           Property zzEstrusChaurusMaxButtScale  Auto
GlobalVariable           Property zzEstrusChaurusTorpedoFix  Auto  
Ingredient               Property ChaurusEggs  Auto
Spell                    Property zzEstrusChaurusBreederAbility  Auto
Sound                    Property zzEstrusBreastPainMarker  Auto
Static                   Property xMarker  Auto
Float                    Property fIncubationTime  Auto

String                   Property NINODE_LEFT_BREAST    = "NPC L Breast" AutoReadOnly
String                   Property NINODE_LEFT_BREAST01  = "NPC L Breast01" AutoReadOnly
String                   Property NINODE_LEFT_BUTT      = "NPC L Butt" AutoReadOnly
String                   Property NINODE_RIGHT_BREAST   = "NPC R Breast" AutoReadOnly
String                   Property NINODE_RIGHT_BREAST01 = "NPC R Breast01" AutoReadOnly
String                   Property NINODE_RIGHT_BUTT     = "NPC R Butt" AutoReadOnly
String                   Property NINODE_SKIRT02        = "SkirtBBone02" AutoReadOnly
String                   Property NINODE_SKIRT03        = "SkirtBBone03" AutoReadOnly
String                   Property NINODE_BELLY          = "NPC Belly" AutoReadOnly
Float                    Property NINODE_MAX_SCALE      = 3.0 AutoReadOnly
Float                    Property NINODE_MIN_SCALE      = 0.1 AutoReadOnly
