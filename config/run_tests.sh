#!/bin/bash

TEST_FOLDERS=($(find "tests" -type f -name "README.txt" -exec dirname {} \;))
OUTPUT_FILE="output.tig"
RED='\033[31m'
GREEN='\033[32m'
CYAN='\033[36m'
BLUE='\033[34m'
RESET='\033[0m'
PASSED=0
FAILED=0

for FOLDER in "${TEST_FOLDERS[@]}"; do
    EXPECTED_EXIT_CODE=$(cat "$FOLDER/README.txt" | tr -d '[:space:]')

    if ! [[ "$EXPECTED_EXIT_CODE" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Invalid exit code in $FOLDER/README.txt: '$EXPECTED_EXIT_CODE'${RESET}"
        ((FAILED++))
        continue
    fi

    TEST_FILES=($(find "$FOLDER" -type f -name "*.tig"))

    for TEST in "${TEST_FILES[@]}"; do
        ./build/src/tc -X --parse "$TEST" > "$OUTPUT_FILE" 2>&1
        ACTUAL_EXIT_CODE=$?

        if [ "$ACTUAL_EXIT_CODE" -eq "$EXPECTED_EXIT_CODE" ]; then
            if [ "$ACTUAL_EXIT_CODE" -eq 0 ]; then
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
                ((PASSED++))
            fi
        else
            ((FAILED++))
            echo "--------------------------------------"
            echo -e "${RED}Test failed: $TEST${RESET}"
            echo -e "${BLUE}Source Code:${RESET}"
            cat "$TEST"
            echo -e "${RED}Expected exit code: $EXPECTED_EXIT_CODE, but got: $ACTUAL_EXIT_CODE${RESET}"
            echo -e "${RED}Error Message:${RESET}"
            cat "$OUTPUT_FILE"
        fi
    done
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
