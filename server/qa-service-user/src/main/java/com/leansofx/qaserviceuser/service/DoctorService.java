package com.leansofx.qaserviceuser.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.leansofx.qaserviceuser.dto.DoctorResponse;
import com.leansofx.qaserviceuser.entity.Doctor;
import com.leansofx.qaserviceuser.repository.DoctorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class DoctorService {

    @Autowired
    private DoctorRepository doctorRepository;

    private final ObjectMapper objectMapper = new ObjectMapper();

    public List<DoctorResponse> getAllDoctors() {
        List<Doctor> doctors = doctorRepository.findAll();
        return doctors.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public List<DoctorResponse> getActiveDoctors() {
        List<Doctor> doctors = doctorRepository.findActiveDoctors();
        return doctors.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public Optional<DoctorResponse> getDoctorById(String id) {
        return doctorRepository.findById(id)
                .map(this::mapToResponse);
    }

    public Optional<DoctorResponse> getDoctorByUsername(String username) {
        Doctor doctor = doctorRepository.findByUsername(username);
        return Optional.ofNullable(doctor).map(this::mapToResponse);
    }

    public DoctorResponse createDoctor(Doctor doctor) {
        if (doctorRepository.existsByUsername(doctor.getUsername())) {
            throw new RuntimeException("Username already exists");
        }
        Doctor savedDoctor = doctorRepository.save(doctor);
        return mapToResponse(savedDoctor);
    }

    public Optional<DoctorResponse> updateDoctor(String id, Doctor doctorDetails) {
        return doctorRepository.findById(id)
                .map(doctor -> {
                    if (!doctor.getUsername().equals(doctorDetails.getUsername()) &&
                        doctorRepository.existsByUsername(doctorDetails.getUsername())) {
                        throw new RuntimeException("Username already exists");
                    }
                    doctor.setUsername(doctorDetails.getUsername());
                    doctor.setPassword(doctorDetails.getPassword());
                    doctor.setName(doctorDetails.getName());
                    doctor.setTitle(doctorDetails.getTitle());
                    doctor.setDepartment(doctorDetails.getDepartment());
                    doctor.setAvatar(doctorDetails.getAvatar());
                    doctor.setExperience(doctorDetails.getExperience());
                    doctor.setSpecialties(doctorDetails.getSpecialties());
                    doctor.setIsActive(doctorDetails.getIsActive());
                    return mapToResponse(doctorRepository.save(doctor));
                });
    }

    public boolean deleteDoctor(String id) {
        if (doctorRepository.existsById(id)) {
            doctorRepository.deleteById(id);
            return true;
        }
        return false;
    }

    private List<String> parseSpecialties(String specialtiesJson) {
        if (specialtiesJson == null || specialtiesJson.isEmpty()) {
            return new ArrayList<>();
        }
        try {
            return objectMapper.readValue(specialtiesJson, new TypeReference<List<String>>() {});
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    private DoctorResponse mapToResponse(Doctor doctor) {
        return new DoctorResponse(
                doctor.getId(),
                doctor.getUsername(),
                doctor.getName(),
                doctor.getTitle(),
                doctor.getDepartment(),
                doctor.getAvatar(),
                doctor.getExperience(),
                parseSpecialties(doctor.getSpecialties()),
                doctor.getIsActive()
        );
    }
}
