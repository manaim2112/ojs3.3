{* Sidebars *}
{if empty($isFullWidth)}
{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
{if $sidebarCode}
    <aside id="sidebar" class="pkp_structure_sidebar left w-full md:w-1/4 lg:w-1/5" role="complementary" aria-label="{translate|escape key="common.navigation.sidebar"}">
        {$sidebarCode}
    </aside>
{/if}
{/if}
