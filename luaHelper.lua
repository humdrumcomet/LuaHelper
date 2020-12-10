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
    modifier.curDepth = modifiers.curDepth+1 or 1
    curDepth = modifiers.curDepth
    pre= modifiers.pre or ''
    app= modifiers.app or ''
    sep= modifiers.sep or ''
    slice = modifiers.slice or ''
    depth = modifiers.depth-1 or 0
    modifiers.depth = depth
    align= modifiers.align or 'vert'
    for i in tableItems do
        tex.sprint(prepend)
        if depth>0 then
            printTable(i, modifiers)
        else
            tex.sprint(i)
        end
        tex.print(append)
        if align == 'vert' then
            tex.print('')
        end
        --print('test')
        --if then
        --  tex.print()
        --  tex.sprint()
        --else
        --end
    end
end
function optsToTable(opts)
    if opts == 'empty' then
        return ''
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
