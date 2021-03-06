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
    fullOpts.depth = tonumber(opts.depth) or 1
    fullOpts.pre = isInTbl(opts.pre, curDepth) or opts.pre or ''
    fullOpts.app = isInTbl(opts.app, curDepth) or opts.app or ''
    fullOpts.sep = isInTbl(opts.sep, curDepth) or opts.sep or ''
    fullOpts.iterType = isInTbl(opts.iterType, curDepth) or opts.iterType or 'pairs'
    fullOpts.align = isInTbl(opts.align, curDepth) or alignOpts(curDepth) or ''
    fullOpts.format = opts.formatVal or 'empty'
    fullOpts.iterAdd = opts.iterAdd or {}
    return fullOpts
end

function printData(tableItems, modifiers, curDepth)
    local curDepth = curDepth or 0
    local curDepth = curDepth+1
    local opts = procTblOpts(modifiers, curDepth)
    local pre = opts.pre
    local app = opts.app
    local sep = opts.sep
    local align = opts.align
    local depth = opts.depth
    local formatOpts = opts.format
    local count = 0
    local iterType = opts.iterType
    local iterTypeTable = {
        ['ipairs'] = ipairs,
        ['pairs'] = pairs,
        ['none'] = doNothing,
    }
    for k,v in pairs(opts.iterAdd) do 
        iterTypeTable[k] = v 
    end
    for k,v in iterTypeTable[iterType](tableItems) do
        count = count+1
        local formatOptsCount = formatOpts[count] or formatOpts
        local formatOptsCount = optsToTable(formatOptsCount)
        if align=='vert' then
            tex.sprint(pre)
            print(pre)
        end
        if curDepth<depth then
            printData(v, modifiers, curDepth)
        else
            if align=='horz' and count>1 then
                tex.sprint(sep)
                print(sep)
            end
            if next(formatOptsCount) == nil then
                tex.sprint(v)
                print(v)
            else
                tex.sprint(formatNum(v, formatOptsCount))
                print(v)
            end
        end
        if align=='vert' then
            tex.sprint(app)
            print(app)
            tex.print('')
        end
    end
end

function printTable(tableItems, opts)
    local position = opts.pos or 'htbp'
    local caption = opts.cap or 'Missing'
    local format = opts.format
    local header = opts.header
    opts.sep = [[&]]
    opts.pre = [[\\\hline]]
    tex.sprint([[\begin{table}[]]..position..
        [[]\centering \caption{]]..caption..
        [[}\begin{tabular}{]]..format..[[}]])
    for k,v in ipairs(header) do
        tex.sprint(v)
        if k<#header then
            tex.sprint([[&]])
        end
    end
    printData(tableItems, opts)
    tex.sprint([[\end{tabular}\label{tab:]]..
    opts.label..[[}\end{table}]])
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
        print(inputs[key])
    end
    for key, value in string.gmatch(opts, brackPat) do
        inputs[key] = commaSepValToTbl(value)
        print(inputs[key])
    end
    local strItemRemoved = string.gsub(opts, quoteRm, '')
    local tblItemRemoved = string.gsub(strItemRemoved, brackRm, '')
    for set in string.gmatch(tblItemRemoved, commaPat) do
        for key, value in string.gmatch(set, equalsPat) do
            inputs[key] = value
            print(inputs[key])
        end
    end
    return inputs
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

function doNothing(passthrough)
    return passthrough
end
