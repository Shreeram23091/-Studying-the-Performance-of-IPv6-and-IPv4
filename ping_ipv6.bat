@echo off
setlocal enabledelayedexpansion

:: Input: File containing the list of websites
set "WEBLIST=websites.txt"

:: Detect ISP using ipinfo.io
for /f "tokens=*" %%I in ('curl -s ipinfo.io/org') do set "ISP_NAME=%%I"
set "ISP_NAME=!ISP_NAME:Organization=!"  :: Remove unnecessary part of the ISP name
set "ISP_NAME=!ISP_NAME: =_!"  :: Replace spaces with underscores for valid filename

echo Detected ISP: !ISP_NAME!

:: Get current date in YYYY-MM-DD format
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set "datetime=%%a"
set "date=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2!"

:: Set the log file name dynamically based on ISP name
set "LOGFILE=ipv6_!ISP_NAME!.csv"

:: Clear previous log file and set headers
echo Date,Current_Time,ISP,Website,IPv6_IP,Ping_Time(ms),Geolocation > "%LOGFILE%"

:: Loop through each website in the list
for /F "tokens=*" %%W in (%WEBLIST%) do (
    set "website=%%W"
    echo Pinging website: !website!... Please wait.

    :: Ping for IPv6 and capture the IP and round-trip time
    for /L %%i in (1,1,10) do (
        :: Get current time in HH:MM:SS format
        for /f "tokens=1-4 delims=:., " %%h in ("%time%") do (
            set "current_time=%%h:%%i:%%j"
        )

        :: Get the IP and round-trip time for the ping
        set "ipv6_ip=N/A"
        set "ping_time=N/A"
        set "geolocation=N/A"
        
        for /f "tokens=2 delims=[]" %%A in ('ping -6 -n 1 !website! ^| findstr /r /c:"\[.*\]"') do (
            set "ipv6_ip=%%A"
        )

        :: Get the round-trip time
        for /f "tokens=4 delims= " %%B in ('ping -6 -n 1 !website! ^| findstr /i "time="') do (
            set "ping_time=%%B"
            set "ping_time=!ping_time:time=!"  :: Remove 'time='
            set "ping_time=!ping_time:~1!"     :: Remove '='
        )

        :: Fetch geolocation using curl and ipinfo.io
        if not "!ipv6_ip!"=="N/A" (
            for /f "tokens=*" %%C in ('curl -s "https://ipinfo.io/!ipv6_ip!/city"') do (
                set "geolocation=%%C"
            )
        )

        :: Output to console (IP, ping_time, and location)
        echo IPv6: IP=!ipv6_ip!, ping_time=!ping_time!, location=!geolocation!

        :: Write results to log file
        echo !date!,!current_time!,!ISP_NAME!,!website!,!ipv6_ip!,!ping_time!,!geolocation! >> "%LOGFILE%"
    )
)

echo IPv6 Pinging complete. Results saved in %LOGFILE%
pause
