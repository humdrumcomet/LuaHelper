-----------------------------General
function printNum(num, reduce, decimal, form)
    local reduce = reduce or 1
    local form = form or 'sci'
    local decPl = decPl or '3'
    if math.abs(num/reduce)<1000 and math.abs(num/reduce)>1e-2 then
        return tex.sprint()
    else
        return tex.sprint(string.format("%0.4e", num/reduce))
    end
end
--function formatNum(num, reduce)
    --local reduce = reduce or 1
    --local form = form or 'sci'
    --local decPl = decPl or '3'
    --if form == 'sci' then
        --return string.format("%0.2f", num/reduce)
    --else
function procTblOpts(opts, curDepth)
    local curDepth = curDepth
    local fullOpts = {}
    local knownFunc = {
        itPyObj = 'itPyObj',
        itPyPair = 'itPyPair'
    }
    fullOpts['depth'] = tonumber(opts.depth) or 1
    fullOpts['pre'] = isInTbl(opts.pre, curDepth) or opts.pre or ''
    fullOpts['app'] = isInTbl(opts.app, curDepth) or opts.app or ''
    fullOpts['sep'] = isInTbl(opts.sep, curDepth) or opts.sep or ''
    local preWrap = isInTbl(opts.wrap, curDepth) or opts.wrap or ''
    fullOpts['wrap'] = knownFunc[preWrap] or 'simpIt'
    fullOpts['align'] = isInTbl(opts.align, curDepth) or alignOpts(curDepth) or ''
    return fullOpts
end
function printTable(tableItems, modifiers, curDepth)
    local curDepth = curDepth or 0
    local curDepth = curDepth+1
    local opts = procTblOpts(modifiers, curDepth)
    local pre = opts['pre']
    local app = opts['app']
    local sep = opts['sep']
    local wrap = loadstring('return '..opts['wrap']..'(...)')
    local align = opts['align']
    local depth = opts['depth']
    for i in wrap(tableItems) do
        if align=='vert' then
            tex.sprint(pre)
        end
        if curDepth<depth then
            printTable(i, modifiers, curDepth)
        else
            tex.sprint(i)
            if align=='horz' then
                tex.sprint(sep)
            end
        end
        if align=='vert' then
            tex.sprint(app)
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
    local tblItemRemoved = string.gsub(strItemRemoved, brackRm, '')
    for set in string.gmatch(tblItemRemoved, commaPat) do
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
function isInTbl(t, idx)
    if type(t) == 'table' then
        return t[idx]
    else
        return nil
    end
end
function alignOpts(curDepth)
    local curDepth = curDepth or 1
    if curDepth%2 == 1 then
        return 'vert'
    else
        return 'horz'
    end
end
