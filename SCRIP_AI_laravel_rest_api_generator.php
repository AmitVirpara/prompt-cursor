#!/usr/bin/env php
<?php

declare(strict_types=1);

/**
 * SCRIP_AI Laravel REST API Generator
 *
 * Reads a MySQL database schema and generates Laravel REST API scaffolding:
 * - app/Models/{Model}.php
 * - app/Http/Requests/StoreUpdate{Model}Request.php
 * - app/Http/Resources/{Model}Resource.php
 * - app/Http/Controllers/Api/{Model}Controller.php
 * - routes/api_generated.php
 *
 * Usage:
 * php SCRIP_AI_laravel_rest_api_generator.php \
 *   --host=127.0.0.1 --port=3306 --database=logistics_erp \
 *   --user=root --password=secret --out=/path/to/laravel
 */

final class LaravelRestApiGenerator
{
    private PDO $pdo;
    private string $database;
    private string $outputRoot;

    public function __construct(private array $options)
    {
        $this->database = $this->option('database', 'logistics_erp');
        $this->outputRoot = rtrim($this->option('out', getcwd() . '/SCRIP_AI_output_laravel'), '/');

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
        $tables = $this->tables();
        $routeLines = [
            '<?php',
            '',
            'use Illuminate\Support\Facades\Route;',
        ];

        foreach ($tables as $table) {
            $columns = $this->columns($table);
            if ($columns === []) {
                continue;
            }

            $model = $this->studly($this->singular($table));
            $controller = $model . 'Controller';
            $route = $this->kebab($table);

            $this->writeModel($table, $model, $columns);
            $this->writeRequest($model, $columns);
            $this->writeResource($model);
            $this->writeController($table, $model, $controller, $columns);

            $routeLines[] = "use App\\Http\\Controllers\\Api\\{$controller};";
        }

        $routeLines[] = '';
        foreach ($tables as $table) {
            $model = $this->studly($this->singular($table));
            $route = $this->kebab($table);
            $routeLines[] = "Route::apiResource('{$route}', {$model}Controller::class);";
        }

        $this->write('routes/api_generated.php', implode(PHP_EOL, $routeLines) . PHP_EOL);

        $this->log('Laravel REST API files generated in: ' . $this->outputRoot);
        $this->log('Add this to routes/api.php: require __DIR__ . "/api_generated.php";');
    }

    private function writeModel(string $table, string $model, array $columns): void
    {
        $primary = $this->primaryColumn($columns) ?? 'id';
        $fillable = [];
        $casts = [];

        foreach ($columns as $column) {
            if ($column['COLUMN_KEY'] === 'PRI' && str_contains((string) $column['EXTRA'], 'auto_increment')) {
                continue;
            }
            if (in_array($column['COLUMN_NAME'], ['created_at', 'updated_at'], true)) {
                continue;
            }
            $fillable[] = $column['COLUMN_NAME'];
            $cast = $this->laravelCast($column);
            if ($cast !== null) {
                $casts[$column['COLUMN_NAME']] = $cast;
            }
        }

        $fillableCode = $this->phpArray($fillable, 8);
        $castsCode = $this->phpAssocArray($casts, 8);
        $incrementing = $this->primaryColumn($columns) && $this->primaryIsAutoIncrement($columns) ? 'true' : 'false';

        $code = <<<PHP
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class {$model} extends Model
{
    use HasFactory;

    protected \$table = '{$table}';
    protected \$primaryKey = '{$primary}';
    public \$incrementing = {$incrementing};

    protected \$fillable = {$fillableCode};

    protected \$casts = {$castsCode};
}

PHP;

        $this->write("app/Models/{$model}.php", $code);
    }

    private function writeRequest(string $model, array $columns): void
    {
        $rules = [];
        foreach ($columns as $column) {
            $name = $column['COLUMN_NAME'];
            if ($column['COLUMN_KEY'] === 'PRI' || in_array($name, ['created_at', 'updated_at'], true)) {
                continue;
            }

            $rules[$name] = $this->validationRule($column);
        }

        $rulesCode = $this->phpAssocArray($rules, 12);
        $code = <<<PHP
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreUpdate{$model}Request extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return {$rulesCode};
    }
}

PHP;

        $this->write("app/Http/Requests/StoreUpdate{$model}Request.php", $code);
    }

    private function writeResource(string $model): void
    {
        $code = <<<PHP
<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class {$model}Resource extends JsonResource
{
    public function toArray(Request \$request): array
    {
        return parent::toArray(\$request);
    }
}

PHP;

        $this->write("app/Http/Resources/{$model}Resource.php", $code);
    }

    private function writeController(string $table, string $model, string $controller, array $columns): void
    {
        $primary = $this->primaryColumn($columns) ?? 'id';
        $searchable = [];
        $sortable = [];
        $filterable = [];

        foreach ($columns as $column) {
            $name = $column['COLUMN_NAME'];
            $sortable[] = $name;
            if ($this->isTextColumn($column)) {
                $searchable[] = $name;
            }
            if ($name !== 'created_at' && $name !== 'updated_at') {
                $filterable[] = $name;
            }
        }

        $searchableCode = $this->phpArray($searchable, 8);
        $sortableCode = $this->phpArray($sortable, 8);
        $filterableCode = $this->phpArray($filterable, 8);
        $routeParam = $this->camel($model);

        $code = <<<PHP
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreUpdate{$model}Request;
use App\Http\Resources\\{$model}Resource;
use App\Models\\{$model};
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class {$controller} extends Controller
{
    private array \$searchable = {$searchableCode};
    private array \$sortable = {$sortableCode};
    private array \$filterable = {$filterableCode};

    public function index(Request \$request)
    {
        \$query = {$model}::query();

        if (\$request->filled('search') && \$this->searchable !== []) {
            \$search = trim((string) \$request->query('search'));
            \$query->where(function (\$inner) use (\$search) {
                foreach (\$this->searchable as \$column) {
                    \$inner->orWhere(\$column, 'like', '%' . \$search . '%');
                }
            });
        }

        foreach ((array) \$request->query('filter', []) as \$column => \$value) {
            if (! in_array(\$column, \$this->filterable, true) || \$value === null || \$value === '') {
                continue;
            }

            if (is_array(\$value)) {
                \$query->whereIn(\$column, \$value);
            } else {
                \$query->where(\$column, \$value);
            }
        }

        if (\$request->filled('date_from') && in_array('created_at', \$this->sortable, true)) {
            \$query->whereDate('created_at', '>=', \$request->query('date_from'));
        }

        if (\$request->filled('date_to') && in_array('created_at', \$this->sortable, true)) {
            \$query->whereDate('created_at', '<=', \$request->query('date_to'));
        }

        \$sortBy = (string) \$request->query('sort_by', '{$primary}');
        \$sortDir = strtolower((string) \$request->query('sort_dir', 'desc')) === 'asc' ? 'asc' : 'desc';

        if (! in_array(\$sortBy, \$this->sortable, true)) {
            \$sortBy = '{$primary}';
        }

        \$perPage = min(max((int) \$request->query('per_page', 25), 1), 100);

        return {$model}Resource::collection(
            \$query->orderBy(\$sortBy, \$sortDir)->paginate(\$perPage)
        );
    }

    public function store(StoreUpdate{$model}Request \$request): {$model}Resource
    {
        \${$routeParam} = {$model}::create(\$request->validated());

        return new {$model}Resource(\${$routeParam});
    }

    public function show({$model} \${$routeParam}): {$model}Resource
    {
        return new {$model}Resource(\${$routeParam});
    }

    public function update(StoreUpdate{$model}Request \$request, {$model} \${$routeParam}): {$model}Resource
    {
        \${$routeParam}->update(\$request->validated());

        return new {$model}Resource(\${$routeParam});
    }

    public function destroy({$model} \${$routeParam}): JsonResponse
    {
        \${$routeParam}->delete();

        return response()->json(['message' => '{$model} deleted successfully']);
    }
}

PHP;

        $this->write("app/Http/Controllers/Api/{$controller}.php", $code);
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

    private function validationRule(array $column): string
    {
        $rules = [$column['IS_NULLABLE'] === 'YES' ? 'nullable' : 'required'];
        $type = strtolower($column['DATA_TYPE']);

        if (in_array($type, ['tinyint'], true) && str_contains(strtolower($column['COLUMN_TYPE']), 'tinyint(1)')) {
            $rules[] = 'boolean';
        } elseif (in_array($type, ['int', 'integer', 'bigint', 'smallint', 'mediumint'], true)) {
            $rules[] = 'integer';
        } elseif (in_array($type, ['decimal', 'double', 'float', 'real'], true)) {
            $rules[] = 'numeric';
        } elseif (in_array($type, ['date'], true)) {
            $rules[] = 'date';
        } elseif (in_array($type, ['datetime', 'timestamp', 'time', 'year'], true)) {
            $rules[] = 'date';
        } elseif ($type === 'json') {
            $rules[] = 'array';
        } elseif (in_array($type, ['enum', 'set'], true)) {
            $values = $this->enumValues($column['COLUMN_TYPE']);
            if ($values !== []) {
                $rules[] = 'in:' . implode(',', $values);
            } else {
                $rules[] = 'string';
            }
        } else {
            $rules[] = 'string';
            if ($column['CHARACTER_MAXIMUM_LENGTH'] !== null && (int) $column['CHARACTER_MAXIMUM_LENGTH'] > 0) {
                $rules[] = 'max:' . (int) $column['CHARACTER_MAXIMUM_LENGTH'];
            }
        }

        return implode('|', $rules);
    }

    private function laravelCast(array $column): ?string
    {
        $type = strtolower($column['DATA_TYPE']);
        $columnType = strtolower($column['COLUMN_TYPE']);

        return match (true) {
            in_array($type, ['int', 'integer', 'bigint', 'smallint', 'mediumint'], true) => 'integer',
            $type === 'tinyint' && str_contains($columnType, 'tinyint(1)') => 'boolean',
            in_array($type, ['decimal', 'double', 'float', 'real'], true) => 'decimal:2',
            $type === 'json' => 'array',
            $type === 'date' => 'date',
            in_array($type, ['datetime', 'timestamp'], true) => 'datetime',
            default => null,
        };
    }

    private function enumValues(string $columnType): array
    {
        if (! preg_match("/^(enum|set)\\((.*)\\)$/i", $columnType, $matches)) {
            return [];
        }

        return str_getcsv($matches[2], ',', "'");
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

    private function primaryIsAutoIncrement(array $columns): bool
    {
        foreach ($columns as $column) {
            if ($column['COLUMN_KEY'] === 'PRI' && str_contains((string) $column['EXTRA'], 'auto_increment')) {
                return true;
            }
        }

        return false;
    }

    private function isTextColumn(array $column): bool
    {
        return in_array(strtolower($column['DATA_TYPE']), [
            'char', 'varchar', 'text', 'tinytext', 'mediumtext', 'longtext', 'enum', 'set',
        ], true);
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

    private function phpArray(array $items, int $indent): string
    {
        if ($items === []) {
            return '[]';
        }

        $space = str_repeat(' ', $indent);
        $lines = ['['];
        foreach ($items as $item) {
            $lines[] = $space . "'" . addslashes((string) $item) . "',";
        }
        $lines[] = str_repeat(' ', max($indent - 4, 0)) . ']';

        return implode(PHP_EOL, $lines);
    }

    private function phpAssocArray(array $items, int $indent): string
    {
        if ($items === []) {
            return '[]';
        }

        $space = str_repeat(' ', $indent);
        $lines = ['['];
        foreach ($items as $key => $value) {
            $lines[] = $space . "'" . addslashes((string) $key) . "' => '" . addslashes((string) $value) . "',";
        }
        $lines[] = str_repeat(' ', max($indent - 4, 0)) . ']';

        return implode(PHP_EOL, $lines);
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
]);

(new LaravelRestApiGenerator($options))->run();
