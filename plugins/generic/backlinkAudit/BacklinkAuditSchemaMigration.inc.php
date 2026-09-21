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
 * @brief Create the backlink audit log table and the role/user snapshots
 * used to detect privilege changes (OJS 3.3 fires no hook when a user is
 * assigned to a user group, so membership has to be diffed).
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
				$table->string('source_type', 32);   // context | site | publication | input | scan | role | user
				$table->string('source_desc', 191);
				$table->bigInteger('object_id')->nullable();
				$table->string('action', 16);        // add | edit | attempt | scan | role_change | user_change | bootstrap | tamper
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

		// Last observed (user_id, user_group_id) membership. Diffing this
		// against the live table is the only way to notice a privilege
		// change, because OJS 3.3 fires no hook on user-group assignment and
		// user_user_groups carries no timestamp.
		if (!Capsule::schema()->hasTable('backlink_audit_role_snapshot')) {
			Capsule::schema()->create('backlink_audit_role_snapshot', function (Blueprint $table) {
				$table->bigInteger('user_id');
				$table->bigInteger('user_group_id');
				$table->unique(['user_id', 'user_group_id'], 'backlink_audit_role_snapshot_uniq');
				$table->index(['user_group_id'], 'backlink_audit_role_snapshot_group');
			});
		}

		// Last observed account state, so account takeovers (email swap,
		// password reset, account re-enabled) show up alongside role changes.
		if (!Capsule::schema()->hasTable('backlink_audit_user_snapshot')) {
			Capsule::schema()->create('backlink_audit_user_snapshot', function (Blueprint $table) {
				$table->bigInteger('user_id')->primary();
				$table->string('username', 255)->nullable();
				$table->string('email', 255)->nullable();
				$table->smallInteger('disabled')->default(0);
				// sha1 of the stored password hash: detects a reset without
				// keeping anything that could be used to authenticate.
				$table->char('password_fp', 40)->nullable();
			});
		}
	}

	/**
	 * Reverse the migration.
	 */
	public function down() {
		Capsule::schema()->dropIfExists('backlink_audit_role_snapshot');
		Capsule::schema()->dropIfExists('backlink_audit_user_snapshot');
		Capsule::schema()->dropIfExists('backlink_audit_log');
	}
}
