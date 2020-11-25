-----------------------------General
function printNum(num, reduce)
    reduce = reduce or 1
    if math.abs(num/reduce)<1000 and math.abs(num/reduce)>1e-2 then
        return tex.sprint(string.format("%0.2f", num/reduce))
    else
        return tex.sprint(string.format("%0.4e", num/reduce))
    end
end
function optsToTable(opts)
    print(opts)
    if opts == 'empty' then
        return ''
    end
    inputs = {}
    for set in string.gmatch(opts, '([^,]+)') do
        print('in loop')
        print(set)
        for key, value in string.gmatch(set, '(%w+)%s*=%s*(.*),*') do
            print(key)
            print(value)
            inputs[key] = value
        end
    end
    return inputs
end
