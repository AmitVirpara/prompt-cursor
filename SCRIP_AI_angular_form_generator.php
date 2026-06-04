#!/usr/bin/env php
<?php

declare(strict_types=1);

/**
 * SCRIP_AI Angular Form/List Generator
 *
 * Reads a MySQL database schema and generates Angular standalone code:
 * - models
 * - API services with search/sort/page/filter params
 * - list components
 * - reactive form components
 * - generated route file
 *
 * Usage:
 * php SCRIP_AI_angular_form_generator.php \
 *   --host=127.0.0.1 --port=3306 --database=logistics_erp \
 *   --user=root --password=secret --out=/path/to/angular/src/app/generated
 */

final class AngularFormGenerator
{
    private PDO $pdo;
    private string $database;
    private string $outputRoot;

    public function __construct(private array $options)
    {
        $this->database = $this->option('database', 'logistics_erp');
        $this->outputRoot = rtrim($this->option('out', getcwd() . '/SCRIP_AI_output_angular/src/app/generated'), '/');

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
        $routes = [
            "import { Routes } from '@angular/router';",
        ];
        $routeEntries = [];

        $this->write('generated-api.types.ts', $this->apiTypes());

        foreach ($this->tables() as $table) {
            $columns = $this->columns($table);
            if ($columns === []) {
                continue;
            }

            $entity = $this->studly($this->singular($table));
            $folder = $this->kebab($table);
            $routePath = $this->kebab($table);
            $listComponent = "{$entity}ListComponent";
            $formComponent = "{$entity}FormComponent";

            $this->writeModel($folder, $entity, $columns);
            $this->writeService($folder, $entity, $table, $columns);
            $this->writeListComponent($folder, $entity, $table, $columns);
            $this->writeFormComponent($folder, $entity, $table, $columns);

            $routes[] = "import { {$listComponent} } from './{$folder}/{$folder}-list.component';";
            $routes[] = "import { {$formComponent} } from './{$folder}/{$folder}-form.component';";
            $routeEntries[] = "  { path: '{$routePath}', component: {$listComponent} },";
            $routeEntries[] = "  { path: '{$routePath}/new', component: {$formComponent} },";
            $routeEntries[] = "  { path: '{$routePath}/:id/edit', component: {$formComponent} },";
        }

        $routes[] = '';
        $routes[] = 'export const generatedRoutes: Routes = [';
        $routes[] = implode(PHP_EOL, $routeEntries);
        $routes[] = '];';
        $routes[] = '';

        $this->write('generated.routes.ts', implode(PHP_EOL, $routes));

        $this->log('Angular form/list files generated in: ' . $this->outputRoot);
        $this->log('Import generatedRoutes into your app routing configuration.');
    }

    private function writeModel(string $folder, string $entity, array $columns): void
    {
        $lines = [
            "export interface {$entity} {",
            '  [key: string]: unknown;',
        ];

        foreach ($columns as $column) {
            $optional = $column['IS_NULLABLE'] === 'YES' ? '?' : '';
            $lines[] = '  ' . $this->camel($column['COLUMN_NAME']) . $optional . ': ' . $this->tsType($column) . ';';
        }

        $lines[] = '}';
        $lines[] = '';

        $this->write("{$folder}/{$folder}.model.ts", implode(PHP_EOL, $lines));
    }

    private function writeService(string $folder, string $entity, string $table, array $columns): void
    {
        $route = $this->kebab($table);
        $idField = $this->camel($this->primaryColumn($columns) ?? 'id');

        $code = <<<TS
import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { GeneratedPage } from '../generated-api.types';
import { {$entity} } from './{$folder}.model';

export interface {$entity}ListParams {
  search?: string;
  page?: number;
  per_page?: number;
  size?: number;
  sort_by?: string;
  sortBy?: string;
  sort_dir?: 'asc' | 'desc';
  sortDir?: 'asc' | 'desc';
  filter?: Record<string, string | number | boolean | null | undefined>;
}

@Injectable({ providedIn: 'root' })
export class {$entity}Service {
  private readonly baseUrl = '/api/{$route}';

  constructor(private readonly http: HttpClient) {}

  list(params: {$entity}ListParams = {}): Observable<GeneratedPage<{$entity}>> {
    return this.http.get<GeneratedPage<{$entity}>>(this.baseUrl, {
      params: this.buildParams(params),
    });
  }

  get(id: string | number): Observable<{$entity}> {
    return this.http.get<{$entity}>(this.baseUrl + '/' + id);
  }

  create(payload: Partial<{$entity}>): Observable<{$entity}> {
    return this.http.post<{$entity}>(this.baseUrl, payload);
  }

  update(id: string | number, payload: Partial<{$entity}>): Observable<{$entity}> {
    return this.http.put<{$entity}>(this.baseUrl + '/' + id, payload);
  }

  delete(id: string | number): Observable<void> {
    return this.http.delete<void>(this.baseUrl + '/' + id);
  }

  getId(row: {$entity}): string | number {
    return row['{$idField}'] as string | number;
  }

  private buildParams(params: {$entity}ListParams): HttpParams {
    let httpParams = new HttpParams();

    Object.entries(params).forEach(([key, value]) => {
      if (key === 'filter' || value === undefined || value === null || value === '') {
        return;
      }
      httpParams = httpParams.set(key, String(value));
    });

    Object.entries(params.filter ?? {}).forEach(([key, value]) => {
      if (value === undefined || value === null || value === '') {
        return;
      }
      httpParams = httpParams.set('filter[' + key + ']', String(value));
      httpParams = httpParams.set('filter.' + key, String(value));
    });

    return httpParams;
  }
}

TS;

        $this->write("{$folder}/{$folder}.service.ts", $code);
    }

    private function writeListComponent(string $folder, string $entity, string $table, array $columns): void
    {
        $component = "{$entity}ListComponent";
        $service = "{$entity}Service";
        $displayColumns = array_slice(array_map(fn (array $column): string => $this->camel($column['COLUMN_NAME']), $columns), 0, 12);
        $columnsCode = $this->tsArray($displayColumns);
        $title = $this->title($table);

        $code = <<<TS
import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { {$entity} } from './{$folder}.model';
import { {$service} } from './{$folder}.service';

@Component({
  selector: 'app-{$folder}-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  template: `
    <section class="generated-page">
      <header class="generated-page__header">
        <h1>{$title}</h1>
        <a routerLink="./new">Create</a>
      </header>

      <div class="generated-toolbar">
        <input
          type="search"
          placeholder="Search {$title}"
          [(ngModel)]="search"
          (keyup.enter)="load()"
        />
        <button type="button" (click)="load()">Search</button>
        <button type="button" (click)="reset()">Reset</button>
      </div>

      <table class="generated-table">
        <thead>
          <tr>
            <th *ngFor="let column of columns" (click)="sort(column)">
              {{ column }}
              <span *ngIf="sortBy === column">{{ sortDir === 'asc' ? 'up' : 'down' }}</span>
            </th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr *ngFor="let row of rows">
            <td *ngFor="let column of columns">{{ row[column] }}</td>
            <td>
              <a [routerLink]="['./', service.getId(row), 'edit']">Edit</a>
              <button type="button" (click)="remove(row)">Delete</button>
            </td>
          </tr>
        </tbody>
      </table>

      <footer class="generated-pagination">
        <button type="button" [disabled]="page <= 1" (click)="page = page - 1; load()">Previous</button>
        <span>Page {{ page }} / {{ totalPages }}</span>
        <button type="button" [disabled]="page >= totalPages" (click)="page = page + 1; load()">Next</button>
      </footer>
    </section>
  `,
})
export class {$component} implements OnInit {
  columns = {$columnsCode};
  rows: {$entity}[] = [];
  search = '';
  page = 1;
  perPage = 25;
  totalPages = 1;
  sortBy = this.columns[0] ?? 'id';
  sortDir: 'asc' | 'desc' = 'desc';

  constructor(public readonly service: {$service}) {}

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.service.list({
      search: this.search,
      page: this.page,
      per_page: this.perPage,
      size: this.perPage,
      sort_by: this.sortBy,
      sortBy: this.sortBy,
      sort_dir: this.sortDir,
      sortDir: this.sortDir,
    }).subscribe((response) => {
      const anyResponse = response as any;
      this.rows = anyResponse.data ?? anyResponse.content ?? [];
      const meta = anyResponse.meta ?? {};
      this.totalPages = meta.last_page ?? anyResponse.totalPages ?? 1;
    });
  }

  sort(column: string): void {
    if (this.sortBy === column) {
      this.sortDir = this.sortDir === 'asc' ? 'desc' : 'asc';
    } else {
      this.sortBy = column;
      this.sortDir = 'asc';
    }
    this.load();
  }

  reset(): void {
    this.search = '';
    this.page = 1;
    this.load();
  }

  remove(row: {$entity}): void {
    if (!confirm('Delete this record?')) {
      return;
    }
    this.service.delete(this.service.getId(row)).subscribe(() => this.load());
  }
}

TS;

        $this->write("{$folder}/{$folder}-list.component.ts", $code);
    }

    private function writeFormComponent(string $folder, string $entity, string $table, array $columns): void
    {
        $component = "{$entity}FormComponent";
        $service = "{$entity}Service";
        $idField = $this->camel($this->primaryColumn($columns) ?? 'id');
        $formColumns = array_values(array_filter($columns, fn (array $column): bool => ! $this->isAutoPrimary($column) && ! in_array($column['COLUMN_NAME'], ['created_at', 'updated_at'], true)));
        $formControls = $this->formControls($formColumns);
        $fieldMeta = $this->fieldMeta($formColumns);
        $title = $this->title($table);

        $code = <<<TS
import { CommonModule } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { {$service} } from './{$folder}.service';

@Component({
  selector: 'app-{$folder}-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  template: `
    <section class="generated-page">
      <h1>{{ recordId ? 'Edit' : 'Create' }} {$title}</h1>

      <form [formGroup]="form" (ngSubmit)="save()" class="generated-form">
        <label *ngFor="let field of fields">
          <span>{{ field.label }}</span>

          <input
            *ngIf="field.inputType !== 'textarea' && field.inputType !== 'checkbox'"
            [type]="field.inputType"
            [formControlName]="field.name"
          />

          <textarea
            *ngIf="field.inputType === 'textarea'"
            [formControlName]="field.name"
          ></textarea>

          <input
            *ngIf="field.inputType === 'checkbox'"
            type="checkbox"
            [formControlName]="field.name"
          />

          <small *ngIf="form.get(field.name)?.invalid && form.get(field.name)?.touched">
            {{ field.label }} is invalid.
          </small>
        </label>

        <div class="generated-form__actions">
          <button type="submit" [disabled]="form.invalid || saving">Save</button>
          <button type="button" (click)="cancel()">Cancel</button>
        </div>
      </form>
    </section>
  `,
})
export class {$component} implements OnInit {
  recordId: string | null = null;
  saving = false;
  fields = {$fieldMeta};
  form = this.fb.group({$formControls});

  constructor(
    private readonly fb: FormBuilder,
    private readonly route: ActivatedRoute,
    private readonly router: Router,
    private readonly service: {$service},
  ) {}

  ngOnInit(): void {
    this.recordId = this.route.snapshot.paramMap.get('id');
    if (this.recordId) {
      this.service.get(this.recordId).subscribe((record) => {
        this.form.patchValue(record as any);
      });
    }
  }

  save(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }

    this.saving = true;
    const payload = this.form.getRawValue() as any;
    const request = this.recordId
      ? this.service.update(this.recordId, payload)
      : this.service.create(payload);

    request.subscribe({
      next: () => this.router.navigate(['../'], { relativeTo: this.route }),
      error: () => {
        this.saving = false;
      },
    });
  }

  cancel(): void {
    this.router.navigate(['../'], { relativeTo: this.route });
  }
}

TS;

        $this->write("{$folder}/{$folder}-form.component.ts", $code);
    }

    private function apiTypes(): string
    {
        return <<<TS
export interface GeneratedPage<T> {
  data?: T[];
  content?: T[];
  meta?: {
    current_page?: number;
    last_page?: number;
    per_page?: number;
    total?: number;
  };
  number?: number;
  size?: number;
  totalElements?: number;
  totalPages?: number;
}

TS;
    }

    private function formControls(array $columns): string
    {
        if ($columns === []) {
            return '{}';
        }

        $lines = ['{'];
        foreach ($columns as $column) {
            $field = $this->camel($column['COLUMN_NAME']);
            $validators = [];
            if ($column['IS_NULLABLE'] !== 'YES') {
                $validators[] = 'Validators.required';
            }
            if ($column['CHARACTER_MAXIMUM_LENGTH'] !== null && (int) $column['CHARACTER_MAXIMUM_LENGTH'] > 0) {
                $validators[] = 'Validators.maxLength(' . (int) $column['CHARACTER_MAXIMUM_LENGTH'] . ')';
            }
            $default = $this->defaultFormValue($column);
            $validatorCode = $validators === [] ? '' : ', [' . implode(', ', $validators) . ']';
            $lines[] = "    {$field}: [{$default}{$validatorCode}],";
        }
        $lines[] = '  }';

        return implode(PHP_EOL, $lines);
    }

    private function fieldMeta(array $columns): string
    {
        if ($columns === []) {
            return '[]';
        }

        $lines = ['['];
        foreach ($columns as $column) {
            $field = $this->camel($column['COLUMN_NAME']);
            $label = $this->title($column['COLUMN_NAME']);
            $inputType = $this->inputType($column);
            $lines[] = "    { name: '{$field}', label: '{$label}', inputType: '{$inputType}' },";
        }
        $lines[] = '  ]';

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
            'SELECT COLUMN_NAME, DATA_TYPE, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY, EXTRA, CHARACTER_MAXIMUM_LENGTH
             FROM information_schema.COLUMNS
             WHERE TABLE_SCHEMA = :database AND TABLE_NAME = :table
             ORDER BY ORDINAL_POSITION'
        );
        $statement->execute(['database' => $this->database, 'table' => $table]);

        return $statement->fetchAll();
    }

    private function tsType(array $column): string
    {
        $type = strtolower($column['DATA_TYPE']);
        $columnType = strtolower($column['COLUMN_TYPE']);

        return match (true) {
            $type === 'tinyint' && str_contains($columnType, 'tinyint(1)') => 'boolean',
            in_array($type, ['int', 'integer', 'bigint', 'smallint', 'mediumint', 'decimal', 'numeric', 'double', 'float', 'real'], true) => 'number',
            $type === 'json' => 'Record<string, unknown> | unknown[]',
            default => 'string',
        };
    }

    private function inputType(array $column): string
    {
        $type = strtolower($column['DATA_TYPE']);
        $name = strtolower($column['COLUMN_NAME']);
        $columnType = strtolower($column['COLUMN_TYPE']);

        return match (true) {
            $type === 'tinyint' && str_contains($columnType, 'tinyint(1)') => 'checkbox',
            in_array($type, ['text', 'tinytext', 'mediumtext', 'longtext', 'json'], true) => 'textarea',
            in_array($type, ['int', 'integer', 'bigint', 'smallint', 'mediumint', 'decimal', 'numeric', 'double', 'float', 'real'], true) => 'number',
            $type === 'date' => 'date',
            $type === 'time' => 'time',
            in_array($type, ['datetime', 'timestamp'], true) => 'datetime-local',
            str_contains($name, 'email') => 'email',
            str_contains($name, 'password') => 'password',
            default => 'text',
        };
    }

    private function defaultFormValue(array $column): string
    {
        $type = strtolower($column['DATA_TYPE']);
        $columnType = strtolower($column['COLUMN_TYPE']);

        if ($type === 'tinyint' && str_contains($columnType, 'tinyint(1)')) {
            return 'false';
        }
        if (in_array($type, ['int', 'integer', 'bigint', 'smallint', 'mediumint', 'decimal', 'numeric', 'double', 'float', 'real'], true)) {
            return 'null';
        }

        return "''";
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

    private function isAutoPrimary(array $column): bool
    {
        return $column['COLUMN_KEY'] === 'PRI' && str_contains((string) $column['EXTRA'], 'auto_increment');
    }

    private function tsArray(array $items): string
    {
        return '[' . implode(', ', array_map(static fn (string $item): string => "'" . addslashes($item) . "'", $items)) . ']';
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

    private function title(string $value): string
    {
        return ucwords(str_replace(['-', '_'], ' ', $value));
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
]);

(new AngularFormGenerator($options))->run();
