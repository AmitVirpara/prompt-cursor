#!/usr/bin/env php
<?php

declare(strict_types=1);

/**
 * SCRIP_AI Spring Boot REST API Generator
 *
 * Reads a MySQL database schema and generates Spring Boot REST API scaffolding:
 * - entity classes
 * - repositories
 * - services
 * - controllers with search, sorting, paging, and filter.* query params
 *
 * Usage:
 * php SCRIP_AI_springboot_rest_api_generator.php \
 *   --host=127.0.0.1 --port=3306 --database=logistics_erp \
 *   --user=root --password=secret --out=/path/to/spring-app \
 *   --package=com.example.logisticserp
 */

final class SpringBootRestApiGenerator
{
    private PDO $pdo;
    private string $database;
    private string $outputRoot;
    private string $basePackage;
    private string $javaRoot;

    public function __construct(private array $options)
    {
        $this->database = $this->option('database', 'logistics_erp');
        $this->outputRoot = rtrim($this->option('out', getcwd() . '/SCRIP_AI_output_springboot'), '/');
        $this->basePackage = $this->option('package', 'com.example.logisticserp');
        $this->javaRoot = 'src/main/java/' . str_replace('.', '/', $this->basePackage);

        $dsn = sprintf(
            'mysql:host=%s;port=%s;dbname=%s;charset=utf8mb4',
            $this->option('host', '127.0.0.1'),
            $this->option('port', '3306'),
            $this->database
        );

        $this->pdo = new PDO($dsn, $this->option('user', 'root'), $this->option('password', ''), [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]);
    }

    public function run(): void
    {
        foreach ($this->tables() as $table) {
            $columns = $this->columns($table);
            if ($columns === []) {
                continue;
            }

            $entity = $this->studly($this->singular($table));
            $this->writeEntity($table, $entity, $columns);
            $this->writeRepository($entity, $columns);
            $this->writeService($entity, $columns);
            $this->writeController($table, $entity, $columns);
        }

        $this->log('Spring Boot REST API files generated in: ' . $this->outputRoot);
        $this->log('Generated controllers support: search, filter.<field>, page, size, sortBy, sortDir.');
    }

    private function writeEntity(string $table, string $entity, array $columns): void
    {
        $imports = [
            'jakarta.persistence.Column',
            'jakarta.persistence.Entity',
            'jakarta.persistence.GeneratedValue',
            'jakarta.persistence.GenerationType',
            'jakarta.persistence.Id',
            'jakarta.persistence.Table',
        ];

        foreach ($columns as $column) {
            $javaType = $this->javaType($column);
            if ($javaType === 'BigDecimal') {
                $imports[] = 'java.math.BigDecimal';
            }
            if ($javaType === 'LocalDate') {
                $imports[] = 'java.time.LocalDate';
            }
            if ($javaType === 'LocalDateTime') {
                $imports[] = 'java.time.LocalDateTime';
            }
            if ($javaType === 'LocalTime') {
                $imports[] = 'java.time.LocalTime';
            }
        }

        $imports = array_values(array_unique($imports));
        sort($imports);
        $importCode = implode(PHP_EOL, array_map(static fn (string $import): string => "import {$import};", $imports));

        $fields = [];
        $methods = [];
        foreach ($columns as $column) {
            $field = $this->camel($column['COLUMN_NAME']);
            $javaType = $this->javaType($column);
            $nullable = $column['IS_NULLABLE'] === 'YES' ? 'true' : 'false';
            $columnName = $column['COLUMN_NAME'];

            if ($column['COLUMN_KEY'] === 'PRI') {
                $fields[] = "    @Id";
                if (str_contains((string) $column['EXTRA'], 'auto_increment')) {
                    $fields[] = "    @GeneratedValue(strategy = GenerationType.IDENTITY)";
                }
            }

            $fields[] = "    @Column(name = \"{$columnName}\", nullable = {$nullable})";
            $fields[] = "    private {$javaType} {$field};";
            $fields[] = "";

            $suffix = ucfirst($field);
            $methods[] = "    public {$javaType} get{$suffix}() {";
            $methods[] = "        return {$field};";
            $methods[] = "    }";
            $methods[] = "";
            $methods[] = "    public void set{$suffix}({$javaType} {$field}) {";
            $methods[] = "        this.{$field} = {$field};";
            $methods[] = "    }";
            $methods[] = "";
        }

        $fieldCode = implode(PHP_EOL, $fields);
        $methodCode = implode(PHP_EOL, $methods);

        $code = <<<JAVA
package {$this->basePackage}.entity;

{$importCode}

@Entity
@Table(name = "{$table}")
public class {$entity} {

{$fieldCode}
{$methodCode}
}

JAVA;

        $this->write("{$this->javaRoot}/entity/{$entity}.java", $code);
    }

    private function writeRepository(string $entity, array $columns): void
    {
        $idType = $this->idJavaType($columns);
        $code = <<<JAVA
package {$this->basePackage}.repository;

import {$this->basePackage}.entity.{$entity};
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface {$entity}Repository extends JpaRepository<{$entity}, {$idType}>, JpaSpecificationExecutor<{$entity}> {
}

JAVA;

        $this->write("{$this->javaRoot}/repository/{$entity}Repository.java", $code);
    }

    private function writeService(string $entity, array $columns): void
    {
        $idType = $this->idJavaType($columns);
        $repository = "{$entity}Repository";

        $code = <<<JAVA
package {$this->basePackage}.service;

import {$this->basePackage}.entity.{$entity};
import {$this->basePackage}.repository.{$repository};
import jakarta.persistence.EntityNotFoundException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class {$entity}Service {

    private final {$repository} repository;

    public {$entity}Service({$repository} repository) {
        this.repository = repository;
    }

    @Transactional(readOnly = true)
    public Page<{$entity}> findAll(Specification<{$entity}> specification, Pageable pageable) {
        return repository.findAll(specification, pageable);
    }

    @Transactional(readOnly = true)
    public {$entity} findById({$idType} id) {
        return repository.findById(id).orElseThrow(() -> new EntityNotFoundException("{$entity} not found: " + id));
    }

    @Transactional
    public {$entity} create({$entity} entity) {
        return repository.save(entity);
    }

    @Transactional
    public {$entity} update({$idType} id, {$entity} entity) {
        {$entity} existing = findById(id);
        copyMutableFields(entity, existing);
        return repository.save(existing);
    }

    @Transactional
    public void delete({$idType} id) {
        repository.delete(findById(id));
    }

    private void copyMutableFields({$entity} source, {$entity} target) {
{$this->copyLines($columns)}
    }
}

JAVA;

        $this->write("{$this->javaRoot}/service/{$entity}Service.java", $code);
    }

    private function writeController(string $table, string $entity, array $columns): void
    {
        $idType = $this->idJavaType($columns);
        $primaryField = $this->camel($this->primaryColumn($columns) ?? 'id');
        $route = $this->kebab($table);
        $service = "{$entity}Service";
        $searchable = array_map(fn (array $column): string => $this->camel($column['COLUMN_NAME']), array_filter($columns, fn (array $column): bool => $this->isTextColumn($column)));
        $filterable = array_map(fn (array $column): string => $this->camel($column['COLUMN_NAME']), $columns);
        $searchableCode = $this->javaList($searchable);
        $filterableCode = $this->javaList($filterable);

        $code = <<<JAVA
package {$this->basePackage}.controller;

import {$this->basePackage}.entity.{$entity};
import {$this->basePackage}.service.{$service};
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

@RestController
@RequestMapping("/api/{$route}")
public class {$entity}Controller {

    private static final Set<String> SEARCHABLE = Set.of({$searchableCode});
    private static final Set<String> FILTERABLE = Set.of({$filterableCode});

    private final {$service} service;

    public {$entity}Controller({$service} service) {
        this.service = service;
    }

    @GetMapping
    public Page<{$entity}> index(
            @RequestParam Map<String, String> params,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "25") int size,
            @RequestParam(defaultValue = "{$primaryField}") String sortBy,
            @RequestParam(defaultValue = "desc") String sortDir,
            @RequestParam(required = false) String search
    ) {
        int safeSize = Math.min(Math.max(size, 1), 100);
        Sort.Direction direction = "asc".equalsIgnoreCase(sortDir) ? Sort.Direction.ASC : Sort.Direction.DESC;
        Pageable pageable = PageRequest.of(Math.max(page, 0), safeSize, Sort.by(direction, sortBy));

        return service.findAll(buildSpecification(params, search), pageable);
    }

    @GetMapping("/{id}")
    public {$entity} show(@PathVariable {$idType} id) {
        return service.findById(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public {$entity} store(@RequestBody {$entity} entity) {
        return service.create(entity);
    }

    @PutMapping("/{id}")
    public {$entity} update(@PathVariable {$idType} id, @RequestBody {$entity} entity) {
        return service.update(id, entity);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void destroy(@PathVariable {$idType} id) {
        service.delete(id);
    }

    private Specification<{$entity}> buildSpecification(Map<String, String> params, String search) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (search != null && !search.isBlank() && !SEARCHABLE.isEmpty()) {
                String likeSearch = "%" + search.toLowerCase() + "%";
                List<Predicate> searchPredicates = new ArrayList<>();
                for (String field : SEARCHABLE) {
                    searchPredicates.add(cb.like(cb.lower(root.get(field).as(String.class)), likeSearch));
                }
                predicates.add(cb.or(searchPredicates.toArray(new Predicate[0])));
            }

            params.forEach((key, value) -> {
                if (key.startsWith("filter.") && value != null && !value.isBlank()) {
                    String field = key.substring("filter.".length());
                    if (FILTERABLE.contains(field)) {
                        predicates.add(cb.equal(root.get(field).as(String.class), value));
                    }
                }
            });

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}

JAVA;

        $this->write("{$this->javaRoot}/controller/{$entity}Controller.java", $code);
    }

    private function copyLines(array $columns): string
    {
        $lines = [];
        foreach ($columns as $column) {
            if ($column['COLUMN_KEY'] === 'PRI') {
                continue;
            }
            $field = $this->camel($column['COLUMN_NAME']);
            $suffix = ucfirst($field);
            $lines[] = "        target.set{$suffix}(source.get{$suffix}());";
        }

        return implode(PHP_EOL, $lines);
    }

    private function tables(): array
    {
        $statement = $this->pdo->prepare(
            'SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = :database AND TABLE_TYPE = "BASE TABLE" ORDER BY TABLE_NAME'
        );
        $statement->execute(['database' => $this->database]);

        return array_map(static fn (array $row): string => $row['TABLE_NAME'], $statement->fetchAll());
    }

    private function columns(string $table): array
    {
        $statement = $this->pdo->prepare(
            'SELECT COLUMN_NAME, DATA_TYPE, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY, EXTRA
             FROM information_schema.COLUMNS
             WHERE TABLE_SCHEMA = :database AND TABLE_NAME = :table
             ORDER BY ORDINAL_POSITION'
        );
        $statement->execute(['database' => $this->database, 'table' => $table]);

        return $statement->fetchAll();
    }

    private function javaType(array $column): string
    {
        $type = strtolower($column['DATA_TYPE']);
        $columnType = strtolower($column['COLUMN_TYPE']);

        return match (true) {
            $type === 'tinyint' && str_contains($columnType, 'tinyint(1)') => 'Boolean',
            in_array($type, ['int', 'integer', 'smallint', 'mediumint'], true) => 'Integer',
            $type === 'bigint' => 'Long',
            in_array($type, ['decimal', 'numeric'], true) => 'BigDecimal',
            in_array($type, ['double', 'float', 'real'], true) => 'Double',
            $type === 'date' => 'LocalDate',
            $type === 'time' => 'LocalTime',
            in_array($type, ['datetime', 'timestamp'], true) => 'LocalDateTime',
            default => 'String',
        };
    }

    private function idJavaType(array $columns): string
    {
        foreach ($columns as $column) {
            if ($column['COLUMN_KEY'] === 'PRI') {
                return $this->javaType($column);
            }
        }

        return 'Long';
    }

    private function primaryColumn(array $columns): ?string
    {
        foreach ($columns as $column) {
            if ($column['COLUMN_KEY'] === 'PRI') {
                return $column['COLUMN_NAME'];
            }
        }

        return null;
    }

    private function isTextColumn(array $column): bool
    {
        return in_array(strtolower($column['DATA_TYPE']), [
            'char', 'varchar', 'text', 'tinytext', 'mediumtext', 'longtext', 'enum', 'set',
        ], true);
    }

    private function javaList(array $items): string
    {
        if ($items === []) {
            return '';
        }

        return implode(', ', array_map(static fn (string $item): string => '"' . addslashes($item) . '"', $items));
    }

    private function option(string $key, string $default): string
    {
        return (string) ($this->options[$key] ?? $default);
    }

    private function write(string $relativePath, string $contents): void
    {
        $path = $this->outputRoot . '/' . ltrim($relativePath, '/');
        $dir = dirname($path);
        if (! is_dir($dir) && ! mkdir($dir, 0775, true) && ! is_dir($dir)) {
            throw new RuntimeException("Unable to create directory: {$dir}");
        }
        file_put_contents($path, $contents);
    }

    private function studly(string $value): string
    {
        return str_replace(' ', '', ucwords(str_replace(['-', '_'], ' ', $value)));
    }

    private function camel(string $value): string
    {
        return lcfirst($this->studly($value));
    }

    private function kebab(string $value): string
    {
        return strtolower(trim(preg_replace('/[^A-Za-z0-9]+/', '-', $value), '-'));
    }

    private function singular(string $value): string
    {
        if (str_ends_with($value, 'ies')) {
            return substr($value, 0, -3) . 'y';
        }
        if (str_ends_with($value, 'ses')) {
            return substr($value, 0, -2);
        }
        if (str_ends_with($value, 's') && ! str_ends_with($value, 'ss')) {
            return substr($value, 0, -1);
        }

        return $value;
    }

    private function log(string $message): void
    {
        fwrite(STDOUT, $message . PHP_EOL);
    }
}

$options = getopt('', [
    'host::',
    'port::',
    'database:',
    'user::',
    'password::',
    'out::',
    'package::',
]);

(new SpringBootRestApiGenerator($options))->run();
