@echo off
REM API Test Script for qa-service-user Doctor API (Windows)
REM This script tests all endpoints of Doctor API

set BASE_URL=http://localhost:8080/api/doctors

echo ==========================================
echo QA Service User - Doctor API Test Suite
echo ==========================================
echo.

REM Test 1: Health Check
echo Testing: Health Check
curl -s -X GET "%BASE_URL%/health"
echo.
echo.

REM Test 2: Get All Doctors
echo Testing: Get All Doctors
curl -s -X GET "%BASE_URL%"
echo.
echo.

REM Test 3: Get Active Doctors
echo Testing: Get Active Doctors
curl -s -X GET "%BASE_URL%/active"
echo.
echo.

REM Test 4: Get Doctor by ID (doc001)
echo Testing: Get Doctor by ID (doc001)
curl -s -X GET "%BASE_URL%/doc001"
echo.
echo.

REM Test 5: Get Doctor by Username
echo Testing: Get Doctor by Username (dr-zhang-wei)
curl -s -X GET "%BASE_URL%/username/dr-zhang-wei"
echo.
echo.

REM Test 6: Get Non-existent Doctor (404 Test)
echo Testing: Get Non-existent Doctor (Should return 404)
curl -s -X GET "%BASE_URL%/nonexistent"
echo.
echo.

REM Test 7: Create New Doctor
echo Testing: Create New Doctor
curl -s -X POST "%BASE_URL%" -H "Content-Type: application/json" -d "{\"id\":\"doc006\",\"username\":\"dr-new-doctor\",\"password\":\"password123\",\"name\":\"新医生\",\"title\":\"主治医师\",\"department\":\"外科\",\"avatar\":\"https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg\",\"experience\":\"5年临床经验\",\"specialties\":[\"外科手术\",\"创伤修复\"],\"isActive\":true}"
echo.
echo.

REM Test 8: Update Doctor
echo Testing: Update Doctor (doc006)
curl -s -X PUT "%BASE_URL%/doc006" -H "Content-Type: application/json" -d "{\"id\":\"doc006\",\"username\":\"dr-new-doctor\",\"password\":\"password123\",\"name\":\"新医生-更新\",\"title\":\"副主任医师\",\"department\":\"外科\",\"avatar\":\"https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg\",\"experience\":\"6年临床经验\",\"specialties\":[\"外科手术\",\"创伤修复\",\"微创手术\"],\"isActive\":true}"
echo.
echo.

REM Test 9: Delete Doctor
echo Testing: Delete Doctor (doc006)
curl -s -X DELETE "%BASE_URL%/doc006"
echo.
echo.

REM Test 10: Verify Deletion (404 Test)
echo Testing: Verify Doctor Deletion (Should return 404)
curl -s -X GET "%BASE_URL%/doc006"
echo.
echo.

echo ==========================================
echo Test Suite Completed
echo ==========================================
pause
