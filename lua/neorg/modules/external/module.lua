local neorg = require('neorg.core')

local namespace = 'external.neorg-velocity'
local EVENT_VELOCITY_LINK = 'velocity-link'

local module = neorg.modules.create(namespace)

module.config.public = {
    bind_enter_key = true,
}

module.setup = function()
    return {
        success = true,
        requires = {
            'core.keybinds',
            'core.keybinds.keybinds',
            'core.esupports.hop',
        },
    }
end

module.load = function()
    module.required['core.keybinds'].register_keybind(namespace, EVENT_VELOCITY_LINK)

    -- Bind <cr> to hop links
    if module.config.public.bind_enter_key then
        neorg.callbacks.on_event('core.keybinds.events.enable_keybinds', function(_, keybinds)
            keybinds.remap_event('norg', 'n', '<CR>', 'external.velocity-link.velocity-link')
        end)
    end
end

-- module.public = {
--     follow_link = function(node, split, link)
--         if not link then
--             module.required['core.esupports.hop'].follow_link(node, split, link)
--             return
--         end

--         if link.link_location_text then
--             -- Command links
--             if link.link_location_text:match('^%V:.+') then
--                 local cmd = link.link_location_text:gsub('^%V:', 'NV ')
--                 vim.cmd(cmd)
--                 return
--             end
--         end

--         module.required['core.esupports.hop'].follow_link(node, split, link)
--     end,
-- }

-- module.on_event = function(event)
--     local event_name = event.split_type[2]
--     local bufnr = event.buffer

--     if event_name == namespace .. '.' .. EVENT_VELOCITY_LINK then
--         local split = event.content[1]
--         local node = module.required['core.esupports.hop'].extract_link_node()

--         if node then
--             local link = module.required['core.esupports.hop'].parse_link(node, bufnr)
--             module.public.follow_link(node, split, link)
--         end
--     end
-- end

module.events.subscribed = {
    ['core.keybinds'] = {
        [namespace .. '.' .. EVENT_VELOCITY_LINK] = true,
    },
}

return module
