class MenuSoundQueue
{
    ui static void Process(ProcessedMenuEvent e)
    {
        //This is not great but I had to move it to different file
        ListMenuItem menuItem = e.menuItem;
        ListMenuItemSelectable menuItemSelectable = e.menuItemSelectable;
        ListMenuItemTextItem textItem = e.textItem;
        ListMenuItemPatchItem patchItem = e.patchItem;
        OptionMenuSliderBase sliderItem = e.sliderItem;
        OptionMenuFieldBase fieldItem = e.fieldItem;
        OptionMenuItem optionItem = e.optionItem;
        OptionMenuItemOptionBase optionItemBase = e.optionItemBase;
        OptionMenuItemControlBase optionControl = e.optionControl;
		OptionMenuItemOption optionItemOption = e.optionItemOption;        

        string itemId = e.itemId;
        string itemIdLocalized = e.itemIdLocalized;
        string menuName = e.menuName;
		string parentMenuName = e.parentMenuName;
		string localizedOptionValue = e.localizedOptionValue;
        int mkey = e.mkey;

        int saveGameSlot = e.saveGameSlot;
        int saveGamesTotal = e.saveGamesTotal;
        string saveGameDate = e.saveGameDate;
        string saveGameMap = e.saveGameMap;
        string saveGameTime = e.saveGameTime;
        bool isAutosave = e.isAutosave;
        bool isNewSlot = e.isNewSlot;
        bool isSaveMenu = e.isSaveMenu;        

        //This should be moved to MenuEventProcessor ( ? )
        Array<String> splittedTime;
        int hours = 0;
        int minutes = 0;
        int seconds = 0;
        if (saveGameDate != "")
        {
            saveGameTime.Split(splittedTime, ":");
            hours = splittedTime[1].ToInt(10);
            minutes = splittedTime[2].ToInt(10);
            seconds = splittedTime[3].ToInt(10);
        }
        Array<String> dateTime;
        Array<String> dateTimeTime;
        Array<String> dateTimeDate;
        int dateHours = 0;
        int dateMinutes = 0;
        int dateSeconds = 0;
        int dateYear = 0;
        int dateMonth = 0;
        int dateDay = 0;
        if (saveGameTime != "")
        {
            saveGameDate.Split(dateTime, " ");
            dateTime[1].Split(dateTimeTime, ":");
            dateTime[0].Split(dateTimeDate, "-");
            dateHours = dateTimeTime[0].ToInt(10);
            dateMinutes = dateTimeTime[1].ToInt(10);
            dateSeconds = dateTimeTime[2].ToInt(10);
            dateYear = dateTimeDate[0].ToInt(10);
            dateMonth = dateTimeDate[1].ToInt(10);
            dateDay = dateTimeDate[2].ToInt(10);
        }

        Array<String> mapNumberTitle;
        int mapNumber = 0;
        int episodeNumber = 0;
        bool isMap = false;
        bool isEpisodic = false;
        if (saveGameMap != "")
        {
            saveGameMap.Split(mapNumberTitle, " - ");
            if (mapNumberTitle[0].Mid(0,3) == "MAP")
            {
                isMap = true;
                mapNumber = mapNumberTitle[0].Mid(3,2).ToInt(10);
            }
            //Volatile
            //Will break if episode has more than 9 episodes and more than 9 maps ( ? )
            //Is it even possible to do that in GZD?
            //Or is somebody will name their map "ERMAC" or something like that
            else if (mapNumberTitle[0].Mid(0,1) == "E" && mapNumberTitle[0].Mid(2,1) == "M")
            {
                isEpisodic = true;
                episodeNumber = mapNumberTitle[0].Mid(1,1).ToInt(10);
                mapNumber = mapNumberTitle[0].Mid(3,1).ToInt(10);
            }
        }
        
        //System.StopAllSounds(); //This line will abruptly stop all sounds. I think it sounds better than overlapping sounds
        SoundQueue.Clear();        

        //This is main block where you can define sounds and conditions
        if (itemIdLocalized == "M_NGAME" && mkey != Menu.MKEY_BACK && mkey != Menu.MKEY_ENTER)
        {
            SoundQueue.AddSound("menusnd/new", -1);
        }
        else if (itemIdLocalized == "M_OPTION" && mkey != Menu.MKEY_BACK && mkey != Menu.MKEY_ENTER)
        {
            SoundQueue.AddSound("menusnd/option", -1);
        }
        else if (itemIdLocalized == "M_LOADG" && mkey != Menu.MKEY_BACK && mkey != Menu.MKEY_ENTER)
        {
            SoundQueue.AddSound("menusnd/load", -1);
        }
        else if (itemIdLocalized == "M_SAVEG" && mkey != Menu.MKEY_BACK && mkey != Menu.MKEY_ENTER)
        {
            SoundQueue.AddSound("menusnd/save", -1);
        }
        else if (itemIdLocalized == "M_QUITG" && mkey != Menu.MKEY_BACK && mkey != Menu.MKEY_ENTER)
        {
            SoundQueue.AddSound("menusnd/quit", -1);
        }
		else if (itemIdLocalized == "M_RDTHIS" && mkey != Menu.MKEY_BACK && mkey != Menu.MKEY_ENTER)
        {
            SoundQueue.AddSound("menusnd/readme", -1);
        }		
		//Doom Episodes
		else if (itemIdLocalized == "M_EPI1" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/episode1", -1);
        }
		else if (itemIdLocalized == "M_EPI2" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/episode2", -1);
        }
		else if (itemIdLocalized == "M_EPI3" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/episode3", -1);
        }
		else if (itemIdLocalized == "M_EPI4" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/episode4", -1);
        }
		else if (itemIdLocalized == "M_EPI5" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/episode5", -1);
        }
		//Doom Skills
        else if (itemIdLocalized == "EASY" && menuName == "Skillmenu" && mkey != Menu.MKEY_BACK) //You can do as many conditions as you want. For example: check if you're in correct menu
        {
            SoundQueue.AddSound("menusnd/easy", -1);
        }        
        else if (itemIdLocalized == "NORMAL" && menuName == "Skillmenu" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/normal", -1);
        }
        else if (itemIdLocalized == "HARD" && menuName == "Skillmenu" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/hard", -1);
        }
		else if (itemIdLocalized == "M_JKILL" && menuName == "Skillmenu" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/skill1", -1);
        }
		else if (itemIdLocalized == "M_ROUGH" && menuName == "Skillmenu" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/skill2", -1);
        }
		else if (itemIdLocalized == "M_HURT" && menuName == "Skillmenu" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/skill3", -1);
        }
		else if (itemIdLocalized == "M_ULTRA" && menuName == "Skillmenu" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/skill4", -1);
        }
		else if (itemIdLocalized == "M_NMARE" && menuName == "Skillmenu" && mkey != Menu.MKEY_BACK)
        {
            SoundQueue.AddSound("menusnd/skill5", -1);
        }	
		//Menu Select Sounds
		else if (mkey == Menu.MKEY_ENTER && itemIdLocalized == "M_NGAME")
        {
			//SoundQueue.AddSound("menu/choose", -1);
            SoundQueue.AddSound("menusnd/newselect", -1);
        }
		else if (mkey == Menu.MKEY_ENTER && itemIdLocalized == "M_OPTION")
        {
			//SoundQueue.AddSound("menu/choose", -1);
            SoundQueue.AddSound("menusnd/optselect", -1);
        }
		else if (mkey == Menu.MKEY_ENTER && itemIdLocalized == "M_LOADG")
        {
			//SoundQueue.AddSound("menu/choose", -1);
            SoundQueue.AddSound("menusnd/loadselect", -1);
        }
		else if (mkey == Menu.MKEY_ENTER && itemIdLocalized == "M_SAVEG")
        {
			//SoundQueue.AddSound("menu/choose", -1);
            SoundQueue.AddSound("menusnd/saveselect", -1);
        }
		else if (mkey == Menu.MKEY_ENTER && itemIdLocalized == "M_QUITG")
        {
			//SoundQueue.AddSound("menu/choose", -1);
            SoundQueue.AddSound("menusnd/quitselect", -1);
        }
		else if (mkey == Menu.MKEY_ENTER && itemIdLocalized == "M_RDTHIS")
        {
			//SoundQueue.AddSound("menu/choose", -1);
            SoundQueue.AddSound("menusnd/readselect", -1);
        }
		//Doom Episodes Select
		else if (mkey == Menu.MKEY_ENTER && itemIdLocalized == "M_EPI1")
        {
			//SoundQueue.AddSound("menu/choose", -1);
            SoundQueue.AddSound("menusnd/episode1", -1);
        }
		else if (mkey == Menu.MKEY_ENTER && itemIdLocalized == "M_EPI2")
        {
			//SoundQueue.AddSound("menu/choose", -1);
            SoundQueue.AddSound("menusnd/episode2", -1);
        }
		else if (mkey == Menu.MKEY_ENTER && itemIdLocalized == "M_EPI3")
        {
			//SoundQueue.AddSound("menu/choose", -1);
            SoundQueue.AddSound("menusnd/episode3", -1);
        }
		else if (mkey == Menu.MKEY_ENTER && itemIdLocalized == "M_EPI4")
        {
			//SoundQueue.AddSound("menu/choose", -1);
            SoundQueue.AddSound("menusnd/episode4", -1);
        }
		else if (mkey == Menu.MKEY_ENTER && itemIdLocalized == "M_EPI5")
        {
			//SoundQueue.AddSound("menu/choose", -1);
            SoundQueue.AddSound("menusnd/episode5", -1);
        }
		//Menu Back or Dismiss Sounds		
		else if (mkey == Menu.MKEY_BACK && menuName == "Mainmenu")
		{
			SoundQueue.AddSound("menu/dismiss", -1);
		}
		else if (mkey == Menu.MKEY_BACK && parentMenuName == "Mainmenu")
		{
			SoundQueue.AddSound("menu/backup", -1);
		}
		//Options menus
		else if (itemIdLocalized == "Sound Options" && mkey != Menu.MKEY_BACK && mkey != Menu.MKEY_ENTER)
        {
			SoundQueue.AddSound("menusnd/soundopt", -1);
		}
		else if (itemIdLocalized == "Sound Options" && mkey == Menu.MKEY_ENTER)
        {
			//SoundQueue.AddSound("menu/choose", -1);
			SoundQueue.AddSound("menusnd/soundoptselect", -1);
		}
		else if (itemIdLocalized == "GZDoom Options" && mkey != Menu.MKEY_BACK && mkey != Menu.MKEY_ENTER)
        {
			SoundQueue.AddSound("menusnd/gzdopt", -1);
		}
		else if (itemIdLocalized == "GZDoom Options" && mkey == Menu.MKEY_ENTER)
        {
			//SoundQueue.AddSound("menu/choose", -1);
			SoundQueue.AddSound("menusnd/gzdoptselect", -1);
		}
		//Sound options
		else if (itemIdLocalized == "Menu volume" && (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down))
        {
			SoundQueue.AddSound("menusnd/menuvol", -1);
		}
		else if (itemIdLocalized == "MIDI device" && (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down))
        {
			SoundQueue.AddSound("menusnd/midi", -1);
		}
		else if (itemIdLocalized == "Music volume" && (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down))
        {
			SoundQueue.AddSound("menusnd/musicvol", -1);
		}
		else if (itemIdLocalized == "Sounds volume" && (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down))
        {
			SoundQueue.AddSound("menusnd/soundvol", -1);
		}
		else if (itemIdLocalized == "Master volume" && (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down))
        {
			SoundQueue.AddSound("menusnd/mastervol", -1);
		}
		else if (itemIdLocalized == "Randomize pitches" && (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down))
        {
			SoundQueue.AddSound("menusnd/pitch", -1);
		}
		else if (itemIdLocalized == "Underwater reverb" && (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down))
        {
			SoundQueue.AddSound("menusnd/reverb", -1);
		}

        //Save/load menu
        else if (saveGameSlot >= 0 && isNewSlot && (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down))
        {
            SoundQueue.UnshiftSound("save/new", -1);
        }
        else if (saveGameSlot >= 0 && isSaveMenu && mkey == Menu.MKEY_ENTER)
        {
            SoundQueue.UnshiftSound("save/entersave", -1);
        }
        else if (saveGameSlot >= 0 && isSaveMenu && mkey == Menu.MKEY_Abort)
        {
            SoundQueue.UnshiftSound("save/cancelled", -1);
        }
        else if (saveGameSlot >= 0 && isSaveMenu && mkey == Menu.MKEY_Input)
        {
            SoundQueue.UnshiftSound("save/saved", -1);
        }
        else if (saveGameSlot >= 0 && (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down))
        {
            //Because of my backwards thinking sounds have to be added in reverse order            
            if (isAutosave)
            {
                SoundQueue.UnshiftSound("save/autosave", -1);
            }
			else
			{
				StringToVoice.ConvertAndAddToQueueReverse(itemId);
			}
            NumberToVoice.ConvertAndAddToQueue(saveGamesTotal); 
            SoundQueue.UnshiftSound("save/of", -1);
            NumberToVoice.ConvertAndAddToQueue(saveGameSlot);
            SoundQueue.UnshiftSound("save/slot", -1);
        }
        else if (saveGameSlot >= 0 && !isNewSlot && mkey == Menu.MKEY_Left)
        {
            if (saveGameDate != "")
            {                
                SoundQueue.UnshiftSound("save/seconds", -1);
                NumberToVoice.ConvertAndAddToQueue(seconds);
                SoundQueue.UnshiftSound("save/minutes", -1);
                NumberToVoice.ConvertAndAddToQueue(minutes);
                SoundQueue.UnshiftSound("save/hours", -1);
                NumberToVoice.ConvertAndAddToQueue(hours);
                SoundQueue.UnshiftSound("alphabet/Space", -1); //Oops, pause is too short, remove if not needed
                SoundQueue.UnshiftSound("save/timespent", -1);
                if (isMap)
                {
                    NumberToVoice.ConvertAndAddToQueue(mapNumber);
                    SoundQueue.UnshiftSound("save/map", -1);
                }
                else if (isEpisodic)
                {
                    NumberToVoice.ConvertAndAddToQueue(mapNumber);
                    SoundQueue.UnshiftSound("save/map", -1);
                    NumberToVoice.ConvertAndAddToQueue(episodeNumber);
                    SoundQueue.UnshiftSound("save/episode", -1);
                }
            }            
        }
        else if (saveGameSlot >= 0 && !isNewSlot && mkey == Menu.MKEY_Right)
        {
            if (saveGameTime != "")
            {
                SoundQueue.UnshiftSound("save/seconds", -1);
                NumberToVoice.ConvertAndAddToQueue(dateSeconds);
                SoundQueue.UnshiftSound("save/minutes", -1);
                NumberToVoice.ConvertAndAddToQueue(dateMinutes);
                SoundQueue.UnshiftSound("save/hours", -1);
                NumberToVoice.ConvertAndAddToQueue(dateHours);
                SoundQueue.UnshiftSound("alphabet/Space", -1);
                SoundQueue.UnshiftSound("alphabet/Space", -1);
                NumberToVoice.ConvertAndAddToQueue(dateYear);
                OrdinalToVoice.ConvertAndAddToQueue(dateDay);
                MonthToVoice.ConvertAndUnshiftToQueue(dateMonth);
            }
        }
        //End of save/load menu
		
        //Starting from here it's all fallback for all unaccounted cases
        else if (optionControl)
        {
            //console.printf("Option control!");
            if (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down)
            {
                //StringToVoice.ConvertAndAddToQueue(itemIdLocalized);
            }
            Array<int> keys;
            optionControl.mBindings.GetAllKeysForCommand(keys, optionControl.GetAction());
            //StringToVoice.ConvertAndAddToQueue(KeyBindings.NameAllKeys(keys));
        }
        else if (optionItemOption || optionItemBase)
        {
            //console.printf("Option item!");
			if (optionItemOption)
			{
				//For some reason optionItemOption and OptionItemBase work differently
				int selection = optionItemBase.GetSelection();
				localizedOptionValue = StringTable.Localize(OptionValues.GetText(optionItemBase.mValues, selection));
			}
			else if (optionItemBase)
			{
				int selection = optionItemBase.GetSelection();
				int selectionMaxValue = OptionValues.GetCount(optionItemBase.mValues)-1;				
				if (mkey == Menu.MKEY_Left)
				{
					selection--;
					if (selection < 0)
					{
						selection = selectionMaxValue;
					}
				}
				else if (mkey == Menu.MKEY_Right || mkey == Menu.MKEY_Enter)
				{
					selection++;
					if (selection >= selectionMaxValue+1)
					{
						selection = 0;
					}
				}
				localizedOptionValue = StringTable.Localize(OptionValues.GetText(optionItemBase.mValues, selection));				
			}
			
			//console.Printf("Selected value: "..localizedOptionValue);
			if (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down)
			{
				//StringToVoice.ConvertAndAddToQueue(itemIdLocalized);
			}
			else if (mkey == Menu.MKEY_Left || mkey == Menu.MKEY_Right)
			{
				if (localizedOptionValue == "Off")
				{
					SoundQueue.AddSound("menusnd/off", -1);
				}
				else if (localizedOptionValue == "On")
				{
					SoundQueue.AddSound("menusnd/on", -1);
				}
				else
				{
					//StringToVoice.ConvertAndAddToQueue(localizedOptionValue);
				}
			}
        }
        else if (sliderItem)
        {
            //console.printf("Slider!");
            NumberToVoice.ConvertFloatAndAddToQueue(sliderItem.GetSliderValue());
            if (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down)
            {
                //StringToVoice.ConvertAndAddToQueueReverse(itemIdLocalized); 
            }
        }
        else if (fieldItem)
        {
            if (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down)
            {
                //StringToVoice.ConvertAndAddToQueue(itemIdLocalized);
            }
            //StringToVoice.ConvertAndAddToQueue(fieldItem.Represent());
        }
        else
        {
            if (mkey == Menu.MKEY_Up || mkey == Menu.MKEY_Down)
            {
                //StringToVoice.ConvertAndAddToQueue(itemIdLocalized);
            }   
        }
        SoundQueue.PlayQueue(0);

        //Console.Printf("Event processor: "..menuName.." "..mkey.." "..itemId.." "..itemIdLocalized);

        e.Destroy();
    }
}