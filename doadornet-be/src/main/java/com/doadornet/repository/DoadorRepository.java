package com.doadornet.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.doadornet.model.Doador;

@Repository
public interface DoadorRepository extends JpaRepository<Doador, Long> {
}
