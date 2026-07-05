@echo off
set BASE_URL=http://localhost:8080/api/doctors

echo ==========================================
echo QA Service User - Doctor API Test Suite
echo ==========================================
echo.

echo Testing 1: Health Check
curl -s -X GET "%BASE_URL%/health"
echo.
echo.

echo Testing 2: Get All Doctors
curl -s -X GET "%BASE_URL%"
echo.
echo.

echo Testing 3: Get Active Doctors
curl -s -X GET "%BASE_URL%/active"
echo.
echo.

echo Testing 4: Get Doctor by ID (doc001)
curl -s -X GET "%BASE_URL%/doc001"
echo.
echo.

echo Testing 5: Get Doctor by Username (dr-zhang-wei)
curl -s -X GET "%BASE_URL%/username/dr-zhang-wei"
echo.
echo.

echo Testing 6: Get Non-existent Doctor (404 Test)
curl -s -X GET "%BASE_URL%/nonexistent"
echo.
echo.

echo Testing 7: Create New Doctor
curl -s -X POST "%BASE_URL%" -H "Content-Type: application/json" -d "{\"id\":\"doc006\",\"username\":\"dr-new-doctor\",\"password\":\"password123\",\"name\":\"新医生\",\"title\":\"主治医师\",\"department\":\"外科\",\"avatar\":\"https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg\",\"experience\":\"5年临床经验\",\"specialties\":[\"外科手术\",\"创伤修复\"],\"isActive\":true}"
echo.
echo.

echo Testing 8: Update Doctor (doc006)
curl -s -X PUT "%BASE_URL%/doc006" -H "Content-Type: application/json" -d "{\"id\":\"doc006\",\"username\":\"dr-new-doctor\",\"password\":\"password123\",\"name\":\"新医生-更新\",\"title\":\"副主任医师\",\"department\":\"外科\",\"avatar\":\"https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg\",\"experience\":\"6年临床经验\",\"specialties\":[\"外科手术\",\"创伤修复\",\"微创手术\"],\"isActive\":true}"
echo.
echo.

echo Testing 9: Delete Doctor (doc006)
curl -s -X DELETE "%BASE_URL%/doc006"
echo.
echo.

echo Testing 10: Verify Deletion (404 Test)
curl -s -X GET "%BASE_URL%/doc006"
echo.
echo.

echo ==========================================
echo Test Suite Completed
echo ==========================================
