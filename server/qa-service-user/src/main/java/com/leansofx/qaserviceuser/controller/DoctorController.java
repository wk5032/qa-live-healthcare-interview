package com.leansofx.qaserviceuser.controller;

import com.leansofx.qaserviceuser.dto.ApiResponse;
import com.leansofx.qaserviceuser.dto.DoctorResponse;
import com.leansofx.qaserviceuser.entity.Doctor;
import com.leansofx.qaserviceuser.service.DoctorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class DoctorController {

    @Autowired
    private DoctorService doctorService;

    /**
     * Simple test endpoint
     * GET /api/test
     */
    @GetMapping("/test")
    public ResponseEntity<String> test() {
        return ResponseEntity.ok("Test successful");
    }

    /**
     * Get all doctors
     * GET /api/doctors
     */
    @GetMapping(value = "/doctors", produces = "application/json;charset=UTF-8")
    public ResponseEntity<ApiResponse<List<DoctorResponse>>> getAllDoctors() {
        try {
            List<DoctorResponse> doctors = doctorService.getAllDoctors();
            return ResponseEntity.ok(ApiResponse.success(doctors));
        } catch (Exception e) {
            return ResponseEntity.status(500)
                    .body(ApiResponse.error("Failed to retrieve doctors: " + e.getMessage()));
        }
    }

    /**
     * Get active doctors only
     * GET /api/doctors/active
     */
    @GetMapping("/doctors/active")
    public ResponseEntity<ApiResponse<List<DoctorResponse>>> getActiveDoctors() {
        try {
            List<DoctorResponse> doctors = doctorService.getActiveDoctors();
            return ResponseEntity.ok(ApiResponse.success(doctors));
        } catch (Exception e) {
            return ResponseEntity.status(500)
                    .body(ApiResponse.error("Failed to retrieve active doctors: " + e.getMessage()));
        }
    }

    /**
     * Get doctor by ID
     * GET /api/doctors/{id}
     */
    @GetMapping("/doctors/{id}")
    public ResponseEntity<ApiResponse<DoctorResponse>> getDoctorById(@PathVariable String id) {
        try {
            Optional<DoctorResponse> doctor = doctorService.getDoctorById(id);
            return doctor.map(value -> ResponseEntity.ok(ApiResponse.success(value)))
                    .orElseGet(() -> ResponseEntity.status(404)
                            .body(ApiResponse.error(404, "Doctor not found")));
        } catch (Exception e) {
            return ResponseEntity.status(500)
                    .body(ApiResponse.error("Failed to retrieve doctor: " + e.getMessage()));
        }
    }

    /**
     * Get doctor by username
     * GET /api/doctors/username/{username}
     */
    @GetMapping("/doctors/username/{username}")
    public ResponseEntity<ApiResponse<DoctorResponse>> getDoctorByUsername(@PathVariable String username) {
        try {
            Optional<DoctorResponse> doctor = doctorService.getDoctorByUsername(username);
            return doctor.map(value -> ResponseEntity.ok(ApiResponse.success(value)))
                    .orElseGet(() -> ResponseEntity.status(404)
                            .body(ApiResponse.error(404, "Doctor not found")));
        } catch (Exception e) {
            return ResponseEntity.status(500)
                    .body(ApiResponse.error("Failed to retrieve doctor: " + e.getMessage()));
        }
    }

    /**
     * Create new doctor
     * POST /api/doctors
     */
    @PostMapping("/doctors")
    public ResponseEntity<ApiResponse<DoctorResponse>> createDoctor(@RequestBody Doctor doctor) {
        try {
            DoctorResponse createdDoctor = doctorService.createDoctor(doctor);
            return ResponseEntity.status(201).body(ApiResponse.success("Doctor created successfully", createdDoctor));
        } catch (RuntimeException e) {
            return ResponseEntity.status(400)
                    .body(ApiResponse.error(400, e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(500)
                    .body(ApiResponse.error("Failed to create doctor: " + e.getMessage()));
        }
    }

    /**
     * Update doctor
     * PUT /api/doctors/{id}
     */
    @PutMapping("/doctors/{id}")
    public ResponseEntity<ApiResponse<DoctorResponse>> updateDoctor(
            @PathVariable String id,
            @RequestBody Doctor doctorDetails) {
        try {
            Optional<DoctorResponse> updatedDoctor = doctorService.updateDoctor(id, doctorDetails);
            return updatedDoctor.map(value -> ResponseEntity.ok(ApiResponse.success("Doctor updated successfully", value)))
                    .orElseGet(() -> ResponseEntity.status(404)
                            .body(ApiResponse.error(404, "Doctor not found")));
        } catch (RuntimeException e) {
            return ResponseEntity.status(400)
                    .body(ApiResponse.error(400, e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(500)
                    .body(ApiResponse.error("Failed to update doctor: " + e.getMessage()));
        }
    }

    /**
     * Delete doctor
     * DELETE /api/doctors/{id}
     */
    @DeleteMapping("/doctors/{id}")
    public ResponseEntity<ApiResponse<Map<String, Boolean>>> deleteDoctor(@PathVariable String id) {
        try {
            boolean deleted = doctorService.deleteDoctor(id);
            if (deleted) {
                return ResponseEntity.ok(ApiResponse.success("Doctor deleted successfully",
                        Map.of("deleted", true)));
            } else {
                return ResponseEntity.status(404)
                        .body(ApiResponse.error(404, "Doctor not found"));
            }
        } catch (Exception e) {
            return ResponseEntity.status(500)
                    .body(ApiResponse.error("Failed to delete doctor: " + e.getMessage()));
        }
    }

    /**
     * Health check endpoint
     * GET /api/doctors/health
     */
    @GetMapping("/doctors/health")
    public ResponseEntity<ApiResponse<Map<String, String>>> healthCheck() {
        Map<String, String> healthData = new HashMap<>();
        healthData.put("service", "qa-service-user");
        healthData.put("endpoint", "doctors");
        healthData.put("status", "healthy");
        return ResponseEntity.ok(ApiResponse.success(healthData));
    }
}
