-- list of operator pairs to be matched
local operators = { ['<'] = '>', ['('] = ')', ['{'] = '}', ['['] = ']' }

-- to check if a pair has been inserted


local function tableKeyExists(t, key)
	value = t[key]
	return t[key] ~= nil -- returns true if set contains key
end

local function tableValueExists(t, val)
	for key, value in pairs(t) do
		if value == val then
			return true
		end
	end
	return false
end


-- insert the balanced operator
vis.events.subscribe(vis.events.INPUT, function(char)
	local pos = vis.win.selection.pos
	if tableKeyExists(operators, char) then
		vis.win.file:insert(pos, char..operators[char])
		vis.win.selection.pos = pos + 1
		return true
	else return false
	end
end)

vis:map(vis.modes.INSERT, "<Backspace>", function(keys)
	local pos = vis.win.selection.pos
	local file = vis.win.file
	current_char = file:content(pos, 1)
	if pos >= 1 then
		previous_char = file:content(pos-1, 1)
	end
	if tableValueExists(operators, current_char) and tableKeyExists(operators, previous_char) then
		file:delete(pos-1, 2)
		vis.win.selection.pos = pos - 1
		return #keys
	else
		if pos <= 0 then
			return #keys
		end
		file:delete(pos-1, 1)
		vis.win.selection.pos = pos - 1
		return #keys
	end
end)

local action = vis:action_register("Unbalanced-insert", function(char)
	local pos = vis.win.selection.pos
	local file = vis.win.file
	current_char = file:content(pos, 1)
	if tableKeyExists(operators, char) and tableValueExists(operators, current_char) then
		file:delete(pos, 1)
		vis.win.selection.pos = pos
	else
		vis:insert(char)
	end
	return #char
end, "Undo the automatic insertion of a matching operator")

-- for k,v in pairs(operators) do
	-- vis:map(vis.modes.INSERT, k, action)
-- end
