class Toby_SaveGameUtils
{
    static Toby_SaveGameTime getTime(string saveGameTime)
    {
        Toby_SaveGameTime time = new("Toby_SaveGameTime");
        Array<String> splittedTime;
        time.hours = 0;
        time.minutes = 0;
        time.seconds = 0;
        if (saveGameTime != "null")
        {
            saveGameTime.Split(splittedTime, ":");
            time.hours = splittedTime[1].ToInt(10);
            time.minutes = splittedTime[2].ToInt(10);
            time.seconds = splittedTime[3].ToInt(10);
        }
        return time;
    }

    static Toby_SaveGameDate getDate(string saveGameDate)
    {
        Toby_SaveGameDate datetimeObj = new("Toby_SaveGameDate");
        Array<String> dateTime;
        Array<String> dateTimeTime;
        Array<String> dateTimeDate;
        datetimeObj.hours = 0;
        datetimeObj.minutes = 0;
        datetimeObj.seconds = 0;
        datetimeObj.year = 0;
        datetimeObj.month = 0;
        datetimeObj.day = 0;
        if (saveGameDate != "null")
        {
            saveGameDate.Split(dateTime, " ");
            dateTime[1].Split(dateTimeTime, ":");
            dateTime[0].Split(dateTimeDate, "-");
            datetimeObj.hours = dateTimeTime[0].ToInt(10);
            datetimeObj.minutes = dateTimeTime[1].ToInt(10);
            datetimeObj.seconds = dateTimeTime[2].ToInt(10);
            datetimeObj.year = dateTimeDate[0].ToInt(10);
            datetimeObj.month = dateTimeDate[1].ToInt(10);
            datetimeObj.day = dateTimeDate[2].ToInt(10);
        }
        return datetimeObj;
    }

    static Toby_SaveGameMap getMapInfo(string saveGameMap)
    {
        Toby_SaveGameMap mapInfo = new("Toby_SaveGameMap");
        Array<String> mapNumberTitle;
        mapInfo.mapNumber = 0;
        mapInfo.episodeNumber = 0;
        mapInfo.isMap = false;
        mapInfo.isEpisodic = false;
        if (saveGameMap != "null")
        {
            saveGameMap.Split(mapNumberTitle, " - ");
            if (mapNumberTitle[0].Mid(0,3) == "MAP")
            {
                mapInfo.isMap = true;
                mapInfo.mapNumber = mapNumberTitle[0].Mid(3,2).ToInt(10);
            }
            //Volatile
            //Will break if episode has more than 9 episodes and more than 9 maps ( ? )
            //Is it even possible to do that in GZD?
            //Or is somebody will name their map "ERMAC" or something like that
            else if (mapNumberTitle[0].Mid(0,1) == "E" && mapNumberTitle[0].Mid(2,1) == "M")
            {
                mapInfo.isEpisodic = true;
                mapInfo.episodeNumber = mapNumberTitle[0].Mid(1,1).ToInt(10);
                mapInfo.mapNumber = mapNumberTitle[0].Mid(3,1).ToInt(10);
            }
        }
        return mapInfo;
    }
}

class Toby_SaveGameTime
{
    int hours;
    int minutes;
    int seconds;
}

class Toby_SaveGameDate
{
    int hours;
    int minutes;
    int seconds;
    int year;
    int month;
    int day;
}

class Toby_SaveGameMap
{
    bool isMap;
    bool isEpisodic;
    int mapNumber;
    int episodeNumber;
}
