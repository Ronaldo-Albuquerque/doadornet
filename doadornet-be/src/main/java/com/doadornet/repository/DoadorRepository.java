package com.doadornet.repository;

import java.util.List;

// import org.hibernate.mapping.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.doadornet.entity.Doador;

@Repository
public interface DoadorRepository extends JpaRepository<Doador, Long> {
    List<Doador> findByEstado(String estado);
}
