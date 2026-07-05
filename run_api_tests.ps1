# API Test Script for qa-service-user Doctor API (PowerShell)
$BASE_URL = "http://localhost:8080/api/doctors"

Write-Host "=========================================="
Write-Host "QA Service User - Doctor API Test Suite"
Write-Host "=========================================="
Write-Host ""

Write-Host "Testing 1: Health Check"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/health" -Method Get
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
Write-Host ""

Write-Host "Testing 2: Get All Doctors"
try {
    $response = Invoke-RestMethod -Uri $BASE_URL -Method Get
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
Write-Host ""

Write-Host "Testing 3: Get Active Doctors"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/active" -Method Get
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
Write-Host ""

Write-Host "Testing 4: Get Doctor by ID (doc001)"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/doc001" -Method Get
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
Write-Host ""

Write-Host "Testing 5: Get Doctor by Username (dr-zhang-wei)"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/username/dr-zhang-wei" -Method Get
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
Write-Host ""

Write-Host "Testing 6: Get Non-existent Doctor (404 Test)"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/nonexistent" -Method Get
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
Write-Host ""

Write-Host "Testing 7: Create New Doctor"
$body = @{
    id = "doc006"
    username = "dr-new-doctor"
    password = "password123"
    name = "New Doctor"
    title = "Attending Physician"
    department = "Surgery"
    avatar = "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg"
    experience = "5 years clinical experience"
    specialties = @("Surgery", "Trauma Repair")
    isActive = $true
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri $BASE_URL -Method Post -Body $body -ContentType "application/json"
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
Write-Host ""

Write-Host "Testing 8: Update Doctor (doc006)"
$body = @{
    id = "doc006"
    username = "dr-new-doctor"
    password = "password123"
    name = "New Doctor Updated"
    title = "Associate Chief Physician"
    department = "Surgery"
    avatar = "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg"
    experience = "6 years clinical experience"
    specialties = @("Surgery", "Trauma Repair", "Minimally Invasive Surgery")
    isActive = $true
} | ConvertTo-Json -Depth 10

try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/doc006" -Method Put -Body $body -ContentType "application/json"
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
Write-Host ""

Write-Host "Testing 9: Delete Doctor (doc006)"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/doc006" -Method Delete
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
Write-Host ""

Write-Host "Testing 10: Verify Deletion (404 Test)"
try {
    $response = Invoke-RestMethod -Uri "$BASE_URL/doc006" -Method Get
    $response | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
Write-Host ""

Write-Host "=========================================="
Write-Host "Test Suite Completed"
Write-Host "=========================================="
