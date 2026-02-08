#!/bin/bash

# API Test Script for qa-service-user Doctor API
# This script tests all endpoints of the Doctor API

BASE_URL="http://localhost:8080/api/doctors"

echo "=========================================="
echo "QA Service User - Doctor API Test Suite"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print test result
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC}: $2"
    else
        echo -e "${RED}✗ FAIL${NC}: $2"
    fi
}

# Function to print test title
print_test() {
    echo -e "\n${YELLOW}Testing: $1${NC}"
}

# Test 1: Health Check
print_test "Health Check"
curl -s -X GET "$BASE_URL/health" | python -m json.tool
print_result $? "Health Check Endpoint"
echo ""

# Test 2: Get All Doctors
print_test "Get All Doctors"
curl -s -X GET "$BASE_URL" | python -m json.tool
print_result $? "Get All Doctors Endpoint"
echo ""

# Test 3: Get Active Doctors
print_test "Get Active Doctors"
curl -s -X GET "$BASE_URL/active" | python -m json.tool
print_result $? "Get Active Doctors Endpoint"
echo ""

# Test 4: Get Doctor by ID (doc001)
print_test "Get Doctor by ID (doc001)"
curl -s -X GET "$BASE_URL/doc001" | python -m json.tool
print_result $? "Get Doctor by ID Endpoint"
echo ""

# Test 5: Get Doctor by Username
print_test "Get Doctor by Username (dr-zhang-wei)"
curl -s -X GET "$BASE_URL/username/dr-zhang-wei" | python -m json.tool
print_result $? "Get Doctor by Username Endpoint"
echo ""

# Test 6: Get Non-existent Doctor (404 Test)
print_test "Get Non-existent Doctor (Should return 404)"
curl -s -X GET "$BASE_URL/nonexistent" | python -m json.tool
print_result $? "404 Error Handling"
echo ""

# Test 7: Create New Doctor
print_test "Create New Doctor"
NEW_DOCTOR='{
    "id": "doc006",
    "username": "dr-new-doctor",
    "password": "password123",
    "name": "新医生",
    "title": "主治医师",
    "department": "外科",
    "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
    "experience": "5年临床经验",
    "specialties": ["外科手术", "创伤修复"],
    "isActive": true
}'
curl -s -X POST "$BASE_URL" \
    -H "Content-Type: application/json" \
    -d "$NEW_DOCTOR" | python -m json.tool
print_result $? "Create Doctor Endpoint"
echo ""

# Test 8: Update Doctor
print_test "Update Doctor (doc006)"
UPDATE_DOCTOR='{
    "id": "doc006",
    "username": "dr-new-doctor",
    "password": "password123",
    "name": "新医生-更新",
    "title": "副主任医师",
    "department": "外科",
    "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
    "experience": "6年临床经验",
    "specialties": ["外科手术", "创伤修复", "微创手术"],
    "isActive": true
}'
curl -s -X PUT "$BASE_URL/doc006" \
    -H "Content-Type: application/json" \
    -d "$UPDATE_DOCTOR" | python -m json.tool
print_result $? "Update Doctor Endpoint"
echo ""

# Test 9: Delete Doctor
print_test "Delete Doctor (doc006)"
curl -s -X DELETE "$BASE_URL/doc006" | python -m json.tool
print_result $? "Delete Doctor Endpoint"
echo ""

# Test 10: Verify Deletion (404 Test)
print_test "Verify Doctor Deletion (Should return 404)"
curl -s -X GET "$BASE_URL/doc006" | python -m json.tool
print_result $? "Verify Doctor Deletion"
echo ""

echo "=========================================="
echo "Test Suite Completed"
echo "=========================================="
