const breakpoints = [5]
const filename = "juno.jl"

module Exec end

const lines = open(filename) do file; [eachline(file)...] end
lineno = 1
while true
    global lineno
    for line in @view lines[lineno:end]
        if (lineno in breakpoints)
            filter!(b -> b ≠ lineno, breakpoints)
            break
        else
            Exec.eval(Meta.parse(line))
            lineno += 1
        end
    end
    lineno < length(lines) || break
    readline()
end
