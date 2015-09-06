-- ; Author: Alundaio

require'gui'
require'xray'
require'matrix'
require'action_unpack'
require'action_repack'
require'action_merge'
require'action_save_section_to_system_ltx'

---------------
-- Initialize
---------------
local function init()
	initialize_gui()
end

function finalize()
	if (gErrorLog) then
		gErrorLog:close()
	end
end

----------------------------------------------------------------------------------------
-- 										MAIN EXECUTION
----------------------------------------------------------------------------------------
do
	init()
	printf("FINISHED Errors:%s",ERROR_COUNT)
end