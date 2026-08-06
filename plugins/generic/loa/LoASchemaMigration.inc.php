<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Builder;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Capsule\Manager as Capsule;

class LoASchemaMigration extends Migration {

	public function up() {
		if (!Capsule::schema()->hasTable('article_loa_codes')) {
			Capsule::schema()->create('article_loa_codes', function (Blueprint $table) {
				$table->bigInteger('loa_id')->autoIncrement();
				$table->bigInteger('journal_id');
				$table->bigInteger('submission_id');
				$table->string('unique_code', 100);
				$table->datetime('date_generated');
				$table->datetime('date_downloaded')->nullable();
				$table->string('status', 20)->default('active');
				$table->bigInteger('generated_by')->nullable();
				$table->bigInteger('template_id')->nullable();
				$table->longText('content_snapshot')->nullable();
				$table->index(['journal_id'], 'article_loa_codes_journal_id');
				$table->unique(['unique_code'], 'article_loa_codes_unique_code');
			});
		} else {
			if (!Capsule::schema()->hasColumn('article_loa_codes', 'generated_by')) {
				Capsule::schema()->table('article_loa_codes', function (Blueprint $table) {
					$table->bigInteger('generated_by')->nullable();
				});
			}
			if (!Capsule::schema()->hasColumn('article_loa_codes', 'template_id')) {
				Capsule::schema()->table('article_loa_codes', function (Blueprint $table) {
					$table->bigInteger('template_id')->nullable();
				});
			}
			if (!Capsule::schema()->hasColumn('article_loa_codes', 'content_snapshot')) {
				Capsule::schema()->table('article_loa_codes', function (Blueprint $table) {
					$table->longText('content_snapshot')->nullable();
				});
			}
			try {
				Capsule::schema()->table('article_loa_codes', function (Blueprint $table) {
					$table->dropIndex('article_loa_codes_unique_code');
				});
			} catch (\Exception $e) {
			}
			try {
				$indexes = Capsule::connection()->getDoctrineSchemaManager()->listTableIndexes('article_loa_codes');
				$hasUnique = false;
				foreach ($indexes as $index) {
					if (strtolower((string) $index->getName()) === 'article_loa_codes_unique_code') {
						$hasUnique = $index->isUnique();
						break;
					}
				}
				if (!$hasUnique) {
					Capsule::schema()->table('article_loa_codes', function (Blueprint $table) {
						$table->unique('unique_code', 'article_loa_codes_unique_code');
					});
				}
			} catch (\Exception $e) {
			}
		}

		if (!Capsule::schema()->hasTable('loa_templates')) {
			Capsule::schema()->create('loa_templates', function (Blueprint $table) {
				$table->bigInteger('loa_template_id')->autoIncrement();
				$table->bigInteger('journal_id');
				$table->string('template_name', 255);
				$table->longText('template_content');
				$table->boolean('is_active')->default(false);
				$table->datetime('date_modified');
				$table->index(['journal_id'], 'loa_templates_journal_id');
			});
		}
	}

	public function down() {
		Capsule::schema()->dropIfExists('loa_templates');
		Capsule::schema()->dropIfExists('article_loa_codes');
	}
}
