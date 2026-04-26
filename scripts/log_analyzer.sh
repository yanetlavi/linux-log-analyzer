#!/bin/bash

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
NC="\033[0m"  # No Color


# Default log file if none is provided
LOG_FILE=${1:-"./logs/app.log"}

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
  echo "Log file not found: $LOG_FILE"
  exit 1
fi

echo -e "${CYAN}=== Log Analyzer ===${NC}"
echo -e "File: $LOG_FILE"
echo "--------------------------------"

# Date filter (optional)
if [ -n "$2" ]; then
  DATE_FILTER="$2"
  echo -e "${CYAN}Filtering by date:${NC} $DATE_FILTER"
  echo "--------------------------------"
  FILTERED_LOG=$(grep "$DATE_FILTER" "$LOG_FILE")
else
  FILTERED_LOG=$(cat "$LOG_FILE")
fi

# Count log levels
ERROR_COUNT=$(echo "$FILTERED_LOG" | grep -c "ERROR")
WARN_COUNT=$(echo "$FILTERED_LOG" | grep -c "WARN")
INFO_COUNT=$(echo "$FILTERED_LOG" | grep -c "INFO")

# Output results
echo -e "${GREEN}INFO lines:${NC}  $INFO_COUNT"
echo -e "${YELLOW}WARN lines:${NC}  $WARN_COUNT"
echo -e "${RED}ERROR lines:${NC} $ERROR_COUNT"

# Save results to a report file
REPORT_FILE="./logs/report_$(date +%Y%m%d_%H%M%S).txt"

echo "Saving report to: $REPORT_FILE"

{
  echo "Log Analysis Report"
  echo "Generated on: $(date)"
  echo "Log File: $LOG_FILE"
  if [ -n "$2" ]; then
    echo "Date Filter: $DATE_FILTER"
  else
    echo "Date Filter: None"
  fi
  echo "--------------------------------"
  echo "INFO lines:  $INFO_COUNT"
  echo "WARN lines:  $WARN_COUNT"
  echo "ERROR lines: $ERROR_COUNT"


} > "$REPORT_FILE"

