version "4.6"

//Sound queue utils
#include "zscript/Utils/SoundQueue/Toby_SoundQueueStaticHandler.zs"
#include "zscript/Utils/SoundQueue/Toby_QueuedSound.zs"
#include "zscript/Utils/SoundQueue/Toby_StringToSoundQueue.zs"
#include "zscript/Utils/SoundQueue/Toby_SoundQueue.zs"
#include "zscript/Utils/SoundQueue/Toby_NumberToSoundQueue.zs"
#include "zscript/Utils/SoundQueue/Toby_MonthToSoundQueue.zs"

//Sound bindings loader
#include "zscript/SoundBindings/Toby_SoundBindingsLoaderStaticHandler.zs"

//Class ignore lists loader
#include "zscript/IgnoreLists/Toby_ClassIgnoreListLoaderStaticHandler.zs"

//Player status checker
#include "zscript/StatusChecker/Toby_PlayerStatusCondition.zs"
#include "zscript/StatusChecker/Toby_CoordinateChecker.zs"
#include "zscript/StatusChecker/Toby_HealthChecker.zs"
#include "zscript/StatusChecker/Toby_AmmoChecker.zs"
#include "zscript/StatusChecker/Toby_KeyChecker.zs"
#include "zscript/StatusChecker/Toby_ArmorChecker.zs"
#include "zscript/StatusChecker/Toby_CurrentItemChecker.zs"
#include "zscript/StatusChecker/Toby_LevelStatsChecker.zs"
#include "zscript/StatusChecker/Toby_PlayerStatusCheckStaticHandler.zs"

//Weapon/item selection narration
#include "zscript/SelectionNarration/Toby_SelectionNarrationHandler.zs"
#include "zscript/SelectionNarration/Toby_SelectionNarrator.zs"

//Marker menus
#include "zscript/Markers/Menu/Toby_BaseMarkerOptionMenuItem.zs"
#include "zscript/Markers/Menu/Toby_MarkerPathfindingMenu.zs"
#include "zscript/Markers/Menu/Toby_MarkerPathfindingOptionMenuItem.zs"
#include "zscript/Markers/Menu/Toby_MarkerAddMenu.zs"
#include "zscript/Markers/Menu/Toby_MarkerAddMenuItem.zs"
#include "zscript/Markers/Menu/Toby_MarkerRemoveMenu.zs"
#include "zscript/Markers/Menu/Toby_MarkerRemoveMenuItem.zs"
#include "zscript/Markers/Menu/Toby_MarkerRemoveNearestMenu.zs"

//Markers
#include "zscript/Markers/Toby_AutoMarkerDatabase.zs"
#include "zscript/Markers/Toby_AutoMarkerDatabaseItem.zs"
#include "zscript/Markers/Toby_MarkerDatabase.zs"
#include "zscript/Markers/Toby_MarkerDatabaseItem.zs"
#include "zscript/Markers/Toby_MarkerRecordContainer.zs"
#include "zscript/Markers/Toby_MarkerRecord.zs"
#include "zscript/Markers/Toby_MarkerHandler.zs"
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
#include "zscript/AccessibleMenu/Toby_MenuOutputBySoundBindings.zs"
#include "zscript/AccessibleMenu/Toby_MenuOutputToConsole.zs"
#include "zscript/AccessibleMenu/Toby_TitleScreenHandler.zs"
#include "zscript/AccessibleMenu/Toby_MenuState.zs"
#include "zscript/AccessibleMenu/Toby_MenuEventProcessor.zs"

//Utils
#include "zscript/Utils/Toby_SoundBindingsContainer.zs"
#include "zscript/Utils/Toby_ClassIgnoreListContainer.zs"
#include "zscript/Utils/Toby_WadsUtils.zs"
#include "zscript/Utils/Toby_Logger.zs"
#include "zscript/Utils/Toby_SaveGameUtils.zs"
#include "zscript/Utils/Toby_Enums.zs"
#include "zscript/Utils/Toby_IntegerSet.zs"

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

//Universal pickup beacon
#include "zscript/UniversalPickupBeacon/Toby_UniversalPickupBeacon.zs"
#include "zscript/UniversalPickupBeacon/Toby_UniversalPickupBeaconHandler.zs"

//Quick turn sound
#include "zscript/quickturn.zs"

//Line Spawner
#include "zscript/linespawner.zs"

//Pathfinder
#include "zscript/Pathfinder/Toby_PathfinderHandler.zs"
#include "zscript/Pathfinder/Toby_Pathfinder.zs"
#include "zscript/Pathfinder/Toby_PathfinderDebugRender.zs"
#include "zscript/Pathfinder/Toby_PathfinderFollower.zs"
#include "zscript/Pathfinder/Toby_PathfinderThinker.zs"
#include "zscript/Pathfinder/Toby_PathfindingNode.zs"
#include "zscript/Pathfinder/Toby_PathfindingNodeBuilder.zs"
#include "zscript/Pathfinder/Toby_PathfindingNodeContainer.zs"
#include "zscript/Pathfinder/Toby_SectorMathUtil.zs"
#include "zscript/Pathfinder/Toby_LineSegmentIntersectionUtil.zs"

//Proximity Detector
#include "zscript/ProximityDetector/Toby_ProximityDetector.zs"
#include "zscript/ProximityDetector/Toby_ProximityDetectorHandler.zs"
