# IPv4 vs IPv6 Performance Analysis

## Project Overview
This project aims to study the performance difference between IPv4 and IPv6 networks by measuring Round Trip Time (RTT) across a list of popular websites. The data is collected using batch scripts run in Windows Command Prompt and analyzed through Python scripts.

## Files Provided
- **ping_ipv4.bat**: Batch script to ping websites over IPv4.
- **ping_ipv6.bat**: Batch script to ping websites over IPv6.
- **websites.txt**: List of websites to ping.
- **ipv4_AS45609_Bharti_Airtel_Ltd._AS_for_GPRS_Service.csv**: Sample data collected from IPv4 pings.

## How to Run
1. Open Windows Command Prompt.
2. Place `ping_ipv4.bat`, `ping_ipv6.bat`, and `websites.txt` in the same directory.
3. Run `ping_ipv4.bat` to collect IPv4 data.
4. Run `ping_ipv6.bat` to collect IPv6 data.
5. The output will be saved as CSV files for further analysis.

## Data Analysis
- Upload the generated CSVs to a Python script for processing.
- Use libraries like Pandas and Matplotlib for analysis.
- Compare RTT distribution and observe trends across IPv4 and IPv6 networks.

## Key Tools
- **Batch Scripting**: Automate pinging process.
- **Ping Command**: Measure network latency.
- **Python**: Analyze and visualize data.
- **Windows Environment**: Execute scripts and commands.

## Conclusion
This project provides insights into the comparative performance of IPv4 and IPv6 by measuring network latencies over different websites.


