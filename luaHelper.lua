-----------------------------General
function formatNum(num, opts)
    local formTbl ={
        sci= 'e',
        flt= 'f'
    }
    local reduce = opts.reduce or 1
    local form = formTbl[opts.form] or 'e'
    local decPl = opts.decPl or '3'
    return string.format("%0."..decPl..form, num/reduce)
end
function procTblOpts(opts, curDepth)
    local curDepth = curDepth
    local fullOpts = {}
    local knownFunc = {
        itPyObj = 'itPyObj',
        itPyPair = 'itPyPair'
    }
    fullOpts.depth = tonumber(opts.depth) or 1
    fullOpts.pre = isInTbl(opts.pre, curDepth) or opts.pre or ''
    fullOpts.app = isInTbl(opts.app, curDepth) or opts.app or ''
    fullOpts.sep = isInTbl(opts.sep, curDepth) or opts.sep or ''
    local preWrap = isInTbl(opts.wrap, curDepth) or opts.wrap or ''
    fullOpts.wrap = knownFunc[preWrap] or 'simpIt'
    fullOpts.align = isInTbl(opts.align, curDepth) or alignOpts(curDepth) or ''
    fullOpts.format = opts.formatVal or 'empty'
    return fullOpts
end
function printTable(tableItems, modifiers, curDepth)
    local curDepth = curDepth or 0
    local curDepth = curDepth+1
    local opts = procTblOpts(modifiers, curDepth)
    local pre = opts.pre
    local app = opts.app
    local sep = opts.sep
    local wrap = loadstring('return '..opts.wrap..'(...)')
    local align = opts.align
    local depth = opts.depth
    local formatOpts = opts.format
    local count = 0
    for i in wrap(tableItems) do
        count = count+1
        local formatOptsCount = formatOpts[count] or formatOpts
        local formatOptsCount = optsToTable(formatOptsCount)
        if align=='vert' then
            tex.sprint(pre)
        end
        if curDepth<depth then
            printTable(i, modifiers, curDepth)
        else
            if align=='horz' and count>1 then
                tex.sprint(sep)
            end
            if next(formatOptsCount) == nil then
                tex.sprint(i)
            else
                tex.sprint(formatNum(i, formatOptsCount))
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
    local valStore = ''
    local storeCount = 0
    local quoteCount = 0
    for value in string.gmatch(item, commaPat) do
        if string.match(value, "^'") and not string.match(value, "'$") then
            valStore = value..','
            quoteCount = 1
        elseif string.match(value, "'$") then
            valStore = valStore..value
            quoteCount = 0
            storeCount = storeCount+1
            local noTrailing = string.gsub(valStore, "'$", "")
            local noLeading = string.gsub(noTrailing, "^'", "")
            returnTbl[storeCount] = noLeading
            valStore = ''
        elseif quoteCount>0 then
            valStore = valStore..value..','
        else
            storeCount = storeCount+1
            returnTbl[storeCount] = value
            print(returnTbl[storeCount])
        end
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
