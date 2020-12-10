-----------------------------General
function printNum(num, reduce)
    reduce = reduce or 1
    if math.abs(num/reduce)<1000 and math.abs(num/reduce)>1e-2 then
        return tex.sprint(string.format("%0.2f", num/reduce))
    else
        return tex.sprint(string.format("%0.4e", num/reduce))
    end
end
function printTable(tableItems, modifiers)
    print('----------in print')
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
    interTbl = {}
    inputs = {}
    quotePat = "(%w+)%s*=%s*(%b''),*"
    quoteRm = "%w+%s*=%s*%b'',*"
    brackPat = '(%w+)%s*=%s*(%b{}),*'
    brackRm = '%w+%s*=%s*%b{},*'
    commaPat = '([^,]+)'
    equalsPat = '(%w+)%s*=%s*(.*),*'
    for key, value in string.gmatch(opts, quotePat) do
        inter = string.gsub(value, "'$", "")
        item = string.gsub(inter, "^'", "")
        inputs[key] = item
    end
    for key, value in string.gmatch(opts, brackPat) do
        inputs[key] = {}
        inter = string.gsub(value, "}$", "")
        item = string.gsub(inter, "^{", "")
        for set in string.gmatch(item, commaPat) do
            table.insert(inputs[key], set)
        end
    end
    inter = string.gsub(opts, quoteRm, '')
    item = string.gsub(inter, brackRm, '')
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
