version "4.6"

//Sound queue utils
#include "zscript/Utils/SoundQueue/Toby_SoundQueueStaticHandler.zs"
#include "zscript/Utils/SoundQueue/Toby_QueuedSound.zs"
#include "zscript/Utils/SoundQueue/Toby_NumberToVoice.zs"
#include "zscript/Utils/SoundQueue/Toby_StringToVoice.zs"
#include "zscript/Utils/SoundQueue/Toby_OrdinalToVoice.zs"
#include "zscript/Utils/SoundQueue/Toby_MonthToVoice.zs"

//Player status checker
#include "zscript/StatusChecker/Toby_PlayerStatusCondition.zs"
#include "zscript/StatusChecker/Toby_HealthChecker.zs"
#include "zscript/StatusChecker/Toby_AmmoChecker.zs"
#include "zscript/StatusChecker/Toby_KeyChecker.zs"
#include "zscript/Toby_PlayerStatusCheckHandler.zs"

#include "zscript/Markers/ZS_MarkerHandler.zs"
#include "zscript/Markers/Toby_Markers.zs"
#include "zscript/Toby_MenuStaticHandler.zs"
#include "zscript/Toby_MapAnnouncementStaticHandler.zs"
#include "zscript/Toby_TitleScreenHandler.zs"
#include "zscript/AccessibleMenu/Toby_MenuState.zs"
#include "zscript/Utils/Toby_SoundBindingsContainer.zs"
#include "zscript/AccessibleMenu/Toby_MenuEventProcessor.zs"
#include "zscript/Utils/Toby_WadsUtils.zs"
#include "zscript/Utils/Toby_Logger.zs"
#include "zscript/Utils/Toby_SaveGameUtils.zs"
#include "zscript/hitmarkers.zsc"
#include "zscript/DropoffDetector/Toby_DropoffSoundEmitter.zs"
#include "zscript/DropoffDetector/Toby_DropoffSoundEmitterManagerItem.zs"
#include "zscript/Toby_DropoffDetectorHandler.zs"
#include "zscript/Toby_SnapToTargetHandler.zs"
