package com.doadornet.service;

import java.util.List;

// import org.hibernate.mapping.List;
import org.springframework.stereotype.Service;

import com.doadornet.entity.Doador;
import com.doadornet.repository.DoadorRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DoadorService {
    private final DoadorRepository doadorRepository;

    public List<Doador> listarTodos() {
        return doadorRepository.findAll();
    }
}
