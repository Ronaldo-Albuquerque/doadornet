package com.doadornet.service;

import com.doadornet.model.Doador;
import com.doadornet.repository.DoadorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DoadorService {

    @Autowired
    private DoadorRepository repository;

    public List<Doador> listarTodos() {
        return repository.findAll();
    }

    public Doador salvar(Doador doador) {
        if (doador.getDataNasc() == null) {
            throw new IllegalArgumentException("A data de nascimento não pode ser nula");
        }
        return repository.save(doador);
    }

    public void deleteAll() {
        repository.deleteAll();
    }
}
