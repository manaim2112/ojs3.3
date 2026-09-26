{**
 * plugins/generic/backlinkAudit/templates/report.tpl
 *
 * Backlink audit report — manager / site admin only.
 *}

{extends file="layouts/backend.tpl"}

{block name="page"}

	<div class="pkp_page_content pkp_content_admin">

		<h1 class="app__pageHeading">
			{translate key="plugins.generic.backlinkAudit.report.title"}
		</h1>

		<p>{translate key="plugins.generic.backlinkAudit.report.description"}</p>

		{if $scannedCount}
			<div class="pkpNotification pkpNotification--success" style="border-left:4px solid #16a34a;padding:.75rem 1rem;background:#f0fdf4;margin-bottom:1rem;">
				{translate key="plugins.generic.backlinkAudit.report.scanned" count=$scannedCount}
			</div>
		{/if}

		<div style="margin-bottom:1rem;display:flex;gap:.5rem;flex-wrap:wrap;">
			{if $isSiteAdmin}
				<form method="post" action="{$scanUrl|escape}" style="display:inline;">
					<input type="hidden" name="csrfToken" value="{$csrfToken|escape}">
					<button type="submit" class="pkpButton" onclick="this.disabled=true;">
						{translate key="plugins.generic.backlinkAudit.report.scan"}
					</button>
				</form>
			{/if}
			<a class="pkpButton pkpButtonOffset" href="{$exportUrl|escape}">
				{translate key="plugins.generic.backlinkAudit.report.export"}
			</a>
		</div>

		<table class="pkpTable" style="width:100%;border-collapse:collapse;font-size:0.85rem;">
			<thead>
				<tr style="text-align:left;border-bottom:2px solid #ccc;">
					<th scope="col" style="padding:.5rem;">{translate key="plugins.generic.backlinkAudit.col.date"}</th>
					<th scope="col" style="padding:.5rem;">{translate key="plugins.generic.backlinkAudit.col.user"}</th>
					<th scope="col" style="padding:.5rem;">{translate key="plugins.generic.backlinkAudit.col.journal"}</th>
					<th scope="col" style="padding:.5rem;">{translate key="plugins.generic.backlinkAudit.col.source"}</th>
					<th scope="col" style="padding:.5rem;">{translate key="plugins.generic.backlinkAudit.col.links"}</th>
					<th scope="col" style="padding:.5rem;">{translate key="plugins.generic.backlinkAudit.col.ip"}</th>
				</tr>
			</thead>
			<tbody>
				{if $entries->wasEmpty()}
					<tr>
						<td colspan="6" style="padding:1rem;text-align:center;color:#666;">
							{translate key="plugins.generic.backlinkAudit.report.empty"}
						</td>
					</tr>
				{else}
					{iterate from=entries item=entry}
						<tr style="border-bottom:1px solid #eee;vertical-align:top;">
							<td style="padding:.5rem;white-space:nowrap;">
								{$entry->created_at|substr:0:16|escape}
								<br>
								<span style="font-size:0.7rem;padding:.1rem .4rem;border-radius:3px;{if $entry->action eq 'tamper'}background:#7f1d1d;color:#fff;{elseif $entry->action eq 'attempt'}background:#fef3c7;{elseif $entry->action eq 'add'}background:#dcfce7;{elseif $entry->action eq 'edit'}background:#dbeafe;{elseif $entry->action eq 'role_change'}background:#fee2e2;{elseif $entry->action eq 'user_change'}background:#ffedd5;{else}background:#e5e7eb;{/if}">
									{$entry->action|escape}
								</span>
							</td>
							<td style="padding:.5rem;">
								{if $entry->user_id}
									<strong>#{$entry->user_id|escape} {$entry->username|escape}</strong>
									<br><small>{$entry->user_email|escape}</small>
								{else}
									<em>{$entry->username|escape}</em>
								{/if}
							</td>
							<td style="padding:.5rem;">{$entry->context_path|escape}{if $entry->context_id}<br><small>id={$entry->context_id|escape}</small>{/if}</td>
							<td style="padding:.5rem;">
								<small><code>{$entry->source_type|escape}:{$entry->source_desc|escape}</code></small>
							</td>
							<td style="padding:.5rem;">
								{if $entry->added_count gt 0}<span style="color:#16a34a;">+{$entry->added_count|escape}</span>{/if}
								{if $entry->removed_count gt 0}&nbsp;<span style="color:#dc2626;">-{$entry->removed_count|escape}</span>{/if}
								<ul style="margin:.25rem 0 0 1rem;padding:0;">
									{foreach from=$entry->links item=link}
										<li style="margin-bottom:.15rem;">
											{if $link.href}
												<a href="{$link.href|escape}" rel="nofollow noreferrer noopener" target="_blank"
													style="{if $link.is_external}color:#b91c1c;font-weight:bold;{/if}{if $link.suspicious}background:#fee2e2;{/if}">
													{$link.href|escape}
												</a>
												{if $link.text && $link.text ne $link.href}<br><small style="color:#555;">&ldquo;{$link.text|escape}&rdquo;</small>{/if}
												{if $link.is_external}<span style="font-size:0.65rem;background:#fee2e2;color:#991b1b;padding:0 .3rem;border-radius:2px;margin-left:.25rem;">EXTERNAL</span>{/if}
												{if $link.suspicious}<span style="font-size:0.65rem;background:#7f1d1d;color:#fff;padding:0 .3rem;border-radius:2px;margin-left:.25rem;">DANGEROUS</span>{/if}
											{else}
												{* Role / account changes carry labels instead of URLs *}
												<span style="font-weight:bold;{if $link.text|substr:0:1 eq '-'}color:#dc2626;{elseif $link.text|substr:0:1 eq '+'}color:#16a34a;{/if}">{$link.text|escape}</span>
											{/if}
										</li>
									{/foreach}
								</ul>
								{if $entry->action eq 'role_change' || $entry->action eq 'user_change'}
									<div style="margin-top:.4rem;font-size:0.72rem;color:#555;background:#f9fafb;border-left:3px solid #d1d5db;padding:.3rem .5rem;">
										<strong>{translate key="plugins.generic.backlinkAudit.detail.before"}:</strong>
										{if $entry->old_content}{$entry->old_content|escape}{else}-{/if}
										<br>
										<strong>{translate key="plugins.generic.backlinkAudit.detail.after"}:</strong>
										{if $entry->new_content}{$entry->new_content|escape}{else}-{/if}
									</div>
								{/if}
							</td>
							<td style="padding:.5rem;">
								{$entry->ip|escape}
								{if $entry->user_agent}<br><small style="color:#777;" title="{$entry->user_agent|escape}">{$entry->user_agent|truncate:40|escape}</small>{/if}
							</td>
						</tr>
					{/iterate}
				{/if}
			</tbody>
		</table>

		<div style="margin-top:1rem;">
			{page_links name="backlinkAudit" iterator=$entries}
		</div>

	</div>

{/block}
