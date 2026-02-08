package com.leansofx.qaserviceuser.repository;

import com.leansofx.qaserviceuser.entity.Doctor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DoctorRepository extends JpaRepository<Doctor, String> {

    Doctor findByUsername(String username);

    List<Doctor> findByIsActiveTrueOrderByCreatedAtDesc();

    @Query("SELECT d FROM Doctor d WHERE d.isActive = true ORDER BY d.createdAt DESC")
    List<Doctor> findActiveDoctors();

    boolean existsByUsername(String username);
}
