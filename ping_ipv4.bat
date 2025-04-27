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
set "LOGFILE=ipv4_!ISP_NAME!.csv"

:: Clear previous log file and set headers
echo Date,Current_Time,ISP,Website,IPv4_IP,Ping_Time(ms),Geolocation > "%LOGFILE%"

:: Loop through each website in the list
for /F "tokens=*" %%W in (%WEBLIST%) do (
    set "website=%%W"
    echo Pinging website: !website!... Please wait.

    :: Ping for IPv4 and capture the IP and round-trip time
    for /L %%i in (1,1,10) do (
        :: Get current time in HH:MM:SS format
        for /f "tokens=1-4 delims=:., " %%h in ("%time%") do (
            set "current_time=%%h:%%i:%%j"
        )

        :: Get the IP and round-trip time for the ping
        set "ipv4_ip=N/A"
        set "ping_time=N/A"
        set "geolocation=N/A"

        for /f "tokens=2 delims=[]" %%A in ('ping -4 -n 1 !website! ^| findstr /i "Pinging"') do (
            set "ipv4_ip=%%A"
        )

        :: Get the round-trip time
        for /f "tokens=7 delims== " %%B in ('ping -4 -n 1 !website! ^| findstr /i "time="') do (
            set "ping_time=%%B"
        )

        :: Fetch geolocation using curl and ipinfo.io
        if not "!ipv4_ip!"=="N/A" (
            for /f "tokens=*" %%C in ('curl -s "https://ipinfo.io/!ipv4_ip!/city"') do (
                set "geolocation=%%C"
            )
        )

        :: Output to console (IP, ping_time, and location)
        echo IPv4: IP=!ipv4_ip!, ping_time=!ping_time!, location=!geolocation!

        :: Write results to log file
        echo !date!,!current_time!,!ISP_NAME!,!website!,!ipv4_ip!,!ping_time!,!geolocation! >> "%LOGFILE%"
    )
)

echo IPv4 Pinging complete. Results saved in %LOGFILE%
pause
