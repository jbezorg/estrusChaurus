Scriptname zzChaurusEggsScript extends ObjectReference  

GlobalVariable            Property zzEstrusFertilityChance  Auto  
GlobalVariable            Property zzEstrusChaurusInfestation  Auto  
ActorBase                 Property zzEncChaurusHachling  Auto  
ImpactDataSet             Property MAGSpiderSpitImpactSet  Auto  
zzEstrusChaurusMCMScript  Property MCM Auto

Bool bIsTested        = False
Actor ChaurusHachling = None
Float fUpdate         = 0.0
Int iIncubationIdx    = 0

Event OnLoad()
	if ( !bIsTested && zzEstrusChaurusInfestation.GetValueInt() as bool && Utility.RandomInt( 0, 100 ) < zzEstrusFertilityChance.GetValueInt() )
		fUpdate = Utility.RandomFloat( 48.0, 96.0 )

		iIncubationIdx = 1
		while ( iIncubationIdx < MCM.kHatchingEgg.Length && MCM.kHatchingEgg[iIncubationIdx] != None )
			iIncubationIdx += 1
		endWhile
		
		MCM.fHatchingDue[iIncubationIdx] = (fUpdate/24.0) + Utility.GetCurrentGameTime()
		MCM.kHatchingEgg[iIncubationIdx] = self
		RegisterForSingleUpdateGameTime( fUpdate )
	endIf
	bIsTested = True
EndEvent

Event OnUpdateGameTime()
	PlayImpactEffect(MAGSpiderSpitImpactSet, "Egg:0")
	ChaurusHachling = PlaceActorAtMe( zzEncChaurusHachling ).EvaluatePackage()

	MCM.fHatchingDue[iIncubationIdx] = 0.0
	MCM.kHatchingEgg[iIncubationIdx] = none
	Delete()
EndEvent

