-----------------------------General
function printNum(num, reduce)
    reduce = reduce or 1
    if math.abs(num/reduce)<1000 and math.abs(num/reduce)>1e-2 then
        return tex.sprint(string.format("%0.2f", num/reduce))
    else
        return tex.sprint(string.format("%0.4e", num/reduce))
    end
end
function procTblOpts(opts)
    fullOpts = {}
    depth = opts.depth or 1
    knownFuncs = {
        itPyObj = 'itPyObj',
        itPyPair = 'itPyPair'
    }
    if depth==1 then
        fullOpts['pre'] = opts.pre or ''
        fullOpts['app'] = opts.app or ''
        fullOpts['sep'] = opts.sep or ''
        local wrap = knownFunc[opts.wrap] or 'simpIt'
        fullOpts['wrap'] = loadstring('return '..wrap..'(...)')
        fullOpts['align'] = opts.align or 'vert'
    elseif depth>1 then
        for i = 1, depth, 1 do
            if 
        end
    end
end
function printTable(tableItems, modifiers)
    print('----------in print')
    opts = procTblOpts(modifiers)
    pre= modifiers.pre or ''
    app= modifiers.app or ''
    sep= modifiers.sep or ''
    slice = modifiers.slice or ''
    modifiers.depth = modifiers.depth or 1
    modifiers.depth = modifiers.depth-1
    depth = modifiers.depth
    wrap = modifiers.wrap or 'simpIt'
    call = loadstring('return '..wrap..'(...)')
    if not modifiers.curDepth then
        modifiers.curDepth = 1
    else
        modifiers.curDepth = modifiers.curDepth+1
    end
    curDepth = modifiers.curDepth
    if curDept==1 then
        align=modifiers.align or 'vert'
    elseif curDept==2 then
        align=modifiers.align or 'horz'
    end
    for i in call(tableItems) do
        if align=='vert' then
            tex.sprint(prepend)
        end
        if depth>0 then
            printTable(i, modifiers)
        else
            tex.sprint(i)
            if align=='horz' then
                tex.sprint(sep)
            end
        end
        if align=='vert' then
            tex.sprint(pre)
            tex.print('')
        end
    end
end
function optsToTable(opts)
    if opts == 'empty' then
        return {}
    end
    local interTbl = {}
    local inputs = {}
    local quotePat = "(%w+)%s*=%s*(%b''),*"
    local quoteRm = "%w+%s*=%s*%b'',*"
    local brackPat = '(%w+)%s*=%s*(%b{}),*'
    local brackRm = '%w+%s*=%s*%b{},*'
    local commaPat = '([^,]+)'
    local equalsPat = '(%w+)%s*=%s*(.*),*'
    for key, value in string.gmatch(opts, quotePat) do
        local inter = string.gsub(value, "'$", "")
        local item = string.gsub(inter, "^'", "")
        inputs[key] = item
    end
    for key, value in string.gmatch(opts, brackPat) do
        inputs[key] = commaSepValToTbl(value)
    end
    local strItemRemoved = string.gsub(opts, quoteRm, '')
    local tblItemRemoved = string.gsub(strItemsRemoved, brackRm, '')
    for set in string.gmatch(item, commaPat) do
        for key, value in string.gmatch(set, equalsPat) do
            inputs[key] = value
        end
    end
    return inputs
end
function simpIt(tbl)
    local index = 0
    local count = #tbl

    return function()
        index = index+1
        if index <= count then
            return tbl[index]
        end
    end
end
function commaSepValToTbl(commaStr)
    local returnTbl = {}
    local commaPat = '([^,]+)'
    local inter = string.gsub(commaStr, "}$", "")
    local item = string.gsub(inter, "^{", "")
    for idx, value in string.gmatch(item, commaPat) do
        local noTrailing = string.gsub(value, "'$", "")
        local noLeading = string.gsub(inter, "^'", "")
        returnTbl[idx] = item
    end
    return returnTbl
end
