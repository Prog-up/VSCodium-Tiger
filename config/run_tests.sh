#!/bin/bash

TEST_CASES=($(find "tests" -type f -name "*.tig"))
OUTPUT_FILE="output.tig"
RED='\033[31m'
GREEN='\033[32m'
CYAN='\033[36m'
BLUE='\033[34m'
RESET='\033[0m'
PASSED=0
FAILED=0

for TEST in "${TEST_CASES[@]}"; do
    if ./build/src/tc -XA "$TEST" > "$OUTPUT_FILE" 2>&1; then
        if ./build/src/tc -X --parse - < "$OUTPUT_FILE" > /dev/null 2>&1; then
            ((PASSED++))
        else
            ((FAILED++))
            echo "--------------------------------------"
            echo -e "${RED}Parsing failed: $TEST${RESET}"
            echo -e "${BLUE}Source Code:${RESET}"
            cat "$TEST"
            echo -e "${RED}Error Message:${RESET}"
            ./build/src/tc -X --parse - < "$OUTPUT_FILE"
        fi
    else
        ((FAILED++))
        echo "--------------------------------------"
        echo -e "${RED}Compilation failed: $TEST${RESET}"
        echo -e "${BLUE}Source Code:${RESET}"
        cat "$TEST"
        echo -e "${RED}Error Message:${RESET}"
        cat "$OUTPUT_FILE"
    fi
done

echo "--------------------------------------"
echo -e "${CYAN}Test Summary:${RESET}"
echo -e "${GREEN}Passed: $PASSED${RESET}"
echo -e "${RED}Failed: $FAILED${RESET}"

if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}All tests passed successfully!${RESET}"
    exit 
