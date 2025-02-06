package com.doadornet.controller;

import com.doadornet.model.Doador;
import com.doadornet.service.DoadorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/doadores")
public class DoadorController {

    @Autowired
    private DoadorService doadorService;

    @GetMapping
    public ResponseEntity<Map<String, Object>> listarTodos() {
        List<Doador> doadores = doadorService.listarTodos();

        // Estrutura para armazenar os dados
        Map<String, Object> response = new HashMap<>();

        // Contagem de candidatos por estado
        Map<String, Long> candidatosPorEstado = doadores.stream().collect(Collectors.groupingBy(Doador::getEstado, Collectors.counting()));

        // IMC médio por faixa etária (0-10, 11-20, etc.)
        Map<String, Double> imcPorFaixaEtaria = new HashMap<>();
        Map<String, List<Double>> imcValores = new HashMap<>();

        for (Doador d : doadores) {
            String faixa = ((d.getIdade() / 10) * 10) + "-" + (((d.getIdade() / 10) * 10) + 9);
            double imc = d.getPeso() / Math.pow(d.getAltura(), 2);

            imcValores.computeIfAbsent(faixa, k -> new ArrayList<>()).add(imc);
        }

        imcValores.forEach((faixa, valores) -> {
            double media = valores.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
            imcPorFaixaEtaria.put(faixa, media);
        });

        // Percentual de obesos por sexo
        long totalHomens = doadores.stream().filter(d -> d.getSexo().equalsIgnoreCase("Masculino")).count();
        long totalMulheres = doadores.stream().filter(d -> d.getSexo().equalsIgnoreCase("Feminino")).count();
        long obesosHomens = doadores.stream().filter(d -> d.getSexo().equalsIgnoreCase("Masculino") && (d.getPeso() / Math.pow(d.getAltura(), 2)) > 30).count();
        long obesosMulheres = doadores.stream().filter(d -> d.getSexo().equalsIgnoreCase("Feminino") && (d.getPeso() / Math.pow(d.getAltura(), 2)) > 30).count();

        double percentualObesosHomens = totalHomens > 0 ? (obesosHomens * 100.0) / totalHomens : 0.0;
        double percentualObesosMulheres = totalMulheres > 0 ? (obesosMulheres * 100.0) / totalMulheres : 0.0;
        Map<String, Double> percentualObesos = new HashMap<>();
        percentualObesos.put("Homens", percentualObesosHomens);
        percentualObesos.put("Mulheres", percentualObesosMulheres);

        // Média de idade por tipo sanguíneo
        Map<String, Double> idadePorSangue = new HashMap<>();
        Map<String, List<Integer>> idadeValores = new HashMap<>();

        for (Doador d : doadores) {
            idadeValores.computeIfAbsent(d.getTipoSanguineo(), k -> new ArrayList<>()).add(d.getIdade());
        }

        idadeValores.forEach((tipo, idades) -> {
            double media = idades.stream().mapToInt(Integer::intValue).average().orElse(0.0);
            idadePorSangue.put(tipo, media);
        });

        // Quantidade de possíveis doadores para cada tipo sanguíneo receptor
        Map<String, Long> doadoresPorSangue = doadores.stream().collect(Collectors.groupingBy(Doador::getTipoSanguineo, Collectors.counting()));
        Map<String, Long> possiveisDoadores = new HashMap<>();

        Map<String, List<String>> compatibilidade = Map.of(
                "A+", List.of("A+", "A-", "O+", "O-"),
                "A-", List.of("A-", "O-"),
                "B+", List.of("B+", "B-", "O+", "O-"),
                "B-", List.of("B-", "O-"),
                "AB+", List.of("A+", "B+", "AB+", "O+", "A-", "B-", "AB-", "O-"),
                "AB-", List.of("A-", "B-", "AB-", "O-"),
                "O+", List.of("O+", "O-"),
                "O-", List.of("O-")
        );

        compatibilidade.forEach((receptor, doadoresList) -> {
            long count = doadoresList.stream().mapToLong(tipo -> doadoresPorSangue.getOrDefault(tipo, 0L)).sum();
            possiveisDoadores.put(receptor, count);
        });

        // Quantidade de registros processadas no json carregado no app
        Map<String, Integer> total = new HashMap<>();
        total.put("Doadores cadastrados", doadores.size());

        // Montando a resposta
        response.put("totalRegistros", total);
        response.put("candidatosPorEstado", candidatosPorEstado);
        response.put("imcPorFaixaEtaria", imcPorFaixaEtaria);
        response.put("percentualObesos", percentualObesos);
        response.put("idadePorSangue", idadePorSangue);
        response.put("possiveisDoadores", possiveisDoadores);

        System.out.println(response);
        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<String> addList(@RequestBody List<Doador> doadores) {
        int quantidade = 0;
        for (Doador doador : doadores) {
            System.out.println("Recebido: " + doador.toString());
            doadorService.salvar(doador);
            quantidade += 1;
        }
        return ResponseEntity.ok("Registros criados com sucesso. Total: " + quantidade);
    }

    @DeleteMapping
    public ResponseEntity<String> deleteAllDoadores() {
        doadorService.deleteAll();
        return ResponseEntity.ok("Todos os registros foram excluídos.");
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<String> handleJsonParsingException(HttpMessageNotReadableException ex) {
        return ResponseEntity.badRequest().body("Erro no JSON recebido: " + ex.getMostSpecificCause().getMessage());
    }
}
