<?php

/**
 * @file plugins/generic/backlinkAudit/BacklinkAuditSchemaMigration.inc.php
 *
 * Copyright (c) 2026
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class BacklinkAuditSchemaMigration
 * @ingroup plugins_generic_backlinkAudit
 *
 * @brief Create the backlink audit log table.
 */

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Capsule\Manager as Capsule;

class BacklinkAuditSchemaMigration extends Migration {

	/**
	 * Run the migration.
	 */
	public function up() {
		if (!Capsule::schema()->hasTable('backlink_audit_log')) {
			Capsule::schema()->create('backlink_audit_log', function (Blueprint $table) {
				$table->bigInteger('audit_id')->autoIncrement();
				$table->datetime('created_at');
				$table->bigInteger('user_id')->nullable();
				$table->string('username', 255)->nullable();
				$table->string('user_email', 255)->nullable();
				$table->bigInteger('context_id')->nullable();
				$table->string('context_path', 64)->nullable();
				$table->string('source_type', 32);   // context | site | publication | input | scan
				$table->string('source_desc', 191);
				$table->bigInteger('object_id')->nullable();
				$table->string('action', 16);        // add | edit | attempt | scan
				$table->longText('links_json');
				$table->integer('link_count')->default(0);
				$table->integer('added_count')->default(0);
				$table->integer('removed_count')->default(0);
				$table->char('content_hash', 40);
				$table->longText('old_content')->nullable();
				$table->longText('new_content')->nullable();
				$table->string('ip', 64)->nullable();
				$table->string('user_agent', 255)->nullable();
				$table->index(['created_at'], 'backlink_audit_log_created_at');
				$table->index(['user_id'], 'backlink_audit_log_user_id');
				$table->index(['context_id'], 'backlink_audit_log_context_id');
				$table->index(['content_hash'], 'backlink_audit_log_content_hash');
			});
		}
	}

	/**
	 * Reverse the migration.
	 */
	public function down() {
		Capsule::schema()->dropIfExists('backlink_audit_log');
	}
}
