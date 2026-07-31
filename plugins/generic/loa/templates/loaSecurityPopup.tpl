<style>
	#loa-security-modal-overlay {
		position: fixed;
		top: 0;
		left: 0;
		width: 100vw;
		height: 100vh;
		background: rgba(15, 23, 42, 0.7);
		backdrop-filter: blur(6px);
		-webkit-backdrop-filter: blur(6px);
		z-index: 999999;
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 20px;
		box-sizing: border-box;
		animation: loaFadeIn 0.3s ease-out;
	}

	#loa-security-modal-container {
		background: #ffffff;
		width: 100%;
		max-width: 620px;
		border-radius: 16px;
		box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.35);
		overflow: hidden;
		display: flex;
		flex-direction: column;
		max-height: 85vh;
		animation: loaSlideUp 0.35s cubic-bezier(0.16, 1, 0.3, 1);
		font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
	}

	#loa-security-modal-header {
		background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
		color: #ffffff;
		padding: 16px 24px;
		display: flex;
		align-items: center;
		justify-content: space-between;
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	}

	.loa-modal-title-wrapper {
		display: flex;
		align-items: center;
		gap: 12px;
	}

	.loa-modal-icon {
		display: flex;
		align-items: center;
		justify-content: center;
		width: 34px;
		height: 34px;
		background: rgba(59, 130, 246, 0.2);
		color: #60a5fa;
		border-radius: 10px;
	}

	.loa-modal-title {
		margin: 0;
		font-size: 1.1rem;
		font-weight: 600;
		color: #ffffff;
		line-height: 1.3;
	}

	.loa-modal-close-btn {
		background: rgba(255, 255, 255, 0.1);
		border: none;
		color: #94a3b8;
		width: 32px;
		height: 32px;
		border-radius: 50%;
		display: flex;
		align-items: center;
		justify-content: center;
		cursor: pointer;
		transition: all 0.2s ease;
	}

	.loa-modal-close-btn:hover {
		background: rgba(255, 255, 255, 0.2);
		color: #ffffff;
	}

	#loa-security-modal-body {
		padding: 24px;
		overflow-y: auto;
		color: #334155;
		font-size: 0.95rem;
		line-height: 1.65;
		word-break: break-word;
	}

	#loa-security-modal-body p {
		margin-top: 0;
		margin-bottom: 1em;
	}

	#loa-security-modal-body p:last-child {
		margin-bottom: 0;
	}

	#loa-security-modal-footer {
		padding: 14px 24px;
		background: #f8fafc;
		border-top: 1px solid #e2e8f0;
		display: flex;
		justify-content: flex-end;
		align-items: center;
	}

	.loa-modal-btn-primary {
		background: #2563eb;
		color: #ffffff;
		border: none;
		padding: 9px 22px;
		border-radius: 8px;
		font-size: 0.9rem;
		font-weight: 500;
		cursor: pointer;
		transition: background-color 0.2s ease, transform 0.1s ease;
	}

	.loa-modal-btn-primary:hover {
		background: #1d4ed8;
	}

	.loa-modal-btn-primary:active {
		transform: scale(0.98);
	}

	@keyframes loaFadeIn {
		from { opacity: 0; }
		to { opacity: 1; }
	}

	@keyframes loaSlideUp {
		from { opacity: 0; transform: translateY(20px) scale(0.97); }
		to { opacity: 1; transform: translateY(0) scale(1); }
	}
</style>

<div id="loa-security-modal-overlay">
	<div id="loa-security-modal-container" role="dialog" aria-modal="true" aria-labelledby="loa-modal-title-text">
		<div id="loa-security-modal-header">
			<div class="loa-modal-title-wrapper">
				<div class="loa-modal-icon">
					<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
						<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
					</svg>
				</div>
				<h3 id="loa-modal-title-text" class="loa-modal-title">{$loaSecurityTitle|escape}</h3>
			</div>
			<button type="button" class="loa-modal-close-btn" id="loa-modal-close-x" aria-label="Close">
				<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
					<line x1="18" y1="6" x2="6" y2="18"></line>
					<line x1="6" y1="6" x2="18" y2="18"></line>
				</svg>
			</button>
		</div>
		<div id="loa-security-modal-body">
			{$loaSecurityContent}
		</div>
		<div id="loa-security-modal-footer">
			<button type="button" class="loa-modal-btn-primary" id="loa-modal-close-btn">{translate key="plugins.generic.loa.cancel"|default:"Tutup"}</button>
		</div>
	</div>
</div>

<script>
(function() {
	function closeLoaSecurityModal() {
		var overlay = document.getElementById('loa-security-modal-overlay');
		if (overlay) {
			overlay.style.transition = 'opacity 0.25s ease';
			overlay.style.opacity = '0';
			setTimeout(function() {
				if (overlay && overlay.parentNode) {
					overlay.parentNode.removeChild(overlay);
				}
			}, 250);
		}
	}

	document.addEventListener('DOMContentLoaded', function() {
		var closeX = document.getElementById('loa-modal-close-x');
		var closeBtn = document.getElementById('loa-modal-close-btn');
		var overlay = document.getElementById('loa-security-modal-overlay');

		if (closeX) {
			closeX.addEventListener('click', closeLoaSecurityModal);
		}
		if (closeBtn) {
			closeBtn.addEventListener('click', closeLoaSecurityModal);
		}
		if (overlay) {
			overlay.addEventListener('click', function(e) {
				if (e.target === overlay) {
					closeLoaSecurityModal();
				}
			});
		}

		document.addEventListener('keydown', function(e) {
			if (e.key === 'Escape' || e.keyCode === 27) {
				closeLoaSecurityModal();
			}
		});
	});
})();
</script>
