#!/bin/bash

WITHOUT_ERROR_DIR="tests/without_error"
WITH_ERROR_DIR="tests/with_error"
OUTPUT_FILE="output.tig"

WITHOUT_ERROR_TESTS=($(find "$WITHOUT_ERROR_DIR" -type f -name "*.tig"))
WITH_ERROR_TESTS=($(find "$WITH_ERROR_DIR" -type f -name "*.tig"))

RED='\033[31m'
GREEN='\033[32m'
CYAN='\033[36m'
BLUE='\033[34m'
RESET='\033[0m'

PASSED=0
FAILED=0

echo -e "${CYAN}Running Tiger Compiler Tests...${RESET}"

for TEST in "${WITHOUT_ERROR_TESTS[@]}"; do
    if ./build/src/tc -XA "$TEST" > "$OUTPUT_FILE" 2>&1 && ./build/src/tc -X --parse - < "$OUTPUT_FILE" > /dev/null 2>&1; then
        ((PASSED++))
    else
        ((FAILED++))
        echo "--------------------------------------"
        echo -e "${RED}Unexpected failure: $TEST${RESET}"
        echo -e "${BLUE}Source Code:${RESET}"
        cat "$TEST"
        echo -e "${RED}Error Message:${RESET}"
        cat "$OUTPUT_FILE"
    fi
done

for TEST in "${WITH_ERROR_TESTS[@]}"; do
    if ./build/src/tc -XA "$TEST" > "$OUTPUT_FILE" 2>&1 || ./build/src/tc -X --parse - < "$OUTPUT_FILE" > /dev/null 2>&1; then
        ((FAILED++))
        echo "--------------------------------------"
        echo -e "${RED}Unexpected success: $TEST${RESET}"
        echo -e "${BLUE}Source Code:${RESET}"
        cat "$TEST"
        echo -e "${RED}Expected an error but the test passed.${RESET}"
    else
        ((PASSED++))
    fi
done

echo "--------------------------------------"
echo -e "${CYAN}Test Summary:${RESET}"
echo -e "${GREEN}Passed: $PASSED${RESET}"
echo -e "${RED}Failed: $FAILED${RESET}"

if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}All tests passed successfully!${RESET}"
    exit 0
else
    echo -e "${RED}Some tests failed. Check the errors above.${RESET}"
    exit 1
fi
