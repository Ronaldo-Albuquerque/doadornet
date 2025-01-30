package com.doadornet.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.doadornet.entity.Doador;
import com.doadornet.service.DoadorService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/doadores")
@RequiredArgsConstructor
public class DoadorController {
    private final DoadorService doadorService;

    @GetMapping
    public ResponseEntity<List<Doador>> listarTodos() {
        return ResponseEntity.ok(doadorService.listarTodos());
    }
}
