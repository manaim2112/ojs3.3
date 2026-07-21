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
				$table->unique(['submission_id', 'status'], 'article_loa_codes_submission_status');
				$table->index(['journal_id'], 'article_loa_codes_journal_id');
				$table->index(['unique_code'], 'article_loa_codes_unique_code');
			});
		} else {
			if (!Capsule::schema()->hasColumn('article_loa_codes', 'generated_by')) {
				Capsule::schema()->table('article_loa_codes', function (Blueprint $table) {
					$table->bigInteger('generated_by')->nullable();
				});
			}
		}
	}

	public function down() {
		Capsule::schema()->dropIfExists('article_loa_codes');
	}
}
