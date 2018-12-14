-- list of operator pairs to be matched
delimeters = { ['<'] = '>',
              ['('] = ')',
              ['{'] = '}',
              ['['] = ']'
}

for k,v in pairs(delimeters) do
	vis:map(vis.modes.INSERT, k, function()
		inserted = false
		vis:info(k)
		vis:insert(k..v)
		vis:feedkeys("<Left>")
		inserted = true
		return 1
	end)
	vis:map(vis.modes.INSERT, v, function()
		local pos = vis.win.selection.pos
		local file = vis.win.file
		local curr_char = file:content(pos, 1)
		if curr_char == v and inserted == true then
			vis.win.selection.pos = pos + 1
		else vis:insert(v)
		end
	end)

end

function keyExistsIn(t, key)
	return t[key] ~= nil
end

function valueExistsIn(t, value)
	for _,v in pairs(t) do
		if value == v then return true end
	end
	return false
end

vis:map(vis.modes.INSERT, '<Backspace>', function()
	vis:info("you typed a backspace")
	local sel = vis.win.selection
	local pos = sel.pos
	local file = vis.win.file
	local prev_char = file:content(pos-1, 1)
	local curr_char = file:content(pos  , 1)
	if valueExistsIn(delimeters, curr_char) and keyExistsIn(delimeters, prev_char) then
		vis:feedkeys('<Delete><C-h>')
	else vis:feedkeys('<C-h>')
	end
end)
