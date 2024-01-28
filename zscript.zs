version "4.6"

//Sound queue utils
#include "zscript/Utils/SoundQueue/Toby_SoundQueueStaticHandler.zs"
#include "zscript/Utils/SoundQueue/Toby_QueuedSound.zs"
#include "zscript/Utils/SoundQueue/Toby_StringToSoundQueue.zs"
#include "zscript/Utils/SoundQueue/Toby_SoundQueue.zs"
#include "zscript/Utils/SoundQueue/Toby_NumberToSoundQueue.zs"
#include "zscript/Utils/SoundQueue/Toby_MonthToSoundQueue.zs"

//Player status checker
#include "zscript/StatusChecker/Toby_PlayerStatusCondition.zs"
#include "zscript/StatusChecker/Toby_HealthChecker.zs"
#include "zscript/StatusChecker/Toby_AmmoChecker.zs"
#include "zscript/StatusChecker/Toby_KeyChecker.zs"
#include "zscript/StatusChecker/Toby_ArmorChecker.zs"
#include "zscript/StatusChecker/Toby_PlayerStatusCheckStaticHandler.zs"

//Compass
#include "zscript/Compass/Toby_CompassEventHandler.zs"

//Markers
#include "zscript/Markers/ZS_MarkerHandler.zs"
#include "zscript/Markers/Toby_Markers.zs"

//Dropdoff detector
#include "zscript/DropoffDetector/Toby_DropoffSoundEmitter.zs"
#include "zscript/DropoffDetector/Toby_DropoffSoundEmitterManagerItem.zs"
#include "zscript/DropoffDetector/Toby_WallDetector.zs"
#include "zscript/DropoffDetector/Toby_DropoffDetectorHandler.zs"

//Target detector
#include "zscript/TargetDetector/Toby_TargetDetector.zs"
#include "zscript/TargetDetector/Toby_TargetDetectorEntry.zs"
#include "zscript/TargetDetector/Toby_TargetDetectorStaticHandler.zs"
#include "zscript/TargetDetector/Toby_TargetDetectorHandler.zs"

//Map announcements
#include "zscript/MapAnnouncements/Toby_MapAnnouncementManager.zs"
#include "zscript/MapAnnouncements/Toby_MapAnnouncementEntry.zs"
#include "zscript/MapAnnouncements/Toby_MapAnnouncementStaticHandler.zs"

//Hitmarkers
#include "zscript/hitmarkers.zsc"

//Snap to target
#include "zscript/SnapToTarget/Toby_SnapToTargetHandler.zs"

//Accessible menus
#include "zscript/AccessibleMenu/Toby_MenuStaticHandler.zs"
#include "zscript/AccessibleMenu/Toby_TitleScreenHandler.zs"
#include "zscript/AccessibleMenu/Toby_MenuState.zs"
#include "zscript/AccessibleMenu/Toby_MenuEventProcessor.zs"

//Utils
#include "zscript/Utils/Toby_SoundBindingsContainer.zs"
#include "zscript/Utils/Toby_WadsUtils.zs"
#include "zscript/Utils/Toby_Logger.zs"
#include "zscript/Utils/Toby_SaveGameUtils.zs"

//libeye
#include "zscript/libeye/Toby_projector gl.zs"
#include "zscript/libeye/Toby_projector planar.zs"
#include "zscript/libeye/Toby_projector.zs"
#include "zscript/libeye/Toby_viewport.zs"

//Actors in viewport
#include "zscript/ActorsInViewport/Toby_ActorsInViewportStaticHandler.zs"
#include "zscript/ActorsInViewport/Toby_ViewportProjector.zs"
#include "zscript/ActorsInViewport/Toby_ViewportOnScreenDebug.zs"
#include "zscript/ActorsInViewport/Toby_ActorsInViewportStorage.zs"
#include "zscript/ActorsInViewport/Toby_ActorsInViewportActorCounter.zs"
#include "zscript/ActorsInViewport/Toby_NameAndAmount.zs"
#include "zscript/ActorsInViewport/Toby_ActorCounterToSoundQueue.zs"
#include "zscript/ActorsInViewport/Toby_ActorsInViewportPresets.zs"
#include "zscript/ActorsInViewport/Filters/Toby_ActorFilter.zs"
#include "zscript/ActorsInViewport/Filters/Toby_ActorFilterDistance.zs"
#include "zscript/ActorsInViewport/Filters/Toby_ActorFilterVerticalDistance.zs"
#include "zscript/ActorsInViewport/Filters/Toby_ActorFilterAll.zs"
#include "zscript/ActorsInViewport/Filters/Toby_ActorFilterHorizontalScreenPosition.zs"
#include "zscript/ActorsInViewport/Filters/Toby_ActorFilterLogicAnd.zs"
#include "zscript/ActorsInViewport/Filters/Toby_ActorFilterLogicNot.zs"
#include "zscript/ActorsInViewport/Filters/Toby_ActorFilterRemains.zs"
